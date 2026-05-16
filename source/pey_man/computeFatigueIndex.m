function [fatigueIndex, timeline] = computeFatigueIndex(features, baseline)
%COMPUTEFATIGUEINDEX Explainable composite fatigue score.

rmsBase = max(baseline.meanRmsDynAcc, 0.05);
activeBase = max(baseline.meanActiveRatio, 0.10);
cadenceBase = max(baseline.meanCadenceHz, 0.50);

loadRatio = features.rmsDynAcc ./ rmsBase;
lateWeight = normalize01(features.tStartSec);
consistencyDrop = max(0, activeBase - features.activeRatio) ./ activeBase;
cadenceDrop = max(0, cadenceBase - features.dominantHz) ./ cadenceBase;
excessLoad = clampValue((loadRatio - 1.0) / 1.5, 0, 1);

fatigueByWindow = 100 * (0.40 * excessLoad + 0.25 * consistencyDrop + ...
    0.20 * cadenceDrop + 0.15 * lateWeight .* excessLoad);
fatigueByWindow = clampValue(movmean(fatigueByWindow, 5, "omitnan"), 0, 100);
fatigueByWindow(~isfinite(fatigueByWindow)) = 0;

lastThird = features.tStartSec >= quantile(features.tStartSec, 0.66);
if any(lastThird)
    fatigueIndex = 0.65 * mean(fatigueByWindow(lastThird), "omitnan") + 0.35 * max(fatigueByWindow);
else
    fatigueIndex = mean(fatigueByWindow, "omitnan");
end
fatigueIndex = round(clampValue(fatigueIndex, 0, 100), 1);
if ~isfinite(fatigueIndex)
    fatigueIndex = 0;
end

[peakValue, peakIdx] = max(fatigueByWindow);
if isempty(peakValue) || ~isfinite(peakValue)
    peakValue = 0;
    peakIdx = 1;
end
peakMinute = features.tStartSec(peakIdx) / 60;
if ~isfinite(peakMinute)
    peakMinute = 0;
end

timeline = table(features.tStartSec / 60, fatigueByWindow, features.activityLabel, ...
    'VariableNames', ["minute", "FatigueIndex", "activityLabel"]);
timeline.peakMinute = repmat(peakMinute, height(timeline), 1);
timeline.peakValue = repmat(peakValue, height(timeline), 1);
timeline.peakLabel = repmat(fatiguePeakLabel(peakValue, peakMinute), height(timeline), 1);
end

function y = normalize01(x)
lo = min(x, [], "omitnan");
hi = max(x, [], "omitnan");
if ~isfinite(lo) || ~isfinite(hi) || abs(hi - lo) < eps
    y = zeros(size(x));
else
    y = (x - lo) ./ (hi - lo);
end
end

function label = minuteLabel(minuteValue)
totalSeconds = max(0, round(minuteValue * 60));
label = sprintf("%d:%02d", floor(totalSeconds / 60), mod(totalSeconds, 60));
end

function label = fatiguePeakLabel(peakValue, peakMinute)
if peakValue >= 70
    prefix = "Elevated Fatigue Signal at ";
elseif peakValue >= 35
    prefix = "Moderate Fatigue Signal at ";
else
    prefix = "Peak Fatigue Signal at ";
end
label = prefix + minuteLabel(peakMinute);
end
