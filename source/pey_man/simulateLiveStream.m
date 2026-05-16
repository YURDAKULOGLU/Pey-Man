function simulateLiveStream(options)
%SIMULATELIVESTREAM Synthetic live stream for phone-free demo testing.
%
% Writes progressively-mutating metrics to outputs/live/ on a timer so the
% pixel UI (with autoRefreshSeconds) can be tested without MATLAB Mobile.
%
% Usage:
%   simulateLiveStream()                              % default 60 sec, 3 sec ticks
%   simulateLiveStream(struct("durationSeconds", 30)) % shorter demo
%   simulateLiveStream(struct("tickSeconds", 1))      % faster updates
%
% Then in another MATLAB session:
%   runPeyManPixelApp("outputs/live", struct("autoRefreshSeconds", 2))

arguments
    options struct = struct()
end

options = withDefault(options, "durationSeconds", 60);
options = withDefault(options, "tickSeconds", 3);
options = withDefault(options, "stepStart", 40);
options = withDefault(options, "stepPerTick", 25);
options = withDefault(options, "calorieStart", 2);
options = withDefault(options, "caloriePerTick", 1.4);
options = withDefault(options, "fatigueStart", 8);
options = withDefault(options, "fatigueDelta", 1.7);
options = withDefault(options, "qualityStart", 30);
options = withDefault(options, "qualityCeiling", 78);

thisDir = fileparts(mfilename("fullpath"));
projectRoot = fileparts(fileparts(thisDir));
liveDir = fullfile(projectRoot, "outputs", "live");
if ~isfolder(liveDir)
    mkdir(liveDir);
end

tickCount = floor(options.durationSeconds / options.tickSeconds);
fprintf("Synthetic live stream: %d ticks every %.1fs, writing to %s\n", ...
    tickCount, options.tickSeconds, liveDir);
fprintf("Open the UI in another MATLAB session with autoRefresh:\n");
fprintf('  runPeyManPixelApp("outputs/live", struct("autoRefreshSeconds", 2))\n\n');

steps = options.stepStart;
calories = options.calorieStart;
fatigue = options.fatigueStart;
quality = options.qualityStart;
distanceKm = 0.0;

t0 = datetime("now", "TimeZone", "UTC");

