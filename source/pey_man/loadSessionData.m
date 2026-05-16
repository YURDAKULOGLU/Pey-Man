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
[acc, pos] = generateSyntheticFatigueSession();
end

function value = getOption(options, name, defaultValue)
if isfield(options, name)
    value = options.(name);
else
    value = defaultValue;
end
end

