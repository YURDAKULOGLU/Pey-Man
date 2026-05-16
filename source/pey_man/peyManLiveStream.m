function lastResult = peyManLiveStream(options)
%PEYMANLIVESTREAM Stream MATLAB Mobile sensor data into the Pey-Man pipeline.
%
% This live mode is opt-in. It does not replace main.m or the synthetic
% fallback path used for the judged demo.

arguments
    options struct = struct()
end

options = withDefault(options, "deviceName", "");
options = withDefault(options, "outputDir", "");
options = withDefault(options, "refreshSeconds", 3);
options = withDefault(options, "bufferSeconds", 180);
options = withDefault(options, "minAnalysisSeconds", 24);
options = withDefault(options, "sampleRate", 25);
options = withDefault(options, "enablePosition", true);
options = withDefault(options, "openUi", true);
options = withDefault(options, "uiAutoRefreshSeconds", 2);
options = withDefault(options, "useML", true);
options = withDefault(options, "baselineSeconds", 60);
options = withDefault(options, "windowSeconds", 4);
options = withDefault(options, "windowOverlap", 0.75);
options = withDefault(options, "bodyMassKg", 70);
options = withDefault(options, "strideLengthM", 0.72);
options = withDefault(options, "maxDurationMinutes", inf);

thisDir = fileparts(mfilename("fullpath"));
projectRoot = fileparts(fileparts(thisDir));
outputDir = resolveOutputDir(projectRoot, options.outputDir);
activityLogFile = fullfile(projectRoot, "source", ...
    "matlab-mobile-fitness-tracker-master", "ActivityLogs.mat");
modelActivityLogFile = "";
if options.useML
    modelActivityLogFile = resolveActivityLogFile(activityLogFile, options);
end

if ~isfolder(outputDir)
    mkdir(outputDir);
end

device = connectMobileDevice(options);
cleanup = onCleanup(@() shutdownLiveDevice(device));

cachedModel = trainActivityClassifier(modelActivityLogFile, options);
buffer = initializeLiveBuffer();
lastResult = struct();

uiFig = [];
if options.openUi
    uiFig = peyManPixelApp(outputDir, struct("autoRefreshSeconds", options.uiAutoRefreshSeconds));
end

fprintf("Pey-Man live stream ready.\n");
fprintf("MATLAB Mobile should be signed into the same MathWorks account.\n");
fprintf("Stream target: MATLAB (Cloud). Stop with Ctrl+C or close the UI window.\n");

startTic = tic;
pause(1.0);

while shouldContinue(uiFig, startTic, options.maxDurationMinutes)
    pause(options.refreshSeconds);

    [buffer, chunk] = appendLiveLogs(buffer, device, options.bufferSeconds);
    liveSeconds = liveDurationSeconds(buffer.acceleration);

    if chunk.accSamples == 0 && chunk.posSamples == 0
        fprintf("LIVE WAIT | no new samples yet.\n");
        continue;
    end

    if liveSeconds < options.minAnalysisSeconds
        fprintf("LIVE BUFFER | %.1fs collected, waiting for %.1fs.\n", ...
            liveSeconds, options.minAnalysisSeconds);
        continue;
    end

    liveSession = buildLiveSession(buffer, device, options);
    pipelineOptions = struct();
    pipelineOptions.demoMode = false;
    pipelineOptions.useML = options.useML;
    pipelineOptions.baselineSeconds = options.baselineSeconds;
    pipelineOptions.windowSeconds = options.windowSeconds;
    pipelineOptions.windowOverlap = options.windowOverlap;
    pipelineOptions.bodyMassKg = options.bodyMassKg;
    pipelineOptions.strideLengthM = options.strideLengthM;
    pipelineOptions.renderPlots = false;
    pipelineOptions.enableCoachApi = false;
    pipelineOptions.activityLogFile = modelActivityLogFile;
    pipelineOptions.modelOverride = cachedModel;
    pipelineOptions.sessionOverride = liveSession;

    lastResult = runPeyManPipeline(pipelineOptions);
    exportPeyManArtifacts(lastResult, outputDir);

    fprintf("LIVE UPDATE | %s | now=%s | quality=%.1f | fatigue=%.1f | samples=%d\n", ...
        char(lastResult.summary.DetectedSport), ...
        upper(char(lastResult.summary.CurrentActivity)), ...
        lastResult.summary.WorkoutQualityScore, ...
        lastResult.summary.FatigueIndex, ...
        lastResult.summary.LiveSampleCount);
end
end

function value = resolveActivityLogFile(defaultPath, options)
value = defaultPath;
if isfield(options, "activityLogFile") && strlength(string(options.activityLogFile)) > 0
    value = char(string(options.activityLogFile));
end
end

function device = connectMobileDevice(options)
deviceName = string(options.deviceName);
if strlength(deviceName) > 0
    device = mobiledev(deviceName);
else
    device = mobiledev;
end

if device.Connected ~= 1
    error("PeyMan:MobileDisconnected", ...
        "MATLAB Mobile is not connected. Open MATLAB Mobile, sign into the same account, and enable Sensors.");
end

try
    device.Logging = 0;
catch
end

device.AccelerationSensorEnabled = 1;
if options.enablePosition
    try
        device.PositionSensorEnabled = 1;
    catch
    end
end

try
    device.SampleRate = options.sampleRate;
