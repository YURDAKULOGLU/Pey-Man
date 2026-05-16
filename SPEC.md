# Pey-Man Specification

## Concept

Pey-Man is a MATLAB Mobile fitness tracker that turns phone sensor data into a workout quality summary. The first version computes a Fatigue Index and Workout Quality Score from acceleration data, with optional GPS distance support and a deterministic demo mode.

## Current Surface

- Starter live script: `source/matlab-mobile-fitness-tracker-master/ExampleModel.mlx`
- Sample data: `ExampleData.mat`, `ActivityLogs.mat`
- Helper function: `timeElapsed.m`
- Official docs: `docs/Instructions.pdf`, `docs/GradingRubric.pdf`
- Repo goals: `GOALS.md`, `PLAN.md`, `docs/RUBRIC_CHECKLIST.md`

## Primitive Gap

The starter package has useful examples but no committed project-specific model contract, no reusable Pey-Man MATLAB package folder, no deterministic demo mode, and no verification note.

## Next Move

Implement a deterministic baseline under `source/pey_man/` before adding any advanced ML, App Designer, or real-time streaming feature.

## Rubric Map

| Rubric item | Pey-Man deliverable |
| --- | --- |
| Creativity | Workout quality and fatigue story, not a plain step counter |
| MATLAB mastery | Timetable handling, windowing, feature extraction, plotting |
| Functionality | Demo mode runs from clean checkout |
| Readability | Small named MATLAB helper files |
| Data visualization | Acceleration plot and workout summary plot |
| Model making | Raw sensor data to window features to score |
| Advanced model making | Deferred optional lane after baseline verification |
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
- `activeMinutes`
- `distanceKm` or `NaN`
- `activityMix`
- at least two labeled plots

## Algorithm

1. Load acceleration and optional position data.
2. Compute acceleration magnitude.
3. Remove gravity or baseline drift with moving mean or moving median.
4. Segment into 2-4 second sliding windows with 50% overlap.
5. Extract per-window features.
6. Classify windows with deterministic thresholds.
7. Compute fatigue from sustained load and late-session dropoff.
8. Compute workout quality from duration, intensity, consistency, and fatigue penalty.
9. Render plots and a judge-readable summary.

## Files To Create

- `source/pey_man/PeyManDemo.mlx`
- `source/pey_man/runPeyManPipeline.m`
- `source/pey_man/loadSessionData.m`
- `source/pey_man/buildWindowFeatures.m`
- `source/pey_man/classifyActivityRuleBased.m`
- `source/pey_man/computeFatigueIndex.m`
- `source/pey_man/computeWorkoutQualityScore.m`
- `source/pey_man/plotWorkoutSummary.m`
- `source/pey_man/haversineDistance.m`

## Verification Gates

- Clean MATLAB Online run from repository checkout.
- `demoMode=true` runs with bundled data.
- Missing GPS does not crash the workflow.
- Scores stay within `[0, 100]`.
- At least one acceleration plot and one summary plot render with labels.
- Malformed required input fails loudly.
- Baseline does not require Classification Learner or Deep Learning Toolbox.
- Future ML lane can be removed without breaking baseline.
- `demoMode` is discoverable without code edits.

## Skill Pattern Gates

- `mle-workflow`: data contract before code, baseline before ML.
- `ui-demo`: demo flow is discover, rehearse, record.
- `skill-scout`: inspect existing starter files before creating helpers.
- `workspace-surface-audit`: document current surface, primitive gap, next move.
- `mle-reviewer`: reject hidden thresholds and unverifiable score claims.

## Council Status

Council evidence is actionable. Kimi was initially broken because YSIS council routed the alias `kimi-k2.5` through the duplicate `ysis.agents.platforms` path without alias normalization. This was fixed in YSIS commits `0e5e243b` and `38e92478`. Final council run `council-b10d97abb7` produced Kimi, Codex, and Claude agreement. Gemini remained invalid in the council path and is not treated as approval evidence.
