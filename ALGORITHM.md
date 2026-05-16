# Algorithm

## Baseline

The baseline is deterministic. It does not need Classification Learner, Deep Learning Toolbox, or trained model artifacts.

## Processing Steps

1. Load sample or collected MATLAB Mobile data.
2. Normalize the data into the project data contract.
3. Compute acceleration magnitude:

```matlab
accMag = sqrt(X.^2 + Y.^2 + Z.^2);
```

4. Estimate dynamic acceleration by subtracting a moving baseline.
5. Split the session into 2-4 second sliding windows with 50% overlap.
6. Compute window features:
   - mean dynamic acceleration
   - standard deviation
   - RMS
   - peak count
   - active ratio
   - optional GPS speed
   - intensity score
7. Assign a rule-based activity label per window.
8. Compute Fatigue Index.
9. Compute Workout Quality Score.
10. Plot and summarize results.

## Fatigue Index

Fatigue is based on late-session dropoff and sustained load. It should be explainable from the window table and bounded to `[0, 100]`.

Suggested formula shape:

```text
fatigue = loadScore * 0.5 + dropoffScore * 0.5
FatigueIndex = clamp(100 * fatigue, 0, 100)
```

## Workout Quality Score

Workout quality rewards useful work and penalizes excessive fatigue:

```text
quality = durationScore * 0.25
        + intensityScore * 0.30
        + consistencyScore * 0.25
        + (1 - fatiguePenalty) * 0.20

WorkoutQualityScore = clamp(100 * quality, 0, 100)
```

The exact weights can be tuned, but they must remain visible as named constants in code and documented.

## Deferred ML Lane

An ML classifier can be added later only if:

- deterministic baseline is green,
- training data is sufficient,
- verification remains reproducible,
- baseline demo path remains unchanged.
