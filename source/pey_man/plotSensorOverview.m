function plotSensorOverview(session, processed, features)
%PLOTSENSOROVERVIEW Show raw sensor signal and extracted ML windows.

figure("Name", "Pey-Man Sensor + Feature Overview", "Color", "w");
tiledlayout(2, 1, "Padding", "compact", "TileSpacing", "compact");

nexttile;
hold on;
tMin = processed.timeSec / 60;
plot(tMin, session.acceleration.X, "Color", [0.30 0.45 0.95], "LineWidth", 0.8, "DisplayName", "X");
plot(tMin, session.acceleration.Y, "Color", [0.95 0.35 0.30], "LineWidth", 0.8, "DisplayName", "Y");
plot(tMin, session.acceleration.Z, "Color", [0.25 0.65 0.25], "LineWidth", 0.8, "DisplayName", "Z");
plot(tMin, processed.magnitude, "k-", "LineWidth", 1.2, "DisplayName", "Magnitude");
title("Raw Acceleration and Magnitude");
ylabel("m/s^2");
legend("Location", "best");
grid on;
hideToolbar(gca);
hold off;

nexttile;
hold on;
plot(features.tStartSec / 60, features.rmsDynAcc, "k-", "LineWidth", 1.2, "DisplayName", "Dynamic RMS");
labels = categories(categorical(features.activityLabel));
colors = containers.Map(["sit", "walk", "run", "unknown"], ...
    {[0.35 0.35 0.35], [0.15 0.55 0.95], [0.95 0.35 0.10], [0.60 0.60 0.60]});
for i = 1:numel(labels)
    mask = features.activityLabel == labels{i};
    if any(mask)
        color = [0.60 0.60 0.60];
        if isKey(colors, labels{i})
            color = colors(labels{i});
        end
        scatter(features.tStartSec(mask) / 60, features.rmsDynAcc(mask), 18, color, "filled", ...
            "DisplayName", labels{i});
    end
end
title("ML Feature Windows by Activity Label");
xlabel("Minute");
ylabel("Dynamic RMS");
legend("Location", "best");
grid on;
hideToolbar(gca);
hold off;
end

function hideToolbar(ax)
try
    ax.Toolbar.Visible = "off";
catch
end
end
