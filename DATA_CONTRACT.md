# Data Contract

## Required Input

The baseline requires an acceleration timetable or equivalent struct with:

- `X`: acceleration on x axis
- `Y`: acceleration on y axis
- `Z`: acceleration on z axis
- `Timestamp`: sample time

Accepted source names may vary in starter files, but `loadSessionData.m` must normalize the data into one internal shape.

## Optional Input

Position data may be present:

- `latitude`
- `longitude`
- `Timestamp`

If position data is absent, distance is reported as `NaN` and the rest of the workflow continues.

## Internal Session Shape

```matlab
session.acceleration
session.position
session.meta.sourceName
session.meta.demoMode
session.meta.hasGPS
```

## Derived Window Shape

Each analysis window should include:

- `tStart`
- `tEnd`
- `durationSec`
- `meanDynAcc`
- `stdDynAcc`
- `rmsDynAcc`
- `peakCount`
- `activeRatio`
- `speedMps`
- `activityLabel`
- `intensityScore`

## Output Shape

```matlab
summary.FatigueIndex
summary.WorkoutQualityScore
summary.activeMinutes
summary.distanceKm
summary.activityMix
summary.recommendation
```

## Failure Policy

- Missing required acceleration data: fail loud with a clear error.
- Missing optional GPS data: continue without distance.
- Empty session: fail loud unless `demoMode=true`.
- NaN rows: drop or ignore with an explicit warning.
- Score bounds: clamp final scores to `[0, 100]` and document the clamp.
