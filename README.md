# PEY-MAN

PEY-MAN packages the latest downloaded hackathon materials into a clean, shareable project workspace.

## What This Is

Project/repository name: `PEY-MAN`

Challenge: create a fitness tracker using MATLAB Online and MATLAB Mobile.

Goal: use phone sensor data to produce useful fitness outputs such as steps, calories, distance, activity class, workout quality, or similar metrics. Machine learning or deep learning can improve the score, but a working and well-presented model is the priority.

## Folder Map

- `source/matlab-mobile-fitness-tracker-master/` - extracted starter repository from the downloaded zip.
- `docs/` - downloaded PDF materials: welcome presentation, instructions, and grading rubric.
- `chat/` - ready-to-share context for a team chat or AI shared chat.
- `share/` - packaging metadata and submission helpers.

## Key Source Files

- `ExampleModel.mlx` - MATLAB Live Script example workflow.
- `ExampleData.mat` - example phone sensor data.
- `ActivityLogs.mat` - example activity log data.
- `timeElapsed.m` - helper function for elapsed time arrays.
- `runPeyManPixelApp.m` - launches the Pac-Man inspired pixel-art MATLAB UI.
- `source/pey_man/peyManPixelApp.m` - 100% MATLAB UI implementation with generated pixel characters.
- `source/pey_man/trainWorkoutModelDemo.m` - optional Strava/Fitbit workout-speed model training prototype.
- `Instructions.pdf` - setup and workflow guidance.
- `GradingRubric.pdf` - judging criteria.

## Pixel UI Demo

From the repository root in MATLAB:

```matlab
runPeyManPixelApp
```

The UI uses a Pac-Man inspired fitness loop: Pey-Man moves toward the goal pellets as daily fitness targets are completed, while the ghost moves closer when targets are missed.

UI design notes:

- `docs/UI_CONCEPT_TR.md` - Turkish product and visual concept for the MATLAB-only Pac-Man style UI.
- `docs/UI_FEATURES_TR.md` - Turkish feature ideas for model-connected UI modes and demo flow.

## MATLAB Online Test

Open the model entrypoint in MATLAB Online:

```text
https://matlab.mathworks.com/open/github/v1?repo=YURDAKULOGLU/Pey-Man&file=source/pey_man/main.m
```

The repository is private, so collaborators must have GitHub access. Full test instructions are in `TEST_PLAN.md`.

## Workout Model Training

Optional personalized running-plan training is documented in `WORKOUT_MODEL_TRAINING.md`. Kaggle data stays local under ignored `data/`, and trained models stay under ignored `models/`. The core hackathon demo does not depend on these files.

## IRL Data Test

Put local MATLAB Mobile `.mat` files under ignored `local_data/`, then run:

```matlab
cd source/pey_man
runLocalDataSession
```

Full real-world recording and privacy rules are in `IRL_TEST_RUNBOOK.md`.

## Judging Summary

Model work is worth 70 points:

- Creativity: 10
- Difficulty and MATLAB mastery: 10
- Functionality: 10
- Readability: 10
- Data visualization: 10
- Model making: 10
- Advanced model making with ML or deep learning: 10

Presentation/demo is worth 30 points:

- Creativity: 10
- Quality: 10
- Concept: 5
- Clarity: 5

## Recommended Team Workflow

1. Agree on the tracker output: steps, calories, distance, activity classification, workout quality, or another measurable result.
2. Collect phone sensor data with MATLAB Mobile.
3. Start from `ExampleModel.mlx` and keep a working baseline.
4. Add one stronger idea: activity classification, peak detection, model comparison, or better visualization.
5. Prepare a short English demo under 5 minutes.
6. Submit through Devpost with a public project link.

## Share Notes

This package avoids machine-specific absolute paths in the project notes. If sharing publicly, review the data files and PDFs first and remove anything you do not want included.
