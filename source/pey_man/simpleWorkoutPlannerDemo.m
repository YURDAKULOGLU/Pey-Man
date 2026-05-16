%% Simple treadmill-style workout planner demo
% Bu demo gecmis kosu ozetlerine bakar, yeni bir kosu programi olusturur,
% kosu bandi benzeri bir grafik cizer ve mola uyarisi mantigini gosterir.

clear; clc; close all;

%% 1) Gecmis kosular
% Gercek projede bu bilgiler sensor verilerinden veya kayit dosyasindan
% hesaplanabilir. Basit baslamak icin her kosuyu ozet tablo olarak tutuyoruz.
%
% DurationMin: toplam kosu suresi
% AvgSpeedKmh: ortalama hiz
% FatigueDrop: kosu sonunda performans dususu. Buyukse daha cok yorulmus.
previousRuns = table( ...
    [18; 22; 25; 24], ...
    [6.8; 7.2; 7.5; 7.1], ...
    [3.5; 2.8; 2.1; 2.6], ...
    'VariableNames', {'DurationMin', 'AvgSpeedKmh', 'FatigueDrop'});

%% 2) Gecmis kosulardan kullanici ozelliklerini cikar
features = extractRunFeatures(previousRuns);

%% 3) Bu kullanici icin yeni program olustur
program = buildWorkoutPlan(features);

disp("Olusturulan program:");
disp(program);

%% 4) Kosu bandi benzeri grafikte goster
plotTreadmillWorkout(program);

%% 5) Mola uyarisi nasil calisir?
% Normalde currentTimeMin canli kosu suresinden gelir.
% Burada farkli dakikalari deneyerek uyari mantigini gosteriyoruz.
sampleTimes = [2.5 6.8 7.2 12.1 18.9];

for i = 1:numel(sampleTimes)
    message = checkBreakReminder(program, sampleTimes(i));
    fprintf("Dakika %.1f -> %s\n", sampleTimes(i), message);
end

