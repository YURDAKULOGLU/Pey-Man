function confidence = computeConfidenceIndex(session, features)
%COMPUTECONFIDENCEINDEX Estimate how trustworthy the sensor-derived outputs are.

t = seconds(session.acceleration.Properties.RowTimes - session.acceleration.Properties.RowTimes(1));
dt = diff(t);
dt = dt(isfinite(dt) & dt > 0);
if isempty(dt)
    sampleRegularity = 0.5;
else
    sampleRegularity = clampValue(1 - std(dt, "omitnan") / max(mean(dt, "omitnan"), eps), 0, 1);
end

durationScore = clampValue((max(t) - min(t)) / 180, 0, 1);
classifierScore = clampValue(mean(features.modelConfidence, "omitnan"), 0, 1);
gpsScore = 0.75 + 0.25 * double(session.meta.hasGPS);

confidence = round(100 * (0.35 * sampleRegularity + 0.25 * durationScore + ...
    0.25 * classifierScore + 0.15 * gpsScore), 1);
confidence = clampValue(confidence, 0, 100);
end

