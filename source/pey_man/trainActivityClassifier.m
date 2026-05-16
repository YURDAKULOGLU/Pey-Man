function model = trainActivityClassifier(activityLogFile, options)
%TRAINACTIVITYCLASSIFIER Train sit/walk/run classifier from starter activity logs.

arguments
    activityLogFile {mustBeTextScalar} = ""
    options struct = struct()
end

predictorNames = ["meanDynAcc", "stdDynAcc", "rmsDynAcc", "peakCount", ...
    "activeRatio", "dominantHz", "spectralPower", "speedMps"];

model = ruleModel(predictorNames, "activity log unavailable");
if strlength(string(activityLogFile)) == 0 || ~isfile(activityLogFile)
    return;
end

raw = load(activityLogFile);
trainingRows = {};
labels = ["sit", "walk", "run"];

for label = labels
    varName = label + "Acceleration";
    if ~isfield(raw, varName) || ~istimetable(raw.(varName))
        continue;
    end
    session = struct();
    session.acceleration = raw.(varName);
    session.position = timetable();
    session.meta = struct("sourceName", string(activityLogFile), "demoMode", true, "hasGPS", false);
    processed = preprocessSignal(session);
    windows = windowizeSignal(processed, getOption(options, "windowSeconds", 4), getOption(options, "windowOverlap", 0.75));
    f = extractFeatures(session, processed, windows);
    f.Label = categorical(repmat(label, height(f), 1));
    trainingRows{end+1} = f; %#ok<AGROW>
end

if isempty(trainingRows)
    return;
end

training = vertcat(trainingRows{:});
if numel(categories(training.Label)) < 2 || height(training) < 6
    return;
end

X = featurePredictorTable(training, predictorNames);
y = training.Label;

if exist("fitctree", "file") == 2
    model = struct();
    model.type = "fitctree";
    model.predictorNames = predictorNames;
    model.trainedModel = fitctree(X, y, "MinLeafSize", 2);
    predicted = predict(model.trainedModel, X);
    model.trainingAccuracy = mean(predicted == y);
    model.trainingRows = height(training);
    model.trainingLabelCounts = labelCounts(training.Label);
    model.reason = "trained from ActivityLogs.mat";
else
    model = ruleModel(predictorNames, "fitctree unavailable; using rule fallback");
end
end

function model = ruleModel(predictorNames, reason)
model = struct();
model.type = "rule";
model.predictorNames = predictorNames;
model.trainedModel = [];
model.trainingRows = 0;
model.trainingAccuracy = NaN;
model.trainingLabelCounts = struct();
model.reason = reason;
end

function counts = labelCounts(labels)
cats = categories(labels);
counts = struct();
for i = 1:numel(cats)
    counts.(cats{i}) = sum(labels == cats{i});
end
end

function value = getOption(options, name, defaultValue)
if isfield(options, name)
    value = options.(name);
else
    value = defaultValue;
end
end

