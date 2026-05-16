# IRL Test Runbook

## Goal

Get Pey-Man ready for real phone-sensor testing without committing private raw data.

## Before Recording

1. Open MATLAB Mobile.
2. Connect to MathWorks Cloud.
3. Go to `Sensors`.
4. Switch from `Stream to MATLAB` to `Log`.
5. Enable:
   - Acceleration: required,
   - GPS Position / Speed: optional,
   - Orientation / Angular Velocity: optional stretch.
6. If available, enable background logging.

The competition instructions warn that MATLAB Mobile and MATLAB Online may not stay signed in at the same time. Record first, then test in MATLAB Online.

## Recording Plan

Record these sessions:

| File | Duration | Activity |
| --- | --- | --- |
| `sit.mat` | 2-5 min | seated/still baseline |
| `walk.mat` | 2-5 min | steady walking |
| `run.mat` | 2-5 min | safe jogging/running |
| `fatigue_demo.mat` | 8-12 min | fresh movement -> short rest -> tired movement |

## Local File Placement

Place downloaded `.mat` files here:

```text
local_data/
```

Do not commit `local_data/`. It is intentionally gitignored.

## Run In MATLAB

From repository root:

```matlab
cd source/pey_man
runLocalDataSession
```

Or choose a specific file:

```matlab
runPeyManFile("../../local_data/fatigue_demo.mat")
```

If no local data is present, `runLocalDataSession` falls back to `runSyntheticFatigueDemo`.

## Evidence To Capture

For each IRL run, record:

- file name,
- who recorded it,
- activity description,
- phone placement,
- sensor set,
- output folder,
- score summary,
- any error or strange plot.

Use aggregate metrics and screenshots in the repo. Commit raw GPS/person data only if the team explicitly approves.

