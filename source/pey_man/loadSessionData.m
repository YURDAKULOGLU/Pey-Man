function session = loadSessionData(options)
%LOADSESSIONDATA Normalize MATLAB Mobile data into the Pey-Man session shape.

dataFile = getOption(options, "dataFile", "");
demoMode = getOption(options, "demoMode", true);

try
    if strlength(string(dataFile)) > 0 && isfile(dataFile)
        raw = load(dataFile);
        acceleration = findTimetable(raw, "Acceleration");
        position = findTimetable(raw, "Position");
    else
        acceleration = timetable();
        position = timetable();
    end
catch err
    if ~demoMode
        rethrow(err);
    end
    acceleration = timetable();
    position = timetable();
end

if isempty(acceleration) || height(acceleration) == 0
    if ~demoMode
        error("PeyMan:MissingAcceleration", "No acceleration timetable found.");
    end
    [acceleration, position] = generateDemoSession();
end

acceleration = normalizeAcceleration(acceleration);
position = normalizePosition(position);

session = struct();
session.acceleration = acceleration;
session.position = position;
session.meta = struct();
session.meta.sourceName = string(dataFile);
session.meta.demoMode = demoMode;
session.meta.hasGPS = ~isempty(position) && height(position) > 1;
end

function tt = findTimetable(raw, preferredName)
tt = timetable();
if isfield(raw, preferredName) && istimetable(raw.(preferredName))
    tt = raw.(preferredName);
    return;
end

names = fieldnames(raw);
for i = 1:numel(names)
    value = raw.(names{i});
    if istimetable(value) && contains(lower(names{i}), lower(preferredName))
        tt = value;
        return;
    end
end

if preferredName == "Acceleration"
    for i = 1:numel(names)
        value = raw.(names{i});
        if istimetable(value) && all(ismember(["X", "Y", "Z"], string(value.Properties.VariableNames)))
            tt = value;
            return;
        end
    end
end
end

function acc = normalizeAcceleration(acc)
required = ["X", "Y", "Z"];
if ~istimetable(acc) || ~all(ismember(required, string(acc.Properties.VariableNames)))
    error("PeyMan:BadAcceleration", "Acceleration input must be a timetable with X, Y, Z variables.");
end
acc = sortrows(acc(:, required));
acc = rmmissing(acc);
end

function pos = normalizePosition(pos)
if isempty(pos) || ~istimetable(pos) || height(pos) == 0
    pos = timetable();
    return;
end
pos = sortrows(pos);
end

function [acc, pos] = generateDemoSession()
fs = 25;
t = (0:1/fs:12*60)';
amp = zeros(size(t));
freq = zeros(size(t));

amp(t < 60) = 0.05;            freq(t < 60) = 0.15;
amp(t >= 60 & t < 300) = 0.55; freq(t >= 60 & t < 300) = 1.65;
amp(t >= 300 & t < 480) = 1.05; freq(t >= 300 & t < 480) = 2.55;
amp(t >= 480) = 0.82;          freq(t >= 480) = 2.10;

noise = 0.05 * randn(size(t));
x = amp .* sin(2*pi.*freq.*t) + noise;
y = 0.45 * amp .* cos(2*pi.*freq.*t + 0.4) + noise;
z = 9.81 + 0.25 * amp .* sin(2*pi.*freq.*t + 1.2) + noise;
acc = timetable(seconds(t), x, y, z, 'VariableNames', ["X", "Y", "Z"]);

lat = 41 + cumsum(0.00000025 + 0.00000005 * randn(size(t)));
lon = 29 + cumsum(0.00000030 + 0.00000005 * randn(size(t)));
speed = max(0, amp .* freq);
pos = timetable(seconds(t), lat, lon, speed, 'VariableNames', ["latitude", "longitude", "speed"]);
end

function value = getOption(options, name, defaultValue)
if isfield(options, name)
    value = options.(name);
else
    value = defaultValue;
end
end

