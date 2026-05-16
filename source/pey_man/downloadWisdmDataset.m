function datasetDir = downloadWisdmDataset(datasetDir)
%DOWNLOADWISDMDATASET Download the public WISDM HAR fallback dataset.
%
% This is a MATLAB-only helper. It writes public dataset files under
% local_data/, which is ignored by git.
%
% Example:
%   cd source/pey_man
%   downloadWisdmDataset

if nargin < 1 || strlength(string(datasetDir)) == 0
    thisDir = fileparts(mfilename("fullpath"));
    projectRoot = fullfile(thisDir, "..", "..");
    datasetDir = fullfile(projectRoot, "local_data", "wisdm_hf");
end

datasetDir = string(datasetDir);
metadataDir = fullfile(datasetDir, "metadata");
if ~isfolder(datasetDir)
    mkdir(datasetDir);
end
if ~isfolder(metadataDir)
    mkdir(metadataDir);
end

baseUrl = "https://huggingface.co/datasets/monster-monash/WISDM/resolve/main/";
files = [
    "README.md"
    "WISDM_X.csv"
    "WISDM_y.csv"
    "WISDM_subject_id.csv"
    "WISDM.npy"
    "WISDM_metadata.npy"
    "metadata/WISDM_metadata.txt"
    "test_indices_fold_0.txt"
    "test_indices_fold_1.txt"
    "test_indices_fold_2.txt"
    "test_indices_fold_3.txt"
    "test_indices_fold_4.txt"
];

for i = 1:numel(files)
    relativePath = files(i);
    destination = fullfile(datasetDir, relativePath);
    destinationFolder = fileparts(destination);
    if ~isfolder(destinationFolder)
        mkdir(destinationFolder);
    end

    if isfile(destination)
        fprintf("Already present: %s\n", destination);
        continue;
    end

    sourceUrl = baseUrl + replace(relativePath, filesep, "/");
    fprintf("Downloading %s\n", relativePath);
    websave(destination, sourceUrl);
end

fprintf("WISDM local dataset ready: %s\n", datasetDir);
end
