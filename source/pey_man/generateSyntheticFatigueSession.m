function [acceleration, position] = generateSyntheticFatigueSession()
%GENERATESYNTHETICFATIGUESESSION Synthetic fresh->rest->tired MATLAB Mobile-like session.
%
% The generator is a demo fallback. It is deterministic so repeatability tests
% can compare exact scores.

rng(42, "twister");

fs = 25;
t = (0:1/fs:12*60)';
amp = zeros(size(t));
freq = zeros(size(t));

% 0-1 min: baseline/rest, 1-5 min: walk, 5-8 min: run,
% 8-9 min: rest, 9-12 min: tired lower-cadence run/walk.
amp(t < 60) = 0.05;              freq(t < 60) = 0.15;
amp(t >= 60 & t < 300) = 0.55;   freq(t >= 60 & t < 300) = 1.65;
amp(t >= 300 & t < 480) = 1.05;  freq(t >= 300 & t < 480) = 2.55;
amp(t >= 480 & t < 540) = 0.08;  freq(t >= 480 & t < 540) = 0.20;
amp(t >= 540) = 0.78;            freq(t >= 540) = 1.95;

fatigueDrift = max(0, (t - 540) / 180);
amp = amp .* (1 - 0.18 * min(fatigueDrift, 1));
freq = freq .* (1 - 0.12 * min(fatigueDrift, 1));

noise = 0.05 * randn(size(t));
x = amp .* sin(2*pi.*freq.*t) + noise;
y = 0.45 * amp .* cos(2*pi.*freq.*t + 0.4) + noise;
z = 9.81 + 0.25 * amp .* sin(2*pi.*freq.*t + 1.2) + noise;

acceleration = timetable(seconds(t), x, y, z, 'VariableNames', ["X", "Y", "Z"]);

lat = 41 + cumsum(0.00000025 + 0.00000004 * randn(size(t)));
lon = 29 + cumsum(0.00000030 + 0.00000004 * randn(size(t)));
speed = max(0, amp .* freq);
position = timetable(seconds(t), lat, lon, speed, 'VariableNames', ["latitude", "longitude", "speed"]);
end

