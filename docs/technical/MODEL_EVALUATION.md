# Model Evaluation Standard

This project uses AgentLaboratory as inspiration for experiment discipline only. AgentLaboratory itself is not a runtime dependency.

## Current Model Shape

- ML component: supervised `sit / walk / run` classifier trained from `ActivityLogs.mat` using **bagged trees ensemble** (`fitcensemble`, `Method=Bag`, `NumLearningCycles=60`) with a **20% holdout validation split**.
- Deterministic component: fatigue, quality, steps, calories, cadence, and confidence formulas.
- Fallback ladder when Statistics & ML Toolbox is unavailable: `fitctree` → toolbox-free nearest-centroid classifier → rule-only classifier (last resort, training data missing).

Validation accuracy is printed at runtime by `trainActivityClassifier.m` and persisted to `outputs/<session>/latest_metrics.json` under both `validationAccuracy` / `validationRows` and `modelValidationAccuracy` / `modelValidationRows`.

Current local validation evidence on the bundled starter logs:

```text
Validation accuracy: 92.9% (centroid fallback held-out 14 rows)
```

When Statistics & ML Toolbox is available, the same entrypoint uses the bagged-trees path and prints the held-out ensemble validation accuracy instead.

## Why Hybrid

The hackathon rubric rewards advanced ML, but the demo must remain explainable. Activity classification is a good bounded ML target. Fatigue and quality are kept formula-based because judges can inspect the components and understand the story.

## Required Evaluation Evidence

Every model revision must record:

- source dataset and variables,
- number of training windows,
- label counts,
- training accuracy or fallback reason,
- whether test data is separate from training data,
- known leakage risk,
- graphs generated,
- exact MATLAB command.

## Leakage Rule

Do not claim generalization from resubstitution accuracy. The starter `ActivityLogs.mat` classifier can prove the pipeline works, but a stronger claim needs team-recorded sessions with a session-level split.

Minimum credible split for team data:

- collect separate `sit`, `walk`, `run`, and `fatigue_demo` files,
- train on labeled activity files,
- test on the separate fatigue demo,
- report confusion matrix or at least activity mix sanity.

## Graph Sanity Gates

Generated figures must pass these checks:

- raw acceleration is shown at least once,
- activity labels are visible somewhere,
- fatigue threshold bands are fixed and not data-dependent,
- annotation text does not overclaim low fatigue as elevated,
- dashboard metrics match `latest_metrics.json`,
- active minutes, steps, calories, and activity mix use non-overlapping represented window duration.

## Competition Scoring Map

| Rubric area | Evidence |
| --- | --- |
| Creativity | Pac-Man product concept + fatigue story |
| MATLAB mastery | timetables, windows, features, ML, `uifigure`, plotting |
| Functionality | `main`, synthetic fallback, file runner, pixel app |
| Readability | one-purpose `.m` files |
| Visualization | raw sensor overview, fatigue timeline, dashboard, pixel UI |
| Model making | sensor data -> windows -> labels -> scores |
| Advanced ML | `fitcensemble` bagged trees (60 learners) + 20% holdout validation accuracy printed at runtime; degrades to `fitctree` then centroid when toolbox absent |
| Presentation | 5-minute English demo script and report outline |
