# Roadmap

## V1 - Working Model Foundation

Status: implemented and pushed.

Goal: prove a clean MATLAB model path.

DoD:

- `source/pey_man/main.m` runs locally.
- Acceleration data loads.
- Activity windows are labeled by ML or fallback.
- Fatigue Index, Workout Quality, Confidence, steps, distance, cadence, and calories are computed.
- Hero fatigue plot and dashboard render.
- `VERIFY.md` records evidence.

## V2 - Team Data And Robust Metrics

Goal: make the model credible on team-collected data, not only starter data.

Required:

- collect `sit.mat`, `walk.mat`, `run.mat`, and one `fatigue_demo.mat`,
- keep private raw logs out of commits unless approved,
- add a synthetic fatigue demo generator if live collection is delayed,
- expose a real `.mat` file runner for IRL tests,
- export UI/demo metrics to ignored `outputs/`,
- calibrate confidence index against sample quality,
- document final formulas and weights,
- record ML training rows, label counts, and leakage limitations,
- run repeatability and fallback checks.

DoD:

- one team-recorded session runs through `main.m`,
- synthetic fallback exists,
- real `.mat` runner exists,
- UI metrics export exists,
- scores stay inside `[0, 100]`,
- rule fallback and ML path both pass,
- `VERIFY.md` includes team/synthetic evidence.

## V3 - Product Demo And UI Integration

Goal: make the project memorable for judges.

Required:

- connect pipeline metrics to the pixel UI,
- implement the full MATLAB Pac-Man visual concept from `source/pey_man/PEY_MAN_UI.md`,
- keep Pac-Man pellets as polish, not a replacement for model output,
- optionally show coach advice from `generateCoachAdvice.m` with deterministic fallback,
- add personalized daily goal constants,
- prepare English demo script and report outline,
- rehearse under 5 minutes.

DoD:

- `runPeyManPixelApp` opens without errors,
- UI can display computed model metrics or a documented demo fixture,
- demo script exists,
- report outline exists,
- screenshots/video plan ready.

## V4 - Submission Hardening

Goal: submit without last-minute fragility.

Required:

- MATLAB Online clean checkout run,
- CI hygiene green,
- repo share link ready,
- final Devpost/GitHub package reviewed,
- no private data or unrelated files,
- final limitation and future-work slide.

DoD:

- GitHub `main` is green and pushed,
- MATLAB Online verification is recorded,
- final demo video/slides/report are linked,
- team can run the demo from the README,
- submission link is ready before deadline.