catch
end

device.Logging = 1;
end

function shutdownLiveDevice(device)
try
    device.Logging = 0;
catch
end
end

function buffer = initializeLiveBuffer()
buffer = struct();
buffer.acceleration = timetable();
buffer.position = timetable();
buffer.accelReadCount = 0;
buffer.posReadCount = 0;
end

function [buffer, chunk] = appendLiveLogs(buffer, device, bufferSeconds)
[accel, accelTime] = accellog(device);
accelStart = 1;
if buffer.accelReadCount <= size(accel, 1)
    accelStart = max(1, buffer.accelReadCount + 1);
end
newAccel = accel(accelStart:end, :);
newAccelTime = accelTime(accelStart:end);
buffer.accelReadCount = size(accel, 1);
accelChunk = accelerationTimetable(newAccel, newAccelTime);
buffer.acceleration = appendTimetable(buffer.acceleration, accelChunk);
buffer.acceleration = trimTimetable(buffer.acceleration, bufferSeconds);

posChunk = timetable();
try
    [lat, lon, posTime, speed, course, altitude, horizAcc] = poslog(device);
    posStart = 1;
    if buffer.posReadCount <= numel(lat)
        posStart = max(1, buffer.posReadCount + 1);
    end
    newPos = posStart:numel(lat);
    if ~isempty(newPos)
        posChunk = positionTimetable( ...
            lat(newPos), lon(newPos), posTime(newPos), speed(newPos), ...
            course(newPos), altitude(newPos), horizAcc(newPos));
    end
    buffer.posReadCount = numel(lat);
catch
    buffer.posReadCount = 0;
end

buffer.position = appendTimetable(buffer.position, posChunk);
buffer.position = trimTimetable(buffer.position, bufferSeconds);

chunk = struct();
chunk.accSamples = height(accelChunk);
chunk.posSamples = height(posChunk);
end

function tt = accelerationTimetable(accel, timestamp)
if isempty(accel)
    tt = timetable();
    return;
end

rowTimes = asDurationVector(timestamp);
tt = timetable(rowTimes, accel(:, 1), accel(:, 2), accel(:, 3), ...
    "VariableNames", ["X", "Y", "Z"]);
end

function tt = positionTimetable(lat, lon, timestamp, speed, course, altitude, horizAcc)
if isempty(lat)
    tt = timetable();
    return;
end

rowTimes = asDurationVector(timestamp);
tt = timetable(rowTimes, lat(:), lon(:), speed(:), course(:), altitude(:), horizAcc(:), ...
    "VariableNames", ["latitude", "longitude", "speed", "course", "altitude", "horizontalAccuracy"]);
end

function rowTimes = asDurationVector(timestamp)
if isempty(timestamp)
    rowTimes = seconds([]);
elseif isduration(timestamp)
    rowTimes = timestamp(:);
elseif isnumeric(timestamp)
    rowTimes = seconds(timestamp(:));
elseif isdatetime(timestamp)
    rowTimes = timestamp(:) - timestamp(1);
else
    error("PeyMan:BadTimestamp", "Unsupported live timestamp type.");
end
end

function tt = appendTimetable(existing, chunk)
if isempty(chunk) || height(chunk) == 0
    tt = existing;
    return;
end

if isempty(existing) || height(existing) == 0
    tt = sortrows(chunk);
    return;
end

tt = [existing; chunk];
[~, keep] = unique(tt.Properties.RowTimes, "last");
tt = sortrows(tt(sort(keep), :));
end

function tt = trimTimetable(tt, maxAgeSeconds)
if isempty(tt) || height(tt) == 0
    return;
end

latestTime = tt.Properties.RowTimes(end);
keep = latestTime - tt.Properties.RowTimes <= seconds(maxAgeSeconds);
tt = tt(keep, :);
end

function session = buildLiveSession(buffer, device, options)
session = struct();
session.acceleration = buffer.acceleration(:, ["X", "Y", "Z"]);
session.position = buffer.position;
session.meta = struct();
session.meta.sourceName = resolveDeviceName(device);
session.meta.sourceKind = "live_mobile_stream";
session.meta.demoMode = false;
session.meta.liveRefreshSeconds = options.refreshSeconds;
session.meta.liveBufferSeconds = options.bufferSeconds;
session.meta.hasGPS = ~isempty(session.position) && height(session.position) > 1;
end

function secondsValue = liveDurationSeconds(tt)
if isempty(tt) || height(tt) < 2
    secondsValue = 0;
    return;
end
secondsValue = seconds(tt.Properties.RowTimes(end) - tt.Properties.RowTimes(1));
end

function tf = shouldContinue(uiFig, startTic, maxDurationMinutes)
timeOk = toc(startTic) <= maxDurationMinutes * 60;
if isempty(uiFig)
    tf = timeOk;
else
    tf = isvalid(uiFig) && timeOk;
end
end

function outputDir = resolveOutputDir(projectRoot, outputDir)
if strlength(string(outputDir)) == 0
    outputDir = fullfile(projectRoot, "outputs", "live");
end
end

function name = resolveDeviceName(device)
name = "mobiledev";
if isprop(device, "Device")
    try
        name = string(device.Device);
    catch
    end
end
end

function options = withDefault(options, name, value)
if ~isfield(options, name)
    options.(name) = value;
end
end
