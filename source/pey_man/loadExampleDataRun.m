function [runSummary, timeMin, speedKmh] = loadExampleDataRun(filename)
%LOADEXAMPLEDATARUN ExampleData.mat dosyasindan kosu ozeti cikarir.
%
% MATLAB Mobile Position tablosundaki speed degiskeni m/s kabul edilir.
% Bu fonksiyon speed degerini km/h birimine cevirir ve planlayicinin
% kullanabilecegi tek satirlik bir kosu ozeti olusturur.
%
% Output:
%   runSummary : DurationMin, AvgSpeedKmh, FatigueDrop bilgilerini tasir
%   timeMin    : kosu zamani, dakika
%   speedKmh   : anlik hiz, km/saat

    data = load(filename);

    if ~isfield(data, "Position")
        error("Dosyada Position timetable bulunamadi.");
    end

    position = data.Position;

    if ~ismember("speed", position.Properties.VariableNames)
        error("Position tablosunda speed kolonu bulunamadi.");
    end

    % Timestamp degerlerini kosu baslangicina gore dakikaya ceviriyoruz.
    timeMin = minutes(position.Timestamp - position.Timestamp(1));

    % MATLAB Mobile speed verisi m/s oldugu icin km/h = m/s * 3.6.
    speedKmh = position.speed * 3.6;
    speedKmh(speedKmh < 0) = 0;

    durationMin = timeMin(end) - timeMin(1);

    % Ortalama hizi mesafe / sure olarak hesaplamak daha dengeli sonuc verir.
    timeSec = timeMin * 60;
    distanceMeter = trapz(timeSec, position.speed);
    distanceKm = distanceMeter / 1000;
    avgSpeedKmh = distanceKm / (durationMin / 60);

    % Yorgunluk dususu: ilk yaridaki ortalama hiz - ikinci yaridaki ortalama hiz.
    % Ikinci yari daha yavas ise pozitif olur.
    firstHalf = timeMin <= durationMin / 2;
    secondHalf = timeMin > durationMin / 2;
    firstAvg = mean(speedKmh(firstHalf), "omitnan");
    secondAvg = mean(speedKmh(secondHalf), "omitnan");
    fatigueDrop = max(0, firstAvg - secondAvg);

    runSummary = table(durationMin, avgSpeedKmh, fatigueDrop, distanceKm, ...
        'VariableNames', {'DurationMin', 'AvgSpeedKmh', 'FatigueDrop', 'DistanceKm'});
end

