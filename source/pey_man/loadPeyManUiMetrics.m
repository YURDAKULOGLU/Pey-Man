function bundle = loadPeyManUiMetrics(metricsSource)
%LOADPEYMANUIMETRICS Load exported Pey-Man artifacts for the MATLAB UI.
%
% The UI consumes model outputs from outputs/<session>/ and does not invent
% fitness numbers. Missing artifacts are reported through bundle.hasMetrics.

if nargin < 1
    metricsSource = "";
end

sourceDir = resolveMetricsDir(metricsSource);

bundle = struct();
bundle.outputDir = sourceDir;
bundle.hasMetrics = false;
bundle.metrics = struct();
bundle.activityMix = table();
bundle.caloriesByActivity = table();
bundle.fatigueTimeline = table();
bundle.statusMessage = "No exported metrics found. Run main or runSyntheticFatigueDemo first.";

if strlength(string(sourceDir)) == 0
    return;
end

jsonPath = fullfile(sourceDir, "latest_metrics.json");
if ~isfile(jsonPath)
    bundle.statusMessage = "Missing latest_metrics.json in " + string(sourceDir);
    return;
end

try
    bundle.metrics = jsondecode(fileread(jsonPath));
    bundle.activityMix = readOptionalTable(fullfile(sourceDir, "activity_mix.csv"));
    bundle.caloriesByActivity = readOptionalTable(fullfile(sourceDir, "calories_by_activity.csv"));
    bundle.fatigueTimeline = readOptionalTable(fullfile(sourceDir, "fatigue_timeline.csv"));
    bundle.hasMetrics = true;
    bundle.statusMessage = "Loaded metrics from " + string(sourceDir);
catch err
    bundle.metrics = struct();
    bundle.statusMessage = "Metric load failed: " + string(err.message);
end
end

function sourceDir = resolveMetricsDir(metricsSource)
sourceText = string(metricsSource);
if strlength(sourceText) > 0
    if isfolder(sourceText)
        sourceDir = char(sourceText);
        return;
    end
    if isfile(sourceText)
        sourceDir = fileparts(char(sourceText));
        return;
    end
end

thisDir = fileparts(mfilename("fullpath"));
projectRoot = fileparts(fileparts(thisDir));
outputsRoot = fullfile(projectRoot, "outputs");

candidates = [
    fullfile(outputsRoot, "example_file")
    fullfile(outputsRoot, "synthetic")
    fullfile(outputsRoot, "latest")
];

sourceDir = "";
for i = 1:numel(candidates)
    candidate = candidates(i);
    if isfile(fullfile(candidate, "latest_metrics.json"))
        sourceDir = char(candidate);
        return;
    end
end
end

function tbl = readOptionalTable(pathValue)
if isfile(pathValue)
    tbl = readtable(pathValue);
else
    tbl = table();
end
end
