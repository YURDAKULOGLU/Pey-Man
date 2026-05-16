function result = runPeyManPipeline(options)
%RUNPEYMANPIPELINE Load sensor data, classify activity, score the workout, and plot.

arguments
    options struct = struct()
end

options = withDefault(options, "demoMode", true);
options = withDefault(options, "useML", true);
options = withDefault(options, "baselineSeconds", 60);
options = withDefault(options, "windowSeconds", 4);
options = withDefault(options, "windowOverlap", 0.75);
options = withDefault(options, "bodyMassKg", 70);
options = withDefault(options, "strideLengthM", 0.72);
options = withDefault(options, "enableCoachApi", false);
options = withDefault(options, "coachModel", "gpt-4o-mini");
options = withDefault(options, "renderPlots", true);

session = resolveSession(options);
processed = preprocessSignal(session);
windows = windowizeSignal(processed, options.windowSeconds, options.windowOverlap);
features = extractFeatures(session, processed, windows);

activityLogFile = getOption(options, "activityLogFile", "");
if ~options.useML
    activityLogFile = "";
end
model = resolveModel(options, activityLogFile);
features = classifyActivity(features, model);

baseline = computeBaseline(features, options.baselineSeconds);
[fatigueIndex, fatigueTimeline] = computeFatigueIndex(features, baseline);
[cadenceSpm, cadenceByWindow] = computeCadence(features);
stepsDistance = computeStepsDistance(session, features, cadenceByWindow, options);
[calories, caloriesByActivity, sportSummary] = computeCalories(features, options);
qualityScore = computeQualityScore(features, fatigueIndex);
confidenceIndex = computeConfidenceIndex(session, features);
[currentActivity, currentConfidence, currentWindowCount] = summarizeCurrentActivity(features);

summary = struct();
summary.FatigueIndex = fatigueIndex;
summary.WorkoutQualityScore = qualityScore;
summary.ConfidenceIndex = confidenceIndex;
summary.StepCount = stepsDistance.stepCount;
summary.DistanceKm = stepsDistance.distanceKm;
summary.DistanceSource = stepsDistance.distanceSource;
summary.EstimatedCalories = calories;
summary.CaloriesByActivity = caloriesByActivity;
summary.DetectedSport = sportSummary.DetectedSport;
summary.DominantActivity = sportSummary.DominantActivity;
summary.DominantActivityMinutes = sportSummary.DominantActivityMinutes;
summary.DominantActivityCalories = sportSummary.DominantActivityCalories;
summary.AverageCaloriesPerMinute = sportSummary.AverageCaloriesPerMinute;
summary.ActiveCaloriesPerMinute = sportSummary.ActiveCaloriesPerMinute;
summary.CadenceSpm = cadenceSpm;
seconds = analysisDurationSeconds(features);
summary.ActiveMinutes = sum(seconds(features.activityLabel ~= "sit")) / 60;
summary.ActivityMix = activityMixTable(features);
summary.PeakFatigueMinute = fatigueTimeline.peakMinute(1);
summary.PeakFatigueLabel = fatigueTimeline.peakLabel(1);
summary.CurrentActivity = currentActivity;
summary.CurrentActivityConfidence = currentConfidence;
summary.CurrentActivityWindowCount = currentWindowCount;
summary.SourceKind = getMetaValue(session.meta, "sourceKind", "mat_file");
summary.SourceName = getMetaValue(session.meta, "sourceName", "");
summary.LiveSampleCount = height(session.acceleration);
summary.LivePositionSampleCount = height(session.position);
summary.LastSampleSeconds = round(processed.timeSec(end), 2);
summary.CoachAdvice = generateCoachAdvice(summary, options);

summaryText = generateSessionSummary(summary);

if options.renderPlots
    plotSensorOverview(session, processed, features);
    plotFatigueTimeline(fatigueTimeline);
    createDashboard(features, fatigueTimeline, summary);
end

result = struct();
result.session = session;
result.processed = processed;
result.features = features;
result.model = model;
result.baseline = baseline;
result.fatigueTimeline = fatigueTimeline;
result.summary = summary;
result.summaryText = summaryText;
end

function options = withDefault(options, name, value)
if ~isfield(options, name)
    options.(name) = value;
end
end

function session = resolveSession(options)
if isfield(options, "sessionOverride") && isstruct(options.sessionOverride) && ...
        isfield(options.sessionOverride, "acceleration")
    session = normalizeSessionOverride(options.sessionOverride, options);
else
    session = loadSessionData(options);
end
end

function session = normalizeSessionOverride(session, options)
required = ["X", "Y", "Z"];
if ~isfield(session, "acceleration") || ~istimetable(session.acceleration) || ...
        ~all(ismember(required, string(session.acceleration.Properties.VariableNames)))
    error("PeyMan:BadSessionOverride", ...
        "sessionOverride.acceleration must be a timetable with X, Y, Z variables.");
end

session.acceleration = sortrows(session.acceleration(:, required));
session.acceleration = rmmissing(session.acceleration);

if ~isfield(session, "position") || ~istimetable(session.position) || height(session.position) == 0
    session.position = timetable();
else
    session.position = sortrows(session.position);
end

if ~isfield(session, "meta") || ~isstruct(session.meta)
    session.meta = struct();
end

session.meta = ensureMetaField(session.meta, "sourceName", getOption(options, "dataFile", ""));
session.meta = ensureMetaField(session.meta, "demoMode", getOption(options, "demoMode", false));
session.meta = ensureMetaField(session.meta, "sourceKind", "session_override");
session.meta.hasGPS = ~isempty(session.position) && height(session.position) > 1;
end

function meta = ensureMetaField(meta, name, value)
if ~isfield(meta, name)
    meta.(name) = value;
end
end

function model = resolveModel(options, activityLogFile)
if isfield(options, "modelOverride") && ~isempty(options.modelOverride)
    model = options.modelOverride;
else
    model = trainActivityClassifier(activityLogFile, options);
end
end

function value = getOption(options, name, defaultValue)
if isfield(options, name)
    value = options.(name);
else
    value = defaultValue;
end
end

function mix = activityMixTable(features)
labels = categories(categorical(features.activityLabel));
minutes = zeros(numel(labels), 1);
seconds = analysisDurationSeconds(features);
for i = 1:numel(labels)
    minutes(i) = sum(seconds(features.activityLabel == labels{i})) / 60;
end
mix = table(string(labels), minutes, 'VariableNames', ["activity", "minutes"]);
end

function [activity, confidence, windowCount] = summarizeCurrentActivity(features)
windowCount = min(3, height(features));
if windowCount <= 0
    activity = "unknown";
    confidence = 0;
    return;
end

tail = height(features) - windowCount + 1:height(features);
labels = string(features.activityLabel(tail));
valid = labels ~= "";
labels = labels(valid);
if isempty(labels)
    activity = "unknown";
else
    labels = categorical(labels);
    activity = string(mode(labels));
end

confidence = round(100 * mean(features.modelConfidence(tail), "omitnan"), 1);
if ~isfinite(confidence)
    confidence = 0;
end
end

function value = getMetaValue(meta, name, defaultValue)
if isfield(meta, name)
    raw = meta.(name);
    if isstring(raw)
        value = char(raw);
    else
        value = raw;
    end
else
    value = defaultValue;
end
end
