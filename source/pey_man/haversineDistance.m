function distanceM = haversineDistance(latitude, longitude)
%HAVERSINEDISTANCE Total path length in meters.

latitude = latitude(:);
longitude = longitude(:);
valid = isfinite(latitude) & isfinite(longitude);
latitude = latitude(valid);
longitude = longitude(valid);

if numel(latitude) < 2
    distanceM = NaN;
    return;
end

r = 6371000;
lat1 = deg2rad(latitude(1:end-1));
lat2 = deg2rad(latitude(2:end));
dLat = deg2rad(diff(latitude));
dLon = deg2rad(diff(longitude));
a = sin(dLat/2).^2 + cos(lat1) .* cos(lat2) .* sin(dLon/2).^2;
c = 2 * atan2(sqrt(a), sqrt(1-a));
distanceM = sum(r * c, "omitnan");
end

