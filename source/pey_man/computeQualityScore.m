function score = computeQualityScore(features, fatigueIndex)
%COMPUTEQUALITYSCORE Composite workout quality score in [0, 100].

activeMinutes = sum(features.durationSec(features.activityLabel ~= "sit")) / 60;
durationScore = clampValue(activeMinutes / 20, 0, 1);
intensityScore = clampValue(mean(features.intensityScore, "omitnan") / 100, 0, 1);
consistencyScore = 1 - clampValue(std(features.rmsDynAcc, "omitnan") / max(mean(features.rmsDynAcc, "omitnan"), 0.05), 0, 1);
confidenceScore = clampValue(mean(features.modelConfidence, "omitnan"), 0, 1);
fatiguePenalty = clampValue(fatigueIndex / 100, 0, 1);

quality = 0.25 * durationScore + 0.25 * intensityScore + 0.20 * consistencyScore + ...
    0.15 * confidenceScore + 0.15 * (1 - fatiguePenalty);
score = round(clampValue(100 * quality, 0, 100), 1);
end

