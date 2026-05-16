function createDashboard(features, fatigueTimeline, summary)
%CREATEDASHBOARD Four-panel judge-facing MATLAB figure.

figure("Name", "Pey-Man Workout Dashboard", "Color", "w");
tiledlayout(2, 2, "TileSpacing", "compact", "Padding", "compact");

nexttile;
plot(fatigueTimeline.minute, fatigueTimeline.FatigueIndex, "LineWidth", 2);
ylim([0 100]);
title("Fatigue Index");
xlabel("Minute");
ylabel("FI");
grid on;

nexttile;
plotActivityPie(features);

nexttile;
bar(categorical(["Quality", "Fatigue", "Confidence"]), ...
    [summary.WorkoutQualityScore, summary.FatigueIndex, summary.ConfidenceIndex]);
ylim([0 100]);
title("Session Scores");
ylabel("Score");
grid on;

nexttile;
axis off;
metrics = {
    sprintf("Workout Quality: %.1f / 100", summary.WorkoutQualityScore)
    sprintf("Fatigue Index: %.1f / 100", summary.FatigueIndex)
    sprintf("Confidence: %.1f%%", summary.ConfidenceIndex)
    sprintf("Steps: %d", summary.StepCount)
    sprintf("Distance: %.2f km (%s)", summary.DistanceKm, summary.DistanceSource)
    sprintf("Cadence: %.1f steps/min", summary.CadenceSpm)
    sprintf("Calories: %.1f kcal", summary.EstimatedCalories)
};
text(0.02, 0.95, metrics, "VerticalAlignment", "top", "FontSize", 11);
title("Session Summary");
end

