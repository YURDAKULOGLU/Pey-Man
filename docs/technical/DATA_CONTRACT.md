# Data Contract

## Required Input

The baseline requires an acceleration timetable or equivalent struct with:

- `X`: acceleration on x axis
- `Y`: acceleration on y axis
- `Z`: acceleration on z axis
- `Timestamp`: sample time

Accepted source names may vary in starter files, but `loadSessionData.m` must normalize the data into one internal shape.

Optional live input can also arrive through `mobiledev` and must be normalized into the same internal shape before calling the pipeline.

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
session.meta.sourceKind
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
summary.ConfidenceIndex
summary.StepCount
summary.CadenceSpm
summary.EstimatedCalories
summary.CurrentActivity
summary.CurrentActivityConfidence
summary.activeMinutes
summary.distanceKm
summary.distanceSource
summary.activityMix
summary.recommendation
```

## Failure Policy

- Missing required acceleration data: fail loud with a clear error.
- Missing optional GPS data: continue without distance.
- Empty session: fail loud unless `demoMode=true`.
- NaN rows: drop or ignore with an explicit warning.
- Score bounds: clamp final scores to `[0, 100]` and document the clamp.
- Live-stream disconnects: fail soft by stopping the loop or falling back to replay, not by breaking the baseline demo path.
