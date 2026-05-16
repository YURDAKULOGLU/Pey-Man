# Devpost Submission — Pey-Man

Paste each section directly into the matching Devpost field.

---

## Tagline (one line, <140 chars)

Turn your workout into a Pac-Man game. MATLAB-only arcade fitness UI driven by phone-sensor ML.

---

## Inspiration (~250 words)

Fitness apps look the same. A blue line, a step count, a heart-rate dot. They tell you *what* happened, never *why* you got tired. We wanted to flip that — to make a workout feel like an arcade run where you can watch yourself get chased.

Pac-Man was the obvious metaphor. It's recognizable, it implies tempo and pursuit, and it gives us two characters — Pac-Man as the user, ghosts as the inactivity you're trying to outrun. The fitness story practically writes itself: every active minute moves Pac-Man, every dead minute lets the ghost close in.

We also wanted to use MATLAB in a way most teams wouldn't. Most hackathon projects treat MATLAB like a notebook — a place to plot and prototype. We took it the other direction: build the whole user experience inside MATLAB itself, using `uifigure`, custom-rendered pixel art, and nothing else. No JavaScript, no images, no external front-end. If you have MATLAB Online open in your browser, you can run the entire demo from a single deeplink.

The data layer follows the same discipline. We use the MathWorks fitness-tracker starter as a baseline, add bagged-trees activity classification with a held-out validation split, derive a Fatigue Index from rolling sensor load, and surface it all through a JSON contract that the UI consumes without caring how it was built. The result is an arcade game and a real fitness ML pipeline sharing one repo.

---

## What it does (~250 words)

Pey-Man takes a MATLAB Mobile recording — accelerometer and GPS — and turns it into a five-panel arcade dashboard.

**Activity classification.** A bagged-trees ensemble (sixty learners, `fitcensemble`) labels every two-second window as sitting, walking, or running. We use a twenty-percent holdout split so the accuracy you see is the real held-out score, not resubstitution. On the starter logs we hit 92.9% validation accuracy. If the Statistics Toolbox is absent, we fall back to `fitctree`, then to a toolbox-free nearest-centroid classifier — the demo always runs.

**Fatigue Index.** A rolling activity-load metric that captures *when* the session breaks. We label the peak minute so the judge sees the story: "walking peaked at 4:00, running spike at 7:30."

**Workout Quality + Confidence.** Composite scores that combine fatigue, cadence, active minutes, and GPS regularity. Confidence Index tells you how much to trust the numbers based on sensor regularity and session length.

**Pac-Man arcade UI.** A pure MATLAB `uifigure` with hand-coded pixel sprites for Pac-Man and the ghosts. Neon yellow on black, Courier New for everything, no images, no JS. Each metric is a panel; the JSON contract decouples the UI from the model so either side can iterate.

**MATLAB Online ready.** One deeplink and you're running. No cloning, no toolbox dance — the fallback ladder makes it portable.

---

## How we built it (~150 words)

The pipeline is MATLAB end to end. Sensor data lands as timetables, we resample to a fixed grid, and slice into windows with overlap. From each window we extract eight features (mean, std, RMS, peak count, active ratio, dominant Hz, spectral power, speed). Those features feed `fitcensemble` with `Method=Bag, NumLearningCycles=60`. We use `cvpartition` for a 20% holdout split and print the validation accuracy at runtime.

The Fatigue Index, calorie estimate, cadence, and confidence index are all formula-based on the same window features. Everything writes to `outputs/<session>/latest_metrics.json`, and the UI reads only that contract. The Pac-Man UI is `uifigure` + `uigridlayout` with custom-drawn pixel sprites in Courier New, on a Pac-Man neon palette.

Repo hygiene is enforced by a GitHub Actions check. Bundled samples ship under `outputs/sample_demo/` for instant demo.

---

## Challenges we ran into (~100 words)

The hardest part was making the demo bulletproof. MATLAB Mobile recordings vary in length, sample rate regularity, and whether GPS was reliable. We added a fallback ladder for the classifier (ensemble → tree → centroid → rule) and a NaN-sanitizing layer in the exporter that converts every missing value to a documented fallback with a `_source` string so the UI never has to special-case empties. We also hit a syntax bug where local functions were placed mid-body in the exporter — caught it because we kept the pipeline runnable on every commit.

---

## What we learned (~100 words)

Hackathon time pressure rewards two disciplines: a hard contract between layers, and a fallback for every dependency. Once the UI consumed only `latest_metrics.json`, the model team and the UI team could ship in parallel without breaking each other. Once the classifier had a four-step fallback ladder, the demo could run on any MATLAB install — judge laptop, MATLAB Online, even a stripped install without the Stats Toolbox. The Pac-Man metaphor wasn't an aesthetic choice in the end; it forced us to think about *story* over chart density.

---

## What's next for Pey-Man (~100 words)

Three directions: (1) real-time mode — stream MATLAB Mobile sensor data live so the Pac-Man chase plays back as you exercise, with ghosts catching up if you slow down. (2) Multi-user — push session metrics to a shared leaderboard so teams can race. (3) Strava/Fitbit ingestion — we prototyped a Strava-trained personalized pace model under `source/pey_man/trainStravaWorkoutModel.m`; next step is wiring it to per-user pacing recommendations in the UI. The fallback ladder + JSON contract pattern carries over cleanly.

---

## Built With

MATLAB, MATLAB Mobile, MATLAB Online, Statistics & Machine Learning Toolbox, Bagged Trees (`fitcensemble`), `uifigure`, GitHub Actions.

---

## Try it out

- Repo: https://github.com/YURDAKULOGLU/Pey-Man
- MATLAB Online deeplink: https://matlab.mathworks.com/open/github/v1?repo=YURDAKULOGLU/Pey-Man&file=source/pey_man/main.m
- Demo video: (paste URL after #9 + #12 produce it)
