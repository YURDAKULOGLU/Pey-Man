function [model, metrics, trainingData] = trainStravaWorkoutModel(csvFile, modelFile)
%TRAINSTRAVAWORKOUTMODEL Strava verisiyle hiz tahmin modeli egitir.
%
% Model secimi:
%   Bagged Regression Trees.
%
% Neden?
%   - Veri tablo halinde ve cok buyuk degil.
%   - Mesafe, sure, nabiz, egim gibi etkilesimli degiskenleri yakalar.
%   - Ilk prototip icin sinir agindan daha kolay aciklanir.
%   - MATLAB'da fitrensemble ile dogrudan egitilebilir.

    if nargin < 1
        csvFile = fullfile(findWorkoutProjectRoot(fileparts(mfilename("fullpath"))), ...
            'data', 'strava', 'raw-data-kaggle.csv');
    end

    if nargin < 2
        modelFile = fullfile(findWorkoutProjectRoot(fileparts(mfilename("fullpath"))), ...
            'models', 'stravaWorkoutModel.mat');
    end

    trainingData = prepareStravaTrainingData(csvFile);

    featureNames = { ...
        'IsMale', 'RunCountBefore', 'DaysSincePrevious', ...
        'PrevDistanceKm', 'PrevDurationMin', 'PrevSpeedKmh', ...
        'PrevPaceMinPerKm', 'PrevElevationGainM', 'PrevHeartRateBpm', ...
        'RollingDistanceKm3', 'RollingDurationMin3', ...
        'RollingSpeedKmh3', 'RollingHeartRateBpm3'};

    rng(7);
    cv = cvpartition(height(trainingData), 'HoldOut', 0.2);
    trainRows = training(cv);
    testRows = test(cv);

    XTrain = trainingData(trainRows, featureNames);
    yTrain = trainingData.TargetSpeedKmh(trainRows);
    XTest = trainingData(testRows, featureNames);
    yTest = trainingData.TargetSpeedKmh(testRows);

    template = templateTree('MinLeafSize', 8);
    model = fitrensemble(XTrain, yTrain, ...
        'Method', 'Bag', ...
        'NumLearningCycles', 120, ...
        'Learners', template);

    predictions = predict(model, XTest);

    metrics = struct();
    metrics.NumRows = height(trainingData);
    metrics.TestRows = numel(yTest);
    metrics.MAE = mean(abs(predictions - yTest));
    metrics.RMSE = sqrt(mean((predictions - yTest).^2));
    metrics.RSquared = 1 - sum((yTest - predictions).^2) / ...
        sum((yTest - mean(yTest)).^2);

    [modelFolder, ~, ~] = fileparts(modelFile);
    if ~exist(modelFolder, 'dir')
        mkdir(modelFolder);
    end

    save(modelFile, 'model', 'metrics', 'featureNames');
end

function projectRoot = findWorkoutProjectRoot(startDir)
%FINDWORKOUTPROJECTROOT Finds the repository root from this function location.

    projectRoot = startDir;

    for i = 1:5
        if isfolder(fullfile(projectRoot, '.git')) || ...
                isfolder(fullfile(projectRoot, 'source'))
            return;
        end

        parentDir = fileparts(projectRoot);
        if strcmp(parentDir, projectRoot)
            return;
        end

        projectRoot = parentDir;
    end
end
