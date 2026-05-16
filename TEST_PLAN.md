# Test Plan

## What The Competition Requires

The competition files say the tracker must:

- use phone sensor data from MATLAB Mobile,
- turn raw data into useful fitness results,
- preferably include machine learning or deep learning,
- present the result in English,
- submit through Devpost by 15:00,
- provide a public or shareable project link,
- include a brief demo under 5 minutes.

The grading rubric is:

- 70 points model work,
- 30 points presentation/demo.

## Test Surfaces

| Surface | Purpose | Owner |
| --- | --- | --- |
| GitHub Actions | Catch repo hygiene issues before teammates pull broken files. | Programmer |
| Local MATLAB | Fast model validation when MATLAB starts cleanly. | Programmer |
| MATLAB Online | Final competition runtime proof. | Programmer + team |
| MATLAB Mobile | Real phone sensor data collection. | Athlete |
| Demo rehearsal | English presentation under 5 minutes. | Marketing + all |

## GitHub / CI Test

Run locally:

```powershell
python tools/check_repo_hygiene.py
git status --short --branch
```

Expected:

```text
HYGIENE_OK
```

GitHub Actions should show `repo-hygiene` as green on `main`.

## MATLAB Online Test

Preferred link:

```text
https://matlab.mathworks.com/open/github/v1?repo=YURDAKULOGLU/Pey-Man&file=source/pey_man/main.m
```

Because the repository is private, collaborators may need GitHub authentication or a personal access token. Alternative path:

1. Open `https://matlab.mathworks.com/`.
2. Use `Home -> New -> Git Clone`, or right-click the Files panel and choose `Source Control -> Clone Git Repository`.
3. Clone:

```text
https://github.com/YURDAKULOGLU/Pey-Man.git
```

4. Set current folder to:

```text
Pey-Man/source/pey_man
```

5. Run:

```matlab
main
```

Expected:

- two figures appear,
- terminal prints session summary,
- `FatigueIndex`, `WorkoutQualityScore`, `ConfidenceIndex`, `StepCount`, `DistanceKm`, `CadenceSpm`, and `EstimatedCalories` are present,
- no error.

## Synthetic Fallback Test

Use this if MATLAB Mobile data is delayed:

```matlab
runSyntheticFatigueDemo
```

Expected:

- synthetic fresh -> rest -> tired session runs,
- same dashboard path works,
- no private phone data is needed.

## IRL Local Data Test

After placing `.mat` files under ignored `local_data/`:

```matlab
runLocalDataSession
```

Or run a specific file:

```matlab
runPeyManFile("../../local_data/fatigue_demo.mat")
```

Expected:

- the session runs through the same model pipeline,
- output artifacts are written under `outputs/<session-name>/`,
- no raw private `.mat` file is committed.

## Rule Fallback Test

This verifies that the demo does not depend on ML toolbox availability:

```matlab
opts = struct();
opts.demoMode = true;
opts.useML = false;
opts.baselineSeconds = 60;
opts.windowSeconds = 4;
opts.windowOverlap = 0.75;
opts.bodyMassKg = 70;
opts.strideLengthM = 0.72;
opts.dataFile = fullfile(pwd, "..", "matlab-mobile-fitness-tracker-master", "ExampleData.mat");
opts.activityLogFile = "";
r = runPeyManPipeline(opts);
assert(r.model.type == "rule")
assert(r.summary.FatigueIndex >= 0 && r.summary.FatigueIndex <= 100)
assert(r.summary.WorkoutQualityScore >= 0 && r.summary.WorkoutQualityScore <= 100)
```

## Pixel UI Test

From repository root:

```matlab
runPeyManPixelApp
```

Expected:

- MATLAB UI opens,
- Pac-Man inspired scene renders,
- no external image asset is required.

## MATLAB Mobile Data Test

The competition instructions say MATLAB Mobile should be used in `Log` mode so data saves to MATLAB Drive.

Collect these sessions:

- `sit.mat`: 2-5 minutes,
- `walk.mat`: 2-5 minutes,
- `run.mat`: 2-5 minutes if safe,
- `fatigue_demo.mat`: fresh movement, short rest, tired movement.

Recommended enabled sensors:

- Acceleration: required,
- GPS Position / Speed: optional,
- Orientation / Angular Velocity: stretch.

Important note from the instructions: do not rely on being signed into MATLAB Mobile and MATLAB Online at the same time. Collect/log from Mobile, then test from Online.

Raw `.mat` files with personal/GPS data should stay local unless the team explicitly approves committing sanitized files.

## Final Acceptance Checklist

- [ ] GitHub Actions `repo-hygiene` green.
- [ ] MATLAB Online `main` run passes.
- [ ] Synthetic fallback run passes.
- [ ] Rule fallback run passes.
- [ ] Pixel UI opens.
- [ ] One team-recorded session runs or synthetic fallback is accepted.
- [ ] `VERIFY.md` is updated with exact commands and outputs.
- [ ] Demo script is under 5 minutes.
- [ ] Submission link is public/shareable before Devpost submission.
