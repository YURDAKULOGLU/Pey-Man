function result = runPeyManFile(dataFile, outputDir)
%RUNPEYMANFILE Run Pey-Man on a real MATLAB Mobile .mat file.
%
% Example:
%   runPeyManFile("../../local_data/fatigue_demo.mat")

if nargin < 1 || strlength(string(dataFile)) == 0
    [fileName, folderName] = uigetfile("*.mat", "Select MATLAB Mobile session");
    if isequal(fileName, 0)
        error("PeyMan:NoFileSelected", "No .mat file selected.");
    end
    dataFile = fullfile(folderName, fileName);
end

thisDir = fileparts(mfilename("fullpath"));
projectRoot = fullfile(thisDir, "..", "..");
addpath(thisDir);

if nargin < 2 || strlength(string(outputDir)) == 0
    [~, stem] = fileparts(dataFile);
    outputDir = fullfile(projectRoot, "outputs", stem);
end

options = struct();
options.demoMode = false;
options.useML = true;
options.baselineSeconds = 60;
options.windowSeconds = 4;
options.windowOverlap = 0.75;
options.bodyMassKg = 70;
options.strideLengthM = 0.72;
options.dataFile = dataFile;
options.activityLogFile = fullfile(projectRoot, "source", "matlab-mobile-fitness-tracker-master", "ActivityLogs.mat");

result = runPeyManPipeline(options);
exportPeyManArtifacts(result, outputDir);

disp(" ");
disp("=== Pey-Man IRL Session Summary ===");
disp(result.summaryText);
disp(" ");
disp("Artifacts written to: " + string(outputDir));
end

