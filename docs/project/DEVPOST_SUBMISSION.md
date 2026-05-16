# Devpost Submission Draft

## Inspiration

Most fitness dashboards are accurate but emotionally flat. They count steps, calories, distance, and minutes, yet they rarely make the user feel like they are progressing through something. Pey-Man started from a simple idea from our team: what if daily fitness goals looked like Pac-Man pellets in a maze, and missed goals felt like ghosts getting closer? We wanted the app to be playful without becoming fake. The game layer had to be driven by real phone sensor data, not manually typed progress.

That led us to build a MATLAB-only fitness tracker where accelerometer and optional GPS data become a workout story. The user is represented by Pey-Man, goals become pellets and fruit, fatigue becomes ghost pressure, and confidence becomes a visible sensor-trust score. Our goal was to make a judge understand the session in seconds: how good was the workout, when did fatigue appear, how much should we trust the estimate, and what happened in the activity mix?

## What It Does

Pey-Man loads MATLAB Mobile sensor data, processes acceleration into short movement windows, classifies activity as sit, walk, or run, and computes an explainable workout report. The core outputs are a Fatigue Index timeline, Workout Quality Score, Confidence Index, step count, distance, cadence, estimated calories, detected sport, and calories by activity.

The presentation layer is a pure MATLAB Pac-Man-style pixel UI. The UI reads the exported JSON and CSV artifacts from the model pipeline. Quality score moves Pey-Man through the maze, fatigue controls ghost pressure, confidence appears as sensor trust, calories become a fruit bonus, and the validation score is visible in the arcade header.

The project also includes a synthetic fallback and toolbox-free classifier fallback so the demo remains robust even if MATLAB Mobile sync or toolbox availability is imperfect.

## How We Built It

We used MATLAB R2025b, MATLAB Mobile-style `.mat` files, timetables, windowed signal processing, supervised activity classification, and MATLAB `uifigure` UI components. When Statistics and Machine Learning Toolbox is available, the classifier uses a bagged trees ensemble. When it is not, the pipeline falls back to a toolbox-free nearest-centroid classifier and still prints held-out validation accuracy.

The model exports stable artifacts under `outputs/<session>/`: `latest_metrics.json`, activity mix, calories by activity, window features, fatigue timeline, and figures. The UI consumes those artifacts instead of inventing display numbers.

## Challenges

The main challenge was keeping the demo both creative and trustworthy. A game UI can easily become decorative, so we made every arcade element map to a real metric. We also fixed overlapping-window duration inflation so active minutes, steps, calories, and activity mix do not overcount. Finally, we hardened missing-data fallbacks so short sessions or missing GPS do not crash the UI.

## Links And Assets

- Repository: https://github.com/YURDAKULOGLU/Pey-Man
- MATLAB Online deeplink: https://matlab.mathworks.com/open/github/v1?repo=YURDAKULOGLU/Pey-Man&file=source/pey_man/main.m
- Hero screenshot: `docs/screenshots/ui.png`
- Demo clip: `docs/screenshots/demo.mp4`
- Cover image: `docs/project/devpost_cover.png`

## Tags

MATLAB, MATLAB Mobile, Sensors, Machine Learning, Bagged Trees, Fitness, Data Visualization, Game UI
