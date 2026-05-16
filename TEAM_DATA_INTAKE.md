# Team Data Intake

## Goal

Use team-collected MATLAB Mobile data without turning the repository into a private raw-data dump.

## Desired Sessions

- `sit.mat`: 2-5 minutes seated or still.
- `walk.mat`: 2-5 minutes steady walk.
- `run.mat`: 2-5 minutes jog/run if safe.
- `fatigue_demo.mat`: fresh movement, short rest, then tired movement.

## Privacy Rule

Do not commit raw personal phone logs unless the team explicitly approves. If a file contains GPS or personally identifying movement patterns, keep it local and only commit derived screenshots, aggregate metrics, or a sanitized sample.

## Local Folder Convention

Use a local ignored folder:

```text
local_data/
```

The CI hygiene gate rejects `.mat` files outside the starter data folder, so accidental raw data commits should fail.

## MATLAB Contract

Each `.mat` should contain a timetable named `Acceleration` or another timetable with `X`, `Y`, `Z`. Optional GPS can be named `Position`.

If live data is delayed, run:

```matlab
source/pey_man/runSyntheticFatigueDemo
```

