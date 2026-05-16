% Pey-Man hackathon demo entrypoint.
% Run this file from MATLAB Online or desktop MATLAB.

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
options.dataFile = fullfile(projectRoot, "source", "matlab-mobile-fitness-tracker-master", "ExampleData.mat");
options.activityLogFile = fullfile(projectRoot, "source", "matlab-mobile-fitness-tracker-master", "ActivityLogs.mat");

result = runPeyManPipeline(options);
exportPeyManArtifacts(result, fullfile(projectRoot, "outputs", "example_file"));

disp(" ");
disp("=== Pey-Man Session Summary ===");
disp(result.summaryText);
disp(" ");
disp(result.summary);

