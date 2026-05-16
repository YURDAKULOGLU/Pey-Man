function fitbitDaily = prepareFitbitDailyFeatures(csvFile)
%PREPAREFITBITDAILYFEATURES Fitbit gunluk aktivite verisini ozetler.
%
% Bu veri Strava kosulariyla ayni kullanicilara ait olmadigi icin dogrudan
% modele birlestirmiyoruz. Ama ileride kullanicinin kendi Fitbit/Mobile
% verisi gelirse "readiness" yani gunluk hazirlik/yorgunluk skoru olarak
% ayni mantikla modele eklenebilir.

    if nargin < 1
        projectRoot = findWorkoutProjectRoot(fileparts(mfilename("fullpath")));
        csvFile = fullfile(projectRoot, 'data', 'fitbit', 'dailyActivity_merged.csv');
    end

    fitbitDaily = readtable(csvFile);
    fitbitDaily.ActivityDate = datetime(fitbitDaily.ActivityDate, ...
        'InputFormat', 'M/d/yyyy');

    activeMinutes = fitbitDaily.VeryActiveMinutes + ...
        fitbitDaily.FairlyActiveMinutes + fitbitDaily.LightlyActiveMinutes;

    % Basit aktivite yuku: aktif dakika ve kalori artarsa yuk artar.
    fitbitDaily.ActivityLoad = activeMinutes .* 0.6 + ...
        fitbitDaily.VeryActiveMinutes .* 1.4 + ...
        fitbitDaily.Calories / 100;

    % Basit hazirlik skoru: cok sedanter gunlerde ve asiri yukte dusurulur.
    fitbitDaily.ReadinessScore = 100 ...
        - min(35, fitbitDaily.SedentaryMinutes / 30) ...
        - min(35, fitbitDaily.ActivityLoad / 8);

    fitbitDaily.ReadinessScore = max(0, min(100, fitbitDaily.ReadinessScore));
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
