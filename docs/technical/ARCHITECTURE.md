# Pey-Man Architecture

## Objective

Turn MATLAB Mobile sensor data into a short, judge-readable workout story:

```text
phone sensors -> normalized session -> windows -> features -> activity labels
             -> fatigue / quality / confidence metrics -> plots + English summary
```

## Runtime Entry Points

- `source/pey_man/main.m`: P0 model/demo entrypoint.
- `runPeyManPixelApp.m`: Pac-Man inspired UI entrypoint.
- `source/pey_man/peyManPixelApp.m`: MATLAB-only UI.

The model pipeline and pixel UI are separate until V3. A working model is more important than UI polish.

## Module Map

| Layer | Files | Responsibility |
| --- | --- | --- |
| Input | `loadSessionData.m` | Load `.mat` files, normalize acceleration/GPS timetables, generate demo fallback if needed. |
| Preprocess | `preprocessSignal.m` | Magnitude, baseline/gravity estimate, dynamic acceleration. |
| Windowing | `windowizeSignal.m` | 4 second windows with 75 percent overlap. |
| Features | `extractFeatures.m`, `bandPowerWelch.m` | Motion intensity, active ratio, peaks, dominant cadence frequency, spectral power, GPS speed. |
| ML Activity | `trainActivityClassifier.m`, `classifyActivity.m`, `featurePredictorTable.m` | Train/apply sit/walk/run classifier; rule fallback if ML toolbox is unavailable. |
| Personal Baseline | `computeBaseline.m` | First 60 seconds, or first 20 percent of a short session. |
| Metrics | `computeFatigueIndex.m`, `computeQualityScore.m`, `computeConfidenceIndex.m`, `computeCadence.m`, `computeStepsDistance.m`, `computeCalories.m` | Explainable scores and standard fitness metrics. |
| Visualization | `plotFatigueTimeline.m`, `createDashboard.m`, `plotActivityPie.m` | Hero fatigue plot, dashboard, activity breakdown. |
| Narrative | `generateSessionSummary.m` | English demo summary. |

## ML Boundary

ML is used for activity classification only:

```text
ActivityLogs.mat -> labeled windows -> fitctree -> sit/walk/run labels
```

Fatigue and quality scores are formulas. This is intentional: judges can inspect the score logic and the demo does not depend on a fragile black-box fatigue model.

## No-Hardcode Contract

- Source code must not contain local absolute paths such as `C:\...` or `C:/...`.
- Source code uses repo-relative paths from `main.m`.
- Team-collected private raw data is not committed by default.
- Optional GPS and ML toolbox failures must not crash the P0 demo.
- Thresholds must be visible constants or documented formulas, not hidden magic.

## CI Contract

The CI hygiene gate checks:

- required source files exist,
- source files do not contain local absolute paths,
- private `.mat` files are not added outside the starter data folder,
- documentation references remain aligned with `source/pey_man/main.m`.

MATLAB execution is still verified locally and in MATLAB Online; GitHub CI is a lightweight collaboration guard, not the full numerical validator.

