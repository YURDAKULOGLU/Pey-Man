% Run the preferred local IRL session if present; otherwise run synthetic fallback.

clear; clc; close all;

thisDir = fileparts(mfilename("fullpath"));
projectRoot = fullfile(thisDir, "..", "..");
addpath(thisDir);

candidateFiles = [
    fullfile(projectRoot, "local_data", "fatigue_demo.mat")
    fullfile(projectRoot, "local_data", "walk.mat")
    fullfile(projectRoot, "local_data", "run.mat")
    fullfile(projectRoot, "local_data", "sit.mat")
];

selectedFile = "";
for i = 1:numel(candidateFiles)
    if isfile(candidateFiles(i))
        selectedFile = candidateFiles(i);
        break;
    end
end

if strlength(selectedFile) == 0
    disp("No local_data/*.mat file found. Running synthetic fatigue fallback.");
    runSyntheticFatigueDemo;
else
    runPeyManFile(selectedFile);
end

