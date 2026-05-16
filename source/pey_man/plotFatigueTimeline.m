function plotFatigueTimeline(timeline)
%PLOTFATIGUETIMELINE Hero annotated fatigue plot.

figure("Name", "Pey-Man Fatigue Index Timeline", "Color", "w");
hold on;

x = timeline.minute;
y = timeline.FatigueIndex;
area(x, min(y, 35), "FaceColor", [0.50 0.85 0.50], "EdgeColor", "none", "FaceAlpha", 0.45);
area(x, max(0, min(y, 70) - 35), 35, "FaceColor", [0.95 0.80 0.25], "EdgeColor", "none", "FaceAlpha", 0.35);
area(x, max(0, y - 70), 70, "FaceColor", [0.90 0.25 0.25], "EdgeColor", "none", "FaceAlpha", 0.30);
plot(x, y, "k-", "LineWidth", 2.2);
xline(timeline.peakMinute(1), "--", timeline.peakLabel(1), "LabelOrientation", "horizontal", "LineWidth", 1.2);

ylim([0 100]);
xlabel("Minute");
ylabel("Fatigue Index");
title("Pey-Man Fatigue Index Timeline");
subtitle("Green/yellow/red fill shows low, medium, and elevated fatigue bands");
grid on;
hold off;
end

