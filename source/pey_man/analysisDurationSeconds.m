function seconds = analysisDurationSeconds(features)
%ANALYSISDURATIONSECONDS Return non-overlapping represented seconds per window.

if istable(features) && ismember("effectiveDurationSec", string(features.Properties.VariableNames))
    seconds = features.effectiveDurationSec;
else
    seconds = features.durationSec;
end

seconds = max(seconds, 0);
end
