function features = extractRunFeatures(previousRuns)
%EXTRACTRUNFEATURES Gecmis kosulardan basit kullanici ozellikleri cikarir.
%
% Input:
%   previousRuns tablosu su kolonlari icermeli:
%   - DurationMin : kosu suresi, dakika
%   - AvgSpeedKmh : ortalama hiz, km/saat
%   - FatigueDrop : kosu sonunda performans dususu
%
% Output:
%   features struct'i yeni programi olusturmak icin kullanilir.

    avgDuration = mean(previousRuns.DurationMin);
    avgSpeed = mean(previousRuns.AvgSpeedKmh);
    avgFatigueDrop = mean(previousRuns.FatigueDrop);

    % Basit bir kondisyon skoru:
    % Sure ve hiz artarsa skor artar, yorgunluk dususu artarsa skor azalir.
    fitnessScore = avgDuration * 0.4 + avgSpeed * 0.8 - avgFatigueDrop * 0.7;

    features = struct();
    features.AvgDurationMin = avgDuration;
    features.AvgSpeedKmh = avgSpeed;
    features.AvgFatigueDrop = avgFatigueDrop;
    features.FitnessScore = fitnessScore;
end

