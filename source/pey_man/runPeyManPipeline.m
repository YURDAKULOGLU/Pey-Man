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

session = loadSessionData(options);
processed = preprocessSignal(session);
windows = windowizeSignal(processed, options.windowSeconds, options.windowOverlap);
features = extractFeatures(session, processed, windows);

activityLogFile = getOption(options, "activityLogFile", "");
if ~options.useML
    activityLogFile = "";
end
model = trainActivityClassifier(activityLogFile, options);
features = classifyActivity(features, model);

baseline = computeBaseline(features, options.baselineSeconds);
[fatigueIndex, fatigueTimeline] = computeFatigueIndex(features, baseline);
[cadenceSpm, cadenceByWindow] = computeCadence(features);
stepsDistance = computeStepsDistance(session, features, cadenceByWindow, options);
calories = computeCalories(features, options);
qualityScore = computeQualityScore(features, fatigueIndex);
confidenceIndex = computeConfidenceIndex(session, features);

summary = struct();
summary.FatigueIndex = fatigueIndex;
summary.WorkoutQualityScore = qualityScore;
summary.ConfidenceIndex = confidenceIndex;
summary.StepCount = stepsDistance.stepCount;
summary.DistanceKm = stepsDistance.distanceKm;
summary.DistanceSource = stepsDistance.distanceSource;
summary.EstimatedCalories = calories;
summary.CadenceSpm = cadenceSpm;
summary.ActiveMinutes = sum(features.durationSec(features.activityLabel ~= "sit")) / 60;
summary.ActivityMix = activityMixTable(features);
summary.PeakFatigueMinute = fatigueTimeline.peakMinute(1);
summary.PeakFatigueLabel = fatigueTimeline.peakLabel(1);

summaryText = generateSessionSummary(summary);

plotFatigueTimeline(fatigueTimeline);
createDashboard(features, fatigueTimeline, summary);

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
for i = 1:numel(labels)
    minutes(i) = sum(features.durationSec(features.activityLabel == labels{i})) / 60;
end
mix = table(string(labels), minutes, 'VariableNames', ["activity", "minutes"]);
end
