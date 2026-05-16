# Workout Model Training

This branch adds a MATLAB training prototype for personalized running plans.

## Data

Kaggle data is not committed to the repository. Download it locally from the repository root:

```powershell
kaggle datasets download -d olegoaer/running-races-strava -p data\strava --unzip
kaggle datasets download -d nnekaekwemuka/fitbit-fitness-tracker-dataset -p data\fitbit --unzip
```

Expected files:

- `data/strava/raw-data-kaggle.csv`
- `data/fitbit/dailyActivity_merged.csv`

## Model Choice

The first training model is a bagged regression tree ensemble:

```matlab
fitrensemble(..., "Method", "Bag")
```

It predicts the next run's average speed from previous Strava runs. This is a good first model because the data is tabular, the features are interpretable, and MATLAB can train it directly with Statistics and Machine Learning Toolbox.

Fitbit data is prepared separately as a daily activity/readiness signal. It is not merged with Strava rows because the datasets do not represent the same users.

## Run

From the repository root:

```matlab
addpath("source/pey_man")
trainWorkoutModelDemo
```

The demo trains the model, prints MAE/RMSE/R-squared, predicts an example next-run speed, and generates a treadmill-style workout plan.
