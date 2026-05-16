function processed = preprocessSignal(session)
%PREPROCESSSIGNAL Compute magnitude and dynamic acceleration.

acc = session.acceleration;
t = seconds(acc.Properties.RowTimes - acc.Properties.RowTimes(1));
dt = diff(t);
dt = dt(isfinite(dt) & dt > 0);
if isempty(dt)
    fs = 25;
else
    fs = 1 / median(dt);
end

mag = sqrt(acc.X.^2 + acc.Y.^2 + acc.Z.^2);
baselineWindow = max(5, round(fs * 2));
gravity = movmedian(mag, baselineWindow, "omitnan");
dyn = abs(mag - gravity);
smoothDyn = movmean(dyn, max(3, round(fs * 0.35)), "omitnan");

processed = struct();
processed.timeSec = t;
processed.sampleRateHz = fs;
processed.magnitude = mag;
processed.gravityEstimate = gravity;
processed.dynamicAcceleration = dyn;
processed.smoothDynamicAcceleration = smoothDyn;
end

