function info = inspectWisdmDataset(datasetDir)
%INSPECTWISDMDATASET Inspect the local WISDM HAR fallback files.
%
% This function intentionally does not train the Pey-Man model. It confirms
% that the public dataset is present and reports the available label counts.
%
% Example:
%   cd source/pey_man
%   inspectWisdmDataset

if nargin < 1 || strlength(string(datasetDir)) == 0
    thisDir = fileparts(mfilename("fullpath"));
    projectRoot = fullfile(thisDir, "..", "..");
    datasetDir = fullfile(projectRoot, "local_data", "wisdm_hf");
end

datasetDir = string(datasetDir);
requiredFiles = [
    "WISDM_X.csv"
    "WISDM_y.csv"
    "WISDM_subject_id.csv"
    "README.md"
];

for i = 1:numel(requiredFiles)
    filePath = fullfile(datasetDir, requiredFiles(i));
    if ~isfile(filePath)
        error("PeyMan:MissingWisdmFile", ...
            "Missing %s. Run downloadWisdmDataset first.", filePath);
    end
end

labels = readmatrix(fullfile(datasetDir, "WISDM_y.csv"));
subjectIds = readmatrix(fullfile(datasetDir, "WISDM_subject_id.csv"));
labels = labels(:);
subjectIds = subjectIds(:);

uniqueLabels = unique(labels);
counts = zeros(numel(uniqueLabels), 1);
for i = 1:numel(uniqueLabels)
    counts(i) = sum(labels == uniqueLabels(i));
end

labelCounts = table(uniqueLabels, counts, ...
    'VariableNames', ["numericLabel", "windowCount"]);

sourceActivities = [
    "Walking"
    "Jogging"
    "Stairs"
    "Sitting"
    "Standing"
    "Lying Down"
];

metadataPath = fullfile(datasetDir, "metadata", "WISDM_metadata.txt");
if isfile(metadataPath)
    metadata = readlines(metadataPath);
else
    metadata = strings(0, 1);
end

info = struct();
info.datasetDir = datasetDir;
info.windowCount = numel(labels);
info.subjectCount = numel(unique(subjectIds));
info.sourceActivities = sourceActivities;
info.labelCounts = labelCounts;
info.metadata = metadata;

disp("=== WISDM Local Dataset ===");
fprintf("Folder: %s\n", datasetDir);
fprintf("Windows: %d\n", info.windowCount);
fprintf("Subjects: %d\n", info.subjectCount);
disp("Source activity names:");
disp(sourceActivities);
disp("Numeric label counts:");
disp(labelCounts);
disp("Important: confirm numeric label order before using labels for final training evidence.");
end
