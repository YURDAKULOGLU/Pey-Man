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

Live-stream note:

- MATLAB Mobile also supports **Stream to MATLAB** through `mobiledev`.
- Use that mode only for live rehearsal or operator testing.
- Do not make the judged demo depend on a live phone connection.

## Recording Plan

Record these sessions for issue #10:

| File | Duration | Activity |
| --- | --- | --- |
| `sit_session.mat` | at least 60 sec | phone in pocket, seated/still baseline |
| `walk_session.mat` | at least 60 sec | natural walking, phone in pocket |
| `run_session.mat` | at least 60 sec | safe light jog/run, phone strapped or pocketed firmly |
| `fatigue_demo.mat` | about 3 min | sit -> walk -> run -> sit demo transitions |

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
The runner checks the issue #10 filenames first, then the older `walk.mat`,
`run.mat`, and `sit.mat` names for compatibility.

## Optional Live Stream In MATLAB Online

From repository root:

```matlab
runPeyManLiveStream
```

Prerequisites:

- MATLAB Mobile and MATLAB Online use the same MathWorks account.
- In MATLAB Mobile, open `Sensors`.
- Set `Stream to` -> `MATLAB`.
- Keep Acceleration enabled; Position is optional.

Stop / cleanup:

- Close the live UI window, or
- press Ctrl+C in MATLAB Online.

The live command stops `mobiledev.Logging` on shutdown.

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

Privacy note for live mode:

- The stream still comes from personal device sensors.
- Treat it like local private data even if temporary JSON and CSV are written under `outputs/live/`.
