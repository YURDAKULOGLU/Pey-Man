function out = computeStepsDistance(session, features, cadenceByWindow, options)
%COMPUTESTEPSDISTANCE Estimate step count and distance with GPS fallback.

strideLengthM = getOption(options, "strideLengthM", 0.72);
active = features.activityLabel ~= "sit";
seconds = analysisDurationSeconds(features);
stepsByWindow = cadenceByWindow ./ 60 .* seconds;
stepCount = round(sum(stepsByWindow(active), "omitnan"));

gpsDistanceKm = NaN;
if session.meta.hasGPS && all(ismember(["latitude", "longitude"], string(session.position.Properties.VariableNames)))
    gpsDistanceKm = haversineDistance(session.position.latitude, session.position.longitude) / 1000;
end

if isfinite(gpsDistanceKm) && gpsDistanceKm > 0
    distanceKm = gpsDistanceKm;
    distanceSource = "gps";
else
    distanceKm = stepCount * strideLengthM / 1000;
    distanceSource = "stride_fallback";
end

out = struct();
out.stepCount = stepCount;
out.distanceKm = round(distanceKm, 3);
out.distanceSource = distanceSource;
end

function value = getOption(options, name, defaultValue)
if isfield(options, name)
    value = options.(name);
else
    value = defaultValue;
end
end

