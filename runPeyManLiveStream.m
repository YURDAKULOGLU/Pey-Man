function lastResult = runPeyManLiveStream(options)
%RUNPEYMANLIVESTREAM Launch live MATLAB Mobile streaming into Pey-Man.
%
% If MATLAB Mobile is not visible to mobiledev, this launcher falls back to the
% synthetic live stream. That keeps the demo presentation-safe while preserving
% the real phone path when Sensor Access is enabled.

if nargin < 1
    options = struct();
end

options = withDefault(options, "fallbackOnMissingDevice", true);
options = withDefault(options, "fallbackDurationSeconds", 45);
options = withDefault(options, "fallbackTickSeconds", 2);
options = withDefault(options, "openUi", true);

projectRoot = fileparts(mfilename("fullpath"));
addpath(fullfile(projectRoot, "source", "pey_man"));

try
    lastResult = peyManLiveStream(options);
catch err
    if ~shouldUseFallback(err, options)
        rethrow(err);
    end

    liveDir = fullfile(projectRoot, "outputs", "live");
    fprintf("\nPey-Man live phone stream is unavailable.\n");
    fprintf("Reason: %s\n", err.message);
    fprintf("Falling back to synthetic live stream for demo safety.\n\n");

    fallbackOptions = struct();
    fallbackOptions.durationSeconds = options.fallbackDurationSeconds;
    fallbackOptions.tickSeconds = options.fallbackTickSeconds;

    if options.openUi
        peyManPixelApp(liveDir, struct("autoRefreshSeconds", 2));
        drawnow;
    end

    simulateLiveStream(fallbackOptions);

    lastResult = struct();
    lastResult.mode = "synthetic_live_fallback";
    lastResult.reason = string(err.message);
    lastResult.outputDir = string(liveDir);
    lastResult.instructions = "Enable MATLAB Mobile > Sensors > More > Sensor Access, select Stream to MATLAB, then rerun runPeyManLiveStream for real phone streaming.";
end
end

function options = withDefault(options, name, value)
if ~isfield(options, name)
    options.(name) = value;
end
end

function tf = shouldUseFallback(err, options)
if ~options.fallbackOnMissingDevice
    tf = false;
    return;
end

message = string(err.message);
identifier = string(err.identifier);
lowerMessage = lower(message);
tf = contains(identifier, "PeyMan:MobileDisconnected") || ...
    contains(message, "Mobile devices not detected") || ...
    contains(message, "MATLAB Mobile is not connected") || ...
    contains(lowerMessage, "mobiledev") || ...
    contains(lowerMessage, "sensors support package") || ...
    contains(lowerMessage, "ml_android_sensors") || ...
    contains(lowerMessage, "ml_apple_ios_sensors");
end