for tick = 1:tickCount
    steps = steps + options.stepPerTick + randi([-3 6]);
    calories = calories + options.caloriePerTick + 0.2 * randn();
    fatigue = min(95, fatigue + options.fatigueDelta + 0.5 * randn());
    quality = min(options.qualityCeiling, quality + 1.2 + 0.3 * randn());
    distanceKm = distanceKm + 0.020 + 0.004 * randn();
    distanceKm = max(distanceKm, 0);

    cadence = 90 + 20 * sin(tick / 6) + 4 * randn();
    confidence = 85 + 10 * sin(tick / 8);

    metrics = struct();
    metrics.summaryText = sprintf("Live tick %d/%d - synthetic stream", tick, tickCount);
    metrics.fatigueIndex = round(fatigue, 1);
    metrics.workoutQualityScore = round(quality, 1);
    metrics.confidenceIndex = round(confidence, 1);
    metrics.stepCount = round(steps);
    metrics.distanceKm = round(distanceKm, 3);
    metrics.distanceSource = "synthetic_simulated";
    metrics.estimatedCalories = round(calories);
    metrics.detectedSport = pickSport(quality);
    metrics.dominantActivity = pickActivity(fatigue);
    metrics.dominantActivityMinutes = round((tick * options.tickSeconds) / 60, 2);
    metrics.dominantActivityCalories = round(calories);
    metrics.averageCaloriesPerMinute = round(calories / max(0.1, tick * options.tickSeconds / 60), 2);
    metrics.activeCaloriesPerMinute = metrics.averageCaloriesPerMinute;
    metrics.cadenceSpm = round(cadence, 1);
    metrics.activeMinutes = round((tick * options.tickSeconds) / 60, 2);
    metrics.peakFatigueMinute = round((tick * options.tickSeconds) / 60, 2);
    metrics.peakFatigueLabel = sprintf("Live peak at %d:%02d", floor(tick * options.tickSeconds / 60), mod(tick * options.tickSeconds, 60));
    metrics.coachAdvice = "Live synthetic stream running.";
    metrics.coachAdviceSource = "simulator";
    metrics.modelType = "centroid";
    metrics.modelReason = "synthetic simulation";
    metrics.modelTrainingRows = 70;
    metrics.modelTrainingAccuracy = 0.974;
    metrics.modelValidationAccuracy = 0.9286;
    metrics.validationAccuracy = 0.9286;
    metrics.modelValidationRows = 14;
    metrics.validationRows = 14;
    metrics.modelTrainingLabelCounts = struct("sit", 27, "walk", 22, "run", 28);
    metrics.validationAccuracy_source = "heldout_validation";
    metrics.modelValidationAccuracy_source = "heldout_validation";
    metrics.currentActivity = metrics.dominantActivity;
    metrics.currentActivityConfidence = round(confidence, 1);
    metrics.currentActivityWindowCount = tick;
    metrics.sourceKind = "live_simulator";
    metrics.sourceName = "simulateLiveStream";
    metrics.liveSampleCount = tick * 25 * options.tickSeconds;
    metrics.livePositionSampleCount = tick * options.tickSeconds;
    metrics.lastSampleSeconds = options.tickSeconds;
    metrics.lastUpdatedAt = char(datetime("now", "TimeZone", "UTC", ...
        "Format", "yyyy-MM-dd'T'HH:mm:ss'Z'"));

    jsonPath = fullfile(liveDir, "latest_metrics.json");
    fid = fopen(jsonPath, "w");
    fprintf(fid, "%s", jsonencode(metrics, "PrettyPrint", true));
    fclose(fid);

    writeMixCsv(liveDir, fatigue);

    fprintf("[%2d/%d] steps=%d  kcal=%d  fat=%.0f  qual=%.0f  sport=%s\n", ...
        tick, tickCount, metrics.stepCount, metrics.estimatedCalories, ...
        metrics.fatigueIndex, metrics.workoutQualityScore, metrics.detectedSport);

    if tick < tickCount
        pause(options.tickSeconds);
    end
end

fprintf("\nSynthetic stream complete after %d ticks.\n", tickCount);
fprintf("Final metrics in %s/latest_metrics.json\n", liveDir);
end

function options = withDefault(options, name, defaultValue)
if ~isfield(options, name)
    options.(name) = defaultValue;
end
end

function sport = pickSport(quality)
if quality > 70
    sport = "Running Session";
elseif quality > 45
    sport = "Walking Session";
else
    sport = "Mixed Session";
end
end

function activity = pickActivity(fatigue)
if fatigue > 70
    activity = "run";
elseif fatigue > 30
    activity = "walk";
else
    activity = "sit";
end
end

function writeMixCsv(liveDir, fatigue)
sitMin = max(0, 1.0 - fatigue / 100);
walkMin = max(0, 0.6 + fatigue / 200);
runMin = max(0, fatigue / 100);
sitCal = sitMin * 1.2;
walkCal = walkMin * 4.0;
runCal = runMin * 10.0;

mix = table(["sit"; "walk"; "run"], [sitMin; walkMin; runMin], ...
    'VariableNames', {'activity', 'minutes'});
writetable(mix, fullfile(liveDir, "activity_mix.csv"));

cal = table(["sit"; "walk"; "run"], [sitMin; walkMin; runMin], ...
    [sitCal; walkCal; runCal], ...
    'VariableNames', {'activity', 'minutes', 'calories'});
writetable(cal, fullfile(liveDir, "calories_by_activity.csv"));

n = 20;
minute = linspace(0, walkMin + runMin + sitMin, n)';
fi = linspace(5, fatigue, n)' + 3 * randn(n, 1);
labels = repmat("walk", n, 1);
labels(fi > 50) = "run";
labels(fi < 15) = "sit";
fatigueTbl = table(minute, fi, labels, 'VariableNames', {'minute', 'FatigueIndex', 'activityLabel'});
writetable(fatigueTbl, fullfile(liveDir, "fatigue_timeline.csv"));
end
