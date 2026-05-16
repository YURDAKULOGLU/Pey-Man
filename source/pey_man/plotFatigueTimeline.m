function plotFatigueTimeline(timeline)
%PLOTFATIGUETIMELINE Hero annotated fatigue plot.

figure("Name", "Pey-Man Fatigue Index Timeline", "Color", "w");
hold on;

x = timeline.minute;
y = timeline.FatigueIndex;
xRange = [min(x) max(x)];
if ~all(isfinite(xRange)) || xRange(1) == xRange(2)
    xRange = [0 1];
end

drawBand(xRange, 0, 35, [0.50 0.85 0.50], 0.22);
drawBand(xRange, 35, 70, [0.95 0.80 0.25], 0.18);
drawBand(xRange, 70, 100, [0.90 0.25 0.25], 0.16);
plot(x, y, "k-", "LineWidth", 2.2);
xline(timeline.peakMinute(1), "--", "LineWidth", 1.2, "Color", [0.35 0.35 0.35]);
placePeakLabel(xRange, timeline.peakMinute(1), timeline.peakValue(1), timeline.peakLabel(1));
yline(35, ":", "Moderate", "Color", [0.45 0.38 0.05], "LabelHorizontalAlignment", "left");
yline(70, ":", "Elevated", "Color", [0.55 0.10 0.10], "LabelHorizontalAlignment", "left");

xlim(xRange);
ylim([0 100]);
xlabel("Minute");
ylabel("Fatigue Index");
title("Pey-Man Fatigue Index Timeline");
subtitle("Threshold bands are fixed: low 0-35, moderate 35-70, elevated 70-100");
grid on;
hold off;
end

function drawBand(xRange, yLow, yHigh, colorValue, alphaValue)
patch([xRange(1) xRange(2) xRange(2) xRange(1)], ...
    [yLow yLow yHigh yHigh], colorValue, ...
    "EdgeColor", "none", "FaceAlpha", alphaValue);
end

function placePeakLabel(xRange, peakMinute, peakValue, label)
rangeWidth = max(xRange(2) - xRange(1), eps);
if peakMinute > xRange(1) + 0.72 * rangeWidth
    horizontal = "right";
    xOffset = -0.02 * rangeWidth;
else
    horizontal = "left";
    xOffset = 0.02 * rangeWidth;
end

text(peakMinute + xOffset, min(max(peakValue + 8, 12), 95), label, ...
    "FontWeight", "bold", ...
    "HorizontalAlignment", horizontal, ...
    "VerticalAlignment", "bottom", ...
    "Color", [0.10 0.10 0.10]);
end

