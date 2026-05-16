function features = extractFeatures(session, processed, windows)
%EXTRACTFEATURES Compute compact per-window sensor features.

n = height(windows);
meanDynAcc = zeros(n, 1);
stdDynAcc = zeros(n, 1);
rmsDynAcc = zeros(n, 1);
peakCount = zeros(n, 1);
activeRatio = zeros(n, 1);
dominantHz = zeros(n, 1);
spectralPower = zeros(n, 1);
speedMps = nan(n, 1);

globalActiveThreshold = median(processed.smoothDynamicAcceleration, "omitnan") + ...
    0.30 * std(processed.smoothDynamicAcceleration, "omitnan");

for i = 1:n
    idx = windows.startIndex(i):windows.endIndex(i);
    x = processed.smoothDynamicAcceleration(idx);
    meanDynAcc(i) = mean(x, "omitnan");
    stdDynAcc(i) = std(x, "omitnan");
    rmsDynAcc(i) = sqrt(mean(x.^2, "omitnan"));
    peakCount(i) = countPeaks(x);
    activeRatio(i) = mean(x > globalActiveThreshold, "omitnan");
    dominantHz(i) = dominantFrequency(x, processed.sampleRateHz);
    spectralPower(i) = bandPowerWelch(x, processed.sampleRateHz, [0.7 3.5]);
    speedMps(i) = meanGpsSpeed(session, windows.tStartSec(i), windows.tEndSec(i));
end

intensityScore = clampValue(100 * normalize01(rmsDynAcc), 0, 100);
features = windows;
features.meanDynAcc = meanDynAcc;
features.stdDynAcc = stdDynAcc;
features.rmsDynAcc = rmsDynAcc;
features.peakCount = peakCount;
features.activeRatio = activeRatio;
features.dominantHz = dominantHz;
features.spectralPower = spectralPower;
features.speedMps = speedMps;
features.intensityScore = intensityScore;
features.activityLabel = categorical(repmat("unknown", n, 1));
features.modelConfidence = 0.75 * ones(n, 1);
end

function c = countPeaks(x)
if numel(x) < 3
    c = 0;
    return;
end
threshold = median(x, "omitnan") + 0.25 * std(x, "omitnan");
isPeak = x(2:end-1) > x(1:end-2) & x(2:end-1) >= x(3:end) & x(2:end-1) > threshold;
c = sum(isPeak);
end

function hz = dominantFrequency(x, fs)
x = x(:) - mean(x, "omitnan");
if numel(x) < 4 || all(abs(x) < eps)
    hz = 0;
    return;
end
y = abs(fft(x));
freq = (0:numel(y)-1)' * fs / numel(y);
mask = freq >= 0.4 & freq <= 4.0;
if ~any(mask)
    hz = 0;
    return;
end
[~, localIdx] = max(y(mask));
freqs = freq(mask);
hz = freqs(localIdx);
end

function speed = meanGpsSpeed(session, startSec, endSec)
speed = NaN;
if ~session.meta.hasGPS || ~ismember("speed", string(session.position.Properties.VariableNames))
    return;
end
pt = seconds(session.position.Properties.RowTimes - session.position.Properties.RowTimes(1));
mask = pt >= startSec & pt <= endSec;
if any(mask)
    speed = mean(session.position.speed(mask), "omitnan");
end
end

function y = normalize01(x)
lo = min(x, [], "omitnan");
hi = max(x, [], "omitnan");
if ~isfinite(lo) || ~isfinite(hi) || abs(hi - lo) < eps
    y = zeros(size(x));
else
    y = (x - lo) ./ (hi - lo);
end
end

