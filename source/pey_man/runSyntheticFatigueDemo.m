% Run Pey-Man with generated fresh->rest->tired data.

clear; clc; close all;

thisDir = fileparts(mfilename("fullpath"));
projectRoot = fullfile(thisDir, "..", "..");
addpath(thisDir);

options = struct();
options.demoMode = true;
options.useML = true;
options.baselineSeconds = 60;
options.windowSeconds = 4;
options.windowOverlap = 0.75;
options.bodyMassKg = 70;
options.strideLengthM = 0.72;
options.dataFile = "";
options.activityLogFile = fullfile(projectRoot, "source", "matlab-mobile-fitness-tracker-master", "ActivityLogs.mat");

result = runPeyManPipeline(options);

disp(" ");
disp("=== Pey-Man Synthetic Fatigue Demo ===");
disp(result.summaryText);
disp(" ");
disp(result.summary);

