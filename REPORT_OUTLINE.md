# Report And Presentation Outline

This outline follows the hackathon PDFs: create a fitness tracker from phone sensor data, present the model and results in English, and keep the demo under 5 minutes.

## 1. Problem

Fitness trackers turn raw sensor data into useful workout feedback. Pey-Man focuses on workout quality: not just how many steps, but whether the session stayed consistent and where fatigue appeared.

## 2. Data

- MATLAB Mobile acceleration: `X`, `Y`, `Z`.
- Optional GPS: latitude, longitude, speed.
- Starter activity logs: sit, walk, run.
- Team data: sit/walk/run/fatigue sessions when available.

## 3. Method

1. Compute acceleration magnitude.
2. Remove baseline/gravity drift.
3. Split signal into 4 second overlapping windows.
4. Extract movement features.
5. Classify activity as sit/walk/run.
6. Compare late-session motion to personal baseline.
7. Compute fatigue, workout quality, confidence, steps, distance, cadence, and calories.

## 4. Model

ML component:

- supervised activity classifier trained on labeled starter activity logs,
- deterministic fallback when the ML toolbox is unavailable.

Explainable component:

- Fatigue Index from load, consistency drop, cadence drop, and late-session weight,
- Workout Quality from duration, intensity, consistency, confidence, and fatigue penalty.

## 5. Results To Show

- Fatigue Index Timeline with green/yellow/red bands.
- Activity Breakdown pie chart.
- Quality, Fatigue, and Confidence scores.
- Steps, distance, cadence, and estimated calories.
- English session summary.

## 6. Product Hook

Pey-Man turns goals into a Pac-Man inspired loop:

- goal pellets represent daily targets,
- completed goals move Pey-Man forward,
- missed goals increase danger,
- personalized baseline makes the feedback fit the user.

## 7. Limitations

- Step count is estimated from cadence and windows.
- Calories are estimated from MET tables.
- GPS can be unavailable indoors.
- Fall detection is a future sensor demo, not a safety product claim.
- The first version uses a compact classifier, not deep learning.

## 8. Future Work

- MATLAB Online polished Live Script.
- Team-recorded fatigue dataset.
- UI connected directly to computed metrics.
- Pac-Man goal progression over days.
- Optional fall event candidate and inactivity alert.

## 5-Minute Demo Script

1. Problem: raw phone data is hard to interpret.
2. Data: acceleration and GPS from MATLAB Mobile.
3. Method: windows, features, ML labels, fatigue formula.
4. Result: show hero plot and dashboard.
5. Product: show Pey-Man pixel UI.
6. Limitation: estimates and GPS caveats.
7. Close: personalized workout quality tracker built fully in MATLAB.

