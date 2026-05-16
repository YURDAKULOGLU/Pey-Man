# Pey-Man Specification

## Concept

Pey-Man is a MATLAB Mobile fitness tracker that turns phone sensor data into a workout quality summary. The first version computes a Fatigue Index and Workout Quality Score from acceleration data, uses a bounded ML classifier for sit/walk/run activity breakdown, and keeps a deterministic fallback demo mode.

## Current Surface

- Starter live script: `source/matlab-mobile-fitness-tracker-master/ExampleModel.mlx`
- Sample data: `ExampleData.mat`, `ActivityLogs.mat`
- Helper function: `timeElapsed.m`
- Official docs: `docs/Instructions.pdf`, `docs/GradingRubric.pdf`
- Repo goals: `GOALS.md`, `PLAN.md`, `docs/RUBRIC_CHECKLIST.md`

## Primitive Gap

The starter package has useful examples but no committed project-specific model contract, no reusable Pey-Man MATLAB package folder, no deterministic demo mode, and no verification note.

## Next Move

Implement a MATLAB Online-safe P0 pipeline under `source/pey_man/`: load data, extract windows, train/apply an activity classifier, compute the Fatigue Index, render the hero timeline, and print an English session summary.

## Rubric Map

| Rubric item | Pey-Man deliverable |
| --- | --- |
| Creativity | Workout quality and fatigue story, not a plain step counter |
| MATLAB mastery | Timetable handling, windowing, feature extraction, plotting |
| Functionality | Demo mode runs from clean checkout |
| Readability | Small named MATLAB helper files |
| Data visualization | Annotated Fatigue Index timeline plus dashboard |
| Model making | Raw sensor data to window features to activity labels and score |
| Advanced model making | Bounded sit/walk/run classifier with rule fallback |
| Presentation quality | Short demo runbook and judge-readable story |

## Data Contract

Required:

- `Acceleration.X`
- `Acceleration.Y`
- `Acceleration.Z`
- `Acceleration.Timestamp`

Optional:

- `Position.latitude`
- `Position.longitude`
- `Position.Timestamp`

Normalized internal session:

```matlab
session.acceleration
session.position
session.meta.sourceName
session.meta.demoMode
session.meta.hasGPS
```

Derived window table:

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

Final output:

- `FatigueIndex` in `[0, 100]`
- `WorkoutQualityScore` in `[0, 100]`
- `ConfidenceIndex` in `[0, 100]`
- `StepCount`
- `CadenceSpm`
- `EstimatedCalories`
- `activeMinutes`
- `distanceKm` or `NaN`
- `activityMix`
- at least two labeled plots

## Algorithm

1. Load acceleration and optional position data.
2. Compute acceleration magnitude.
3. Remove gravity or baseline drift with moving mean or moving median.
4. Segment into 4 second sliding windows with 75% overlap.
5. Extract per-window features.
6. Classify windows as sit/walk/run with `fitctree` when available, with deterministic fallback.
7. Compute fatigue from sustained load and late-session dropoff.
8. Compute workout quality from duration, intensity, consistency, and fatigue penalty.
9. Compute step count, distance fallback, calories, cadence, and confidence.
10. Render hero plot, dashboard, and a judge-readable English summary.

## Files To Create

- `source/pey_man/main.m`
- `source/pey_man/runPeyManPipeline.m`
- `source/pey_man/loadSessionData.m`
- `source/pey_man/preprocessSignal.m`
- `source/pey_man/windowizeSignal.m`
- `source/pey_man/extractFeatures.m`
- `source/pey_man/trainActivityClassifier.m`
- `source/pey_man/classifyActivity.m`
- `source/pey_man/computeBaseline.m`
- `source/pey_man/computeFatigueIndex.m`
- `source/pey_man/computeCadence.m`
- `source/pey_man/computeStepsDistance.m`
- `source/pey_man/computeCalories.m`
- `source/pey_man/computeQualityScore.m`
- `source/pey_man/computeConfidenceIndex.m`
- `source/pey_man/generateSessionSummary.m`
- `source/pey_man/plotFatigueTimeline.m`
- `source/pey_man/createDashboard.m`
- `source/pey_man/plotActivityPie.m`
- `source/pey_man/haversineDistance.m`

## Verification Gates

- Clean MATLAB Online run from repository checkout.
- `demoMode=true` runs with bundled data.
- Missing GPS does not crash the workflow.
- Scores stay within `[0, 100]`.
- Fatigue Index timeline renders with annotation and color bands.
- Dashboard renders quality, fatigue, confidence, activity mix, steps, distance, cadence, and calories.
- Malformed required input fails loudly.
- Baseline does not require Deep Learning Toolbox.
- ML activity classifier can fall back without breaking the demo.
- `demoMode` is discoverable without code edits.

## Skill Pattern Gates

- `mle-workflow`: data contract before code, baseline before ML.
- `ui-demo`: demo flow is discover, rehearse, record.
- `skill-scout`: inspect existing starter files before creating helpers.
- `workspace-surface-audit`: document current surface, primitive gap, next move.
- `mle-reviewer`: reject hidden thresholds and unverifiable score claims.

## Council Status

Council evidence is actionable. Kimi was initially broken because YSIS council routed the alias `kimi-k2.5` through the duplicate `ysis.agents.platforms` path without alias normalization. This was fixed in YSIS commits `0e5e243b` and `38e92478`. Final council run `council-b10d97abb7` produced Kimi, Codex, and Claude agreement. Gemini remained invalid in the council path and is not treated as approval evidence.
