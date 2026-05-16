# Rubric Checklist

Source: `docs/GradingRubric.pdf` and `docs/Instructions.pdf`.

## Model Checklist

- [ ] Data loads in MATLAB Online.
- [ ] Workflow runs from a clean folder.
- [ ] Sensor variables are documented.
- [ ] Primary output metric is defined.
- [ ] Primary output metric is computed.
- [ ] Visualization has title, labels, and readable legend.
- [ ] Code is organized into clear sections or helper functions.
- [ ] Baseline uses starter data successfully.
- [ ] Team data path is documented.
- [ ] Advanced model attempt is isolated from baseline risk.

## Candidate Tracker Ideas

- Step counter from GPS path or acceleration peaks.
- Distance and pace from GPS latitude/longitude.
- Activity classification from acceleration data.
- Workout intensity score from acceleration magnitude and duration.
- Workout quality summary combining distance, activity, and intensity.

## Demo Checklist

- [ ] Demo is in English.
- [ ] Demo is under 5 minutes.
- [ ] Shows raw input briefly.
- [ ] Shows model output.
- [ ] Shows visualization.
- [ ] Explains one limitation honestly.
- [ ] Includes final submission link or package.

## Recommended MVP

Build a workout quality tracker:

1. Load sample and collected phone sensor data.
2. Compute acceleration magnitude over time.
3. Estimate movement intensity and duration.
4. Classify activity if the data supports it.
5. Present a simple score with clear plots.

This gives a stronger story than a plain step counter while staying achievable.
