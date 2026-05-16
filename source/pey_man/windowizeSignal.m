function windows = windowizeSignal(processed, windowSeconds, overlap)
%WINDOWIZESIGNAL Build overlapping analysis windows.

if nargin < 2 || isempty(windowSeconds)
    windowSeconds = 4;
end
if nargin < 3 || isempty(overlap)
    overlap = 0.75;
end

n = numel(processed.timeSec);
fs = processed.sampleRateHz;
windowSamples = max(8, round(windowSeconds * fs));
hopSamples = max(1, round(windowSamples * (1 - overlap)));

if n <= windowSamples
    starts = 1;
else
    starts = 1:hopSamples:(n - windowSamples + 1);
end
ends = min(starts + windowSamples - 1, n);

tStartSec = processed.timeSec(starts);
tEndSec = processed.timeSec(ends);
durationSec = max(0, tEndSec - tStartSec);
effectiveDurationSec = representedDuration(tStartSec, durationSec);

windows = table(starts(:), ends(:), tStartSec(:), tEndSec(:), durationSec(:), effectiveDurationSec(:), ...
    'VariableNames', ["startIndex", "endIndex", "tStartSec", "tEndSec", "durationSec", "effectiveDurationSec"]);
end

function seconds = representedDuration(tStartSec, durationSec)
%REPRESENTEDDURATION Duration represented by each overlapped analysis window.

if numel(tStartSec) <= 1
    seconds = durationSec;
    return;
end

hopSeconds = median(diff(tStartSec), "omitnan");
if ~isfinite(hopSeconds) || hopSeconds <= 0
    hopSeconds = median(durationSec, "omitnan");
end
if ~isfinite(hopSeconds) || hopSeconds <= 0
    hopSeconds = 1;
end

seconds = repmat(hopSeconds, size(durationSec));
seconds = min(seconds, durationSec);
seconds = max(seconds, 0);
end
