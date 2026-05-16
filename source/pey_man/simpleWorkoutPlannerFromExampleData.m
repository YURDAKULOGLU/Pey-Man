%% Workout planner using ExampleData.mat
% Bu demo sahte/verilmis ozet yerine ExampleData.mat icindeki Position.speed
% verisini kullanarak kosu ozeti cikarir.

clear; clc; close all;

%% 1) ExampleData.mat dosyasindan tek kosu ozeti al
thisDir = fileparts(mfilename("fullpath"));
projectRoot = fullfile(thisDir, "..", "..");
exampleDataFile = fullfile(projectRoot, ...
    "source", "matlab-mobile-fitness-tracker-master", "ExampleData.mat");

[exampleRun, timeMin, speedKmh] = loadExampleDataRun(exampleDataFile);

disp("ExampleData.mat dosyasindan cikarilan kosu ozeti:");
disp(exampleRun);

%% 2) Bu kosudan kullanici ozelliklerini cikar
% Elimizde sadece bir kosu oldugu icin plan kisa veriye gore uretilir.
% Daha fazla kosu kaydi geldikce previousRuns tablosuna satir eklenebilir.
features = extractRunFeatures(exampleRun);

%% 3) Kisisel program olustur
program = buildWorkoutPlan(features);

disp("ExampleData uzerinden olusturulan program:");
disp(program);

%% 4) Orijinal hiz verisini ve onerilen programi ayri grafiklerde goster
figure('Name', 'ExampleData Speed', 'Color', 'w');
plot(timeMin, speedKmh, 'LineWidth', 1.5);
grid on;
xlabel('Time (min)');
ylabel('Speed (km/h)');
title('Speed Data From ExampleData.mat');

plotTreadmillWorkout(program);

%% 5) Mola uyarisi ornegi
currentTimeMin = 3.5;
message = checkBreakReminder(program, currentTimeMin);
fprintf("Dakika %.1f -> %s\n", currentTimeMin, message);
