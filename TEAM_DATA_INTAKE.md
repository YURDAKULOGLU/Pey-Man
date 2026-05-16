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

All submitted project data-processing paths must be MATLAB-only. Do not add Python importers, notebooks, or Python preprocessing steps to the demo path.

If live data is delayed, run:

```matlab
source/pey_man/runSyntheticFatigueDemo
```

For a real file, run:

```matlab
cd source/pey_man
runPeyManFile("../../local_data/fatigue_demo.mat")
```

## Public WISDM Fallback

If team phone recordings are delayed, use the public WISDM HAR dataset as a local fallback for activity-recognition validation. Download and inspect it with MATLAB:

```matlab
cd source/pey_man
downloadWisdmDataset
inspectWisdmDataset
```

The files are written under ignored `local_data/wisdm_hf/`, not committed to git.

WISDM source activities:

- Walking
- Jogging
- Stairs
- Sitting
- Standing
- Lying Down

Project mapping idea:

- `Sitting` -> `sit`
- `Walking` -> `walk`
- `Jogging` -> `run`
- `Stairs` -> `walk` or future `stairs`
- `Standing` / `Lying Down` -> `rest`

Before using WISDM labels for final training evidence, confirm the numeric label order from the upstream source.
