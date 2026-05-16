function [cadenceSpm, cadenceByWindow] = computeCadence(features)
%COMPUTECADENCE Estimate steps per minute from dominant movement frequency.

cadenceByWindow = clampValue(features.dominantHz * 60, 0, 240);
active = features.activityLabel ~= "sit" & cadenceByWindow > 40;

if any(active)
    cadenceSpm = round(median(cadenceByWindow(active), "omitnan"), 1);
else
    cadenceSpm = 0;
end
end

