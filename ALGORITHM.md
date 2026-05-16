# Algorithm

## Baseline

The baseline is MATLAB Online-safe and explainable. The activity breakdown uses a small supervised classifier when available; the Fatigue Index and Workout Quality Score remain transparent formulas.

## Processing Steps

1. Load sample or collected MATLAB Mobile data.
2. Normalize the data into the project data contract.
3. Compute acceleration magnitude:

```matlab
accMag = sqrt(X.^2 + Y.^2 + Z.^2);
```

4. Estimate dynamic acceleration by subtracting a moving baseline.
5. Split the session into 4 second sliding windows with 75% overlap.
6. Compute window features:
   - mean dynamic acceleration
   - standard deviation
   - RMS
   - peak count
   - active ratio
   - optional GPS speed
   - intensity score
7. Train or load a sit/walk/run classifier and assign one label per window.
8. Compute Fatigue Index.
9. Compute Workout Quality Score.
10. Compute confidence, cadence, steps, distance, and calories.
11. Plot and summarize results.

## ML Activity Classifier

The ML feature is intentionally narrow:

```text
ActivityLogs.mat -> labeled windows -> feature table -> fitctree -> sit/walk/run labels
```

If `fitctree` is unavailable, `classifyActivity.m` uses an explicit rule fallback. This keeps the demo runnable while still allowing a real classifier on MATLAB installations with Statistics and Machine Learning Toolbox.

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

## Confidence Index

Sensor claims should not sound absolute. Confidence is estimated from:

- sample regularity,
- session duration,
- classifier confidence,
- GPS availability.

Example presentation line:

```text
Movement confidence is 90% based on sensor regularity, classifier margin, and GPS availability.
```
