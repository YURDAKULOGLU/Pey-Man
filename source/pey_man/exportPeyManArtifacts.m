function exportPeyManArtifacts(result, outputDir)
%EXPORTPEYMANARTIFACTS Write machine-readable outputs for demo/UI integration.

if nargin < 2 || strlength(string(outputDir)) == 0
    outputDir = fullfile(pwd, "outputs", "latest");
end

if ~isfolder(outputDir)
    mkdir(outputDir);
end

metrics = struct();
metrics.summaryText = result.summaryText;
metrics.fatigueIndex = result.summary.FatigueIndex;
metrics.workoutQualityScore = result.summary.WorkoutQualityScore;
metrics.confidenceIndex = result.summary.ConfidenceIndex;
metrics.stepCount = result.summary.StepCount;
metrics.distanceKm = result.summary.DistanceKm;
metrics.distanceSource = result.summary.DistanceSource;
metrics.estimatedCalories = result.summary.EstimatedCalories;
metrics.detectedSport = result.summary.DetectedSport;
metrics.dominantActivity = result.summary.DominantActivity;
metrics.dominantActivityMinutes = result.summary.DominantActivityMinutes;
metrics.dominantActivityCalories = result.summary.DominantActivityCalories;
metrics.averageCaloriesPerMinute = result.summary.AverageCaloriesPerMinute;
metrics.activeCaloriesPerMinute = result.summary.ActiveCaloriesPerMinute;
metrics.cadenceSpm = result.summary.CadenceSpm;
metrics.activeMinutes = result.summary.ActiveMinutes;
metrics.peakFatigueMinute = result.summary.PeakFatigueMinute;
metrics.peakFatigueLabel = result.summary.PeakFatigueLabel;
metrics.coachAdvice = result.summary.CoachAdvice.text;
metrics.coachAdviceSource = result.summary.CoachAdvice.source;
metrics.modelType = result.model.type;
metrics.modelReason = result.model.reason;
metrics.modelTrainingRows = result.model.trainingRows;
metrics.modelTrainingAccuracy = result.model.trainingAccuracy;
if isfield(result.model, "validationAccuracy")
    metrics.modelValidationAccuracy = result.model.validationAccuracy;
    metrics.validationAccuracy = result.model.validationAccuracy;
else
    metrics.modelValidationAccuracy = NaN;
    metrics.validationAccuracy = NaN;
end
if isfield(result.model, "validationRows")
    metrics.modelValidationRows = result.model.validationRows;
    metrics.validationRows = result.model.validationRows;
else
    metrics.modelValidationRows = 0;
    metrics.validationRows = 0;
end
metrics.modelTrainingLabelCounts = result.model.trainingLabelCounts;

jsonPath = fullfile(outputDir, "latest_metrics.json");
fid = fopen(jsonPath, "w");
if fid < 0
    error("PeyMan:ArtifactWriteFailed", "Could not write %s", jsonPath);
end
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, "%s", jsonencode(metrics, "PrettyPrint", true));
clear cleanup;

writetable(result.summary.ActivityMix, fullfile(outputDir, "activity_mix.csv"));
writetable(result.summary.CaloriesByActivity, fullfile(outputDir, "calories_by_activity.csv"));
writetable(result.features, fullfile(outputDir, "window_features.csv"));
writetable(result.fatigueTimeline(:, ["minute", "FatigueIndex", "activityLabel"]), ...
    fullfile(outputDir, "fatigue_timeline.csv"));

figures = findall(0, "Type", "figure");
for i = 1:numel(figures)
    figName = "figure_" + string(i) + ".png";
    try
        exportgraphics(figures(i), fullfile(outputDir, figName));
    catch
        saveas(figures(i), fullfile(outputDir, figName));
    end
end
end
