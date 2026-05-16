function trainingData = prepareStravaTrainingData(csvFile)
%PREPARESTRAVATRAININGDATA Strava kosu verisini model egitim tablosuna cevirir.
%
% Kaggle dosyasi her satirda bir kosu ozeti tutar. Modelin amaci:
% "onceki kosulara bakarak bir sonraki kosunun ortalama hizini tahmin etmek".
%
% Target:
%   TargetSpeedKmh : siradaki kosunun ortalama hizi
%
% Features:
%   Onceki kosunun mesafe, sure, hiz, nabiz bilgileri ve son 3 kosu ortalamalari.

    raw = readtable(csvFile, 'Delimiter', ';', 'VariableNamingRule', 'preserve');

    % Kaggle kolon adlari MATLAB tarafinda bozulabildigi icin sabit isim veriyoruz.
    raw.Properties.VariableNames = { ...
        'Athlete', 'Gender', 'TimestampText', 'DistanceM', ...
        'ElapsedTimeS', 'ElevationGainM', 'AverageHeartRateBpm'};

    raw.Timestamp = datetime(raw.TimestampText, ...
        'InputFormat', 'dd/MM/yyyy HH:mm', ...
        'Format', 'yyyy-MM-dd HH:mm');

    raw.DistanceKm = raw.DistanceM / 1000;
    raw.DurationMin = raw.ElapsedTimeS / 60;
    raw.SpeedKmh = raw.DistanceKm ./ (raw.DurationMin / 60);
    raw.PaceMinPerKm = raw.DurationMin ./ raw.DistanceKm;
    raw.IsMale = double(strcmp(string(raw.Gender), "M"));

    % Bariz sorunlu kayitlari temizle.
    validRows = raw.DistanceKm > 0.5 & raw.DurationMin > 2 & ...
        raw.SpeedKmh > 2 & raw.SpeedKmh < 25 & ...
        ~isnan(raw.AverageHeartRateBpm);
    raw = raw(validRows, :);

    raw = sortrows(raw, {'Athlete', 'Timestamp'});
    athletes = unique(raw.Athlete);

    trainingData = table();

    for a = 1:numel(athletes)
        athleteRows = raw(raw.Athlete == athletes(a), :);

        % En az 2 kosu lazim: onceki kosu feature, sonraki kosu target.
        if height(athleteRows) < 2
            continue;
        end

        for i = 2:height(athleteRows)
            previousRows = athleteRows(1:i-1, :);
            previousRun = athleteRows(i-1, :);
            currentRun = athleteRows(i, :);

            recentWindow = previousRows(max(1, height(previousRows)-2):end, :);
            daysSincePrevious = days(currentRun.Timestamp - previousRun.Timestamp);

            newRow = table();
            newRow.Athlete = previousRun.Athlete;
            newRow.IsMale = previousRun.IsMale;
            newRow.RunCountBefore = i - 1;
            newRow.DaysSincePrevious = daysSincePrevious;
            newRow.PrevDistanceKm = previousRun.DistanceKm;
            newRow.PrevDurationMin = previousRun.DurationMin;
            newRow.PrevSpeedKmh = previousRun.SpeedKmh;
            newRow.PrevPaceMinPerKm = previousRun.PaceMinPerKm;
            newRow.PrevElevationGainM = previousRun.ElevationGainM;
            newRow.PrevHeartRateBpm = previousRun.AverageHeartRateBpm;
            newRow.RollingDistanceKm3 = mean(recentWindow.DistanceKm);
            newRow.RollingDurationMin3 = mean(recentWindow.DurationMin);
            newRow.RollingSpeedKmh3 = mean(recentWindow.SpeedKmh);
            newRow.RollingHeartRateBpm3 = mean(recentWindow.AverageHeartRateBpm);

            % Modelin tahmin edecegi deger: mevcut kosunun hizi.
            newRow.TargetSpeedKmh = currentRun.SpeedKmh;

            trainingData = [trainingData; newRow]; %#ok<AGROW>
        end
    end

    % Cok uzun araliktan sonraki kosular farkli kosullara ait olabilir.
    trainingData = trainingData(trainingData.DaysSincePrevious >= 0 & ...
        trainingData.DaysSincePrevious <= 90, :);
end
