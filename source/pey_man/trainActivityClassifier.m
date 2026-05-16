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

if exist("fitcensemble", "file") == 2 && exist("cvpartition", "file") == 2
    model = struct();
    model.type = "fitcensemble-bag";
    model.predictorNames = predictorNames;

    [trainedModel, valAcc, valRows] = trainBaggedEnsemble(X, y);
    model.trainedModel = trainedModel;
    predicted = predict(trainedModel, X);
    model.trainingAccuracy = mean(predicted == y);
    model.validationAccuracy = valAcc;
    model.validationRows = valRows;
    model.trainingRows = height(training);
    model.trainingLabelCounts = labelCounts(training.Label);
    model.reason = "trained from ActivityLogs.mat with bagged trees ensemble";

    if ~isnan(valAcc)
        fprintf("Validation accuracy: %.1f%% (held-out %d rows)\n", 100 * valAcc, valRows);
    end
elseif exist("fitctree", "file") == 2
    model = struct();
    model.type = "fitctree";
    model.predictorNames = predictorNames;
    model.trainedModel = fitctree(X, y, "MinLeafSize", 2);
    predicted = predict(model.trainedModel, X);
    model.trainingAccuracy = mean(predicted == y);
    model.validationAccuracy = NaN;
    model.validationRows = 0;
    model.trainingRows = height(training);
    model.trainingLabelCounts = labelCounts(training.Label);
    model.reason = "trained from ActivityLogs.mat";
else
    model = centroidModel(X, y, predictorNames);
end
end

function [trainedModel, valAcc, valRows] = trainBaggedEnsemble(X, y)
nRows = height(X);
nClasses = numel(categories(y));
canHoldout = nRows >= max(10, 5 * nClasses);

if canHoldout
    rng(20260516, "twister");
    cvp = cvpartition(y, "Holdout", 0.2);
    Xtrain = X(training(cvp), :);
    ytrain = y(training(cvp));
    Xval = X(test(cvp), :);
    yval = y(test(cvp));
    trainedModel = fitcensemble(Xtrain, ytrain, "Method", "Bag", "NumLearningCycles", 60);
    valPredicted = predict(trainedModel, Xval);
    valAcc = mean(valPredicted == yval);
    valRows = numel(yval);
else
    trainedModel = fitcensemble(X, y, "Method", "Bag", "NumLearningCycles", 60);
    valAcc = NaN;
    valRows = 0;
end
end

function model = ruleModel(predictorNames, reason)
model = struct();
model.type = "rule";
model.predictorNames = predictorNames;
model.trainedModel = [];
model.trainingRows = 0;
model.trainingAccuracy = NaN;
model.validationAccuracy = NaN;
model.validationRows = 0;
model.trainingLabelCounts = struct();
model.reason = reason;
end

function model = centroidModel(X, y, predictorNames)
Xraw = table2array(X);
mu = mean(Xraw, 1, "omitnan");
sigma = std(Xraw, 0, 1, "omitnan");
sigma(~isfinite(sigma) | sigma < eps) = 1;
Xz = (Xraw - mu) ./ sigma;

labels = string(categories(y));
centroids = zeros(numel(labels), width(X));
for i = 1:numel(labels)
    centroids(i, :) = mean(Xz(y == labels(i), :), 1, "omitnan");
end

predicted = predictCentroid(Xz, centroids, labels);

model = struct();
model.type = "centroid";
model.predictorNames = predictorNames;
model.trainedModel = [];
model.centroidLabels = labels;
model.centroids = centroids;
model.mu = mu;
model.sigma = sigma;
model.trainingRows = numel(y);
model.trainingAccuracy = mean(categorical(predicted) == y);
model.validationAccuracy = NaN;
model.validationRows = 0;
model.trainingLabelCounts = labelCounts(y);
model.reason = "trained from ActivityLogs.mat with toolbox-free nearest-centroid classifier";
end

function predicted = predictCentroid(Xz, centroids, labels)
distances = zeros(size(Xz, 1), numel(labels));
for i = 1:numel(labels)
    delta = Xz - centroids(i, :);
    distances(:, i) = sqrt(sum(delta .^ 2, 2, "omitnan"));
end
[~, idx] = min(distances, [], 2);
predicted = labels(idx);
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

