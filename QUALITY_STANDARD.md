# Quality Standard

## Rubric Targets

Model work is 70 points:

- creativity: workout quality and fatigue story, not only steps,
- difficulty/MATLAB mastery: timetables, windowing, features, classifier, plots,
- functionality: clean run from checkout,
- readability: small named functions,
- visualization: annotated hero plot and dashboard,
- model making: sensor data to viable model implementation,
- advanced model making: ML activity classifier with fallback.

Presentation is 30 points:

- creativity: Pac-Man product hook,
- quality: polished visuals and no setup mess,
- concept: why the tracker output matters,
- clarity: English story under 5 minutes.

## Definition of Done

Every accepted feature must include:

- repo-relative MATLAB entrypoint or function,
- documented input/output shape,
- bounded failure behavior,
- no Python or non-MATLAB runtime in the submitted model, UI, or data-processing path,
- no local absolute paths in source,
- `VERIFY.md` evidence or a checklist entry,
- commit pushed to `origin/main`.

## Demo Quality Bar

The demo must show:

1. raw sensor input briefly,
2. ML activity labels,
3. Fatigue Index Timeline with annotation,
4. Workout Quality and Confidence scores,
5. steps, distance, cadence, calories,
6. one honest limitation,
7. final product hook: Pac-Man goals and personalized baseline.

## Collaboration Rules

- Keep commits small and pushed.
- Pull/rebase before pushing when remote moved.
- Do not force push shared `main`.
- Do not commit private raw phone logs unless the team explicitly agrees.
- App/UI polish cannot break `source/pey_man/main.m`.
- If a feature is not demo-ready by its deadline, move it to stretch and protect the working path.

## Hard Rejections

- Broken MATLAB entrypoint.
- Python-dependent model, UI, or data-processing feature.
- Hardcoded user path in source.
- ML model that cannot be trained or bypassed.
- Safety claim for fall detection.
- Unlabeled or confusing plot.
- Demo dependency on live phone sensors only.
