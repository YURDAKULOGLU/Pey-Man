%% Train workout model with Kaggle Strava data
% Bu script Strava kosularindan bir sonraki kosu hizini tahmin eden modeli
% egitir. Fitbit verisi ise ayri olarak gunluk aktivite/readiness ozeti icin
% hazirlanir.

clear; clc; close all;

thisDir = fileparts(mfilename("fullpath"));
projectRoot = findWorkoutProjectRoot(thisDir);

stravaCsv = fullfile(projectRoot, 'data', 'strava', 'raw-data-kaggle.csv');
fitbitCsv = fullfile(projectRoot, 'data', 'fitbit', 'dailyActivity_merged.csv');
modelFile = fullfile(projectRoot, 'models', 'stravaWorkoutModel.mat');

%% 1) Strava modeli
[model, metrics, trainingData] = trainStravaWorkoutModel(stravaCsv, modelFile);

disp("Strava egitim tablosu boyutu:");
disp(size(trainingData));

disp("Model test metrikleri:");
disp(metrics);

%% 2) Ornek tahmin
% Egitim tablosundaki son satiri ornek kullanici durumu gibi dusunuyoruz.
load(modelFile, 'featureNames');
lastExample = trainingData(end, featureNames);
predictedSpeedKmh = predict(model, lastExample);

fprintf("Tahmini bir sonraki kosu hizi: %.2f km/h\n", predictedSpeedKmh);

%% 3) Tahmini hizi mevcut program olusturucuye bagla
exampleRuns = table( ...
    trainingData.PrevDurationMin(end), ...
    predictedSpeedKmh, ...
    max(0, trainingData.RollingSpeedKmh3(end) - predictedSpeedKmh), ...
    'VariableNames', {'DurationMin', 'AvgSpeedKmh', 'FatigueDrop'});

features = extractRunFeatures(exampleRuns);
program = buildWorkoutPlan(features);

disp("Model tahmininden olusturulan program:");
disp(program);

plotTreadmillWorkout(program);

%% 4) Fitbit gunluk aktivite ozeti
if exist(fitbitCsv, 'file')
    fitbitDaily = prepareFitbitDailyFeatures(fitbitCsv);
    disp("Fitbit readiness ornekleri:");
    disp(head(fitbitDaily(:, {'Id', 'ActivityDate', 'TotalSteps', ...
        'VeryActiveMinutes', 'SedentaryMinutes', 'ReadinessScore'})));
end

function projectRoot = findWorkoutProjectRoot(startDir)
%FINDWORKOUTPROJECTROOT Finds the repository root from this script location.

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
