function plotActivityPie(features)
%PLOTACTIVITYPIE Show activity breakdown by window duration.

labels = categories(categorical(features.activityLabel));
minutes = zeros(numel(labels), 1);
for i = 1:numel(labels)
    minutes(i) = sum(features.durationSec(features.activityLabel == labels{i})) / 60;
end

valid = minutes > 0;
if ~any(valid)
    pie(1);
    title("Activity Breakdown");
    return;
end

pie(minutes(valid), labels(valid));
title("Activity Breakdown");
end

