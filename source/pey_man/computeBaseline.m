function baseline = computeBaseline(features, baselineSeconds)
%COMPUTEBASELINE Estimate the personal baseline from early windows.

if nargin < 2 || isempty(baselineSeconds)
    baselineSeconds = 60;
end

mask = features.tStartSec <= baselineSeconds;
if sum(mask) < 3
    firstN = max(1, ceil(height(features) * 0.20));
    mask = false(height(features), 1);
    mask(1:firstN) = true;
end

baseline = struct();
baseline.meanRmsDynAcc = mean(features.rmsDynAcc(mask), "omitnan");
baseline.meanActiveRatio = mean(features.activeRatio(mask), "omitnan");
baseline.meanIntensity = mean(features.intensityScore(mask), "omitnan");
baseline.meanCadenceHz = mean(features.dominantHz(mask), "omitnan");
baseline.windowCount = sum(mask);
end

