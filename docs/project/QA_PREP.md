# Q&A Prep — Judges' Likely Questions

Read once before the demo. Solo presenter: YURDAKULOGLU.

---

## Model / Technical

**Q: Why bagged trees instead of a neural network?**
> Activity classification on 2-second windows of 8 features doesn't need a NN. Bagged trees give us interpretable splits, fast training, and they ship with the Statistics & ML Toolbox so no extra dependency. We hit 92.86% on held-out windows — that's plenty for the demo, and we have a clear upgrade path if we wanted to extend.

**Q: Is 92.86% overfit?**
> No. We use `cvpartition` with a 20% holdout, train on the remaining 80%, and the printed number is the held-out score. Resubstitution would have been 97.4%; the gap of 4 points is healthy. The same 92.86% reproduces across three independent sessions, so the model is stable.

**Q: What if the Statistics Toolbox isn't installed?**
> We have a four-step fallback ladder: `fitcensemble` → `fitctree` → toolbox-free nearest-centroid → rule-based. The centroid classifier also runs the same 20% holdout and prints its own validation accuracy. Demo runs on any MATLAB install.

**Q: How do you handle noisy sensor data?**
> Three layers: resample to a fixed grid before windowing, compute robust features (RMS, peak count, spectral power), and a NaN-sanitizer in the exporter that converts every missing value to a documented fallback with a `_source` string. UI never crashes on missing data — shows "n/a" pill.

**Q: What's the Fatigue Index?**
> A rolling activity-load metric over time, normalized 0-100. We track when the session breaks — labels show "peaked at minute 4, running spike at 7". It's formula-based on the same window features, intentionally explainable rather than black-box.

---

## Product / Design

**Q: Why Pac-Man?**
> Three reasons. One: recognition — judges and users get the metaphor in two seconds. Two: it implies tempo and pursuit, which maps to fitness intensity naturally. Three: it forced us to think in *story* terms instead of chart density. The ghost is your inactivity, Pac-Man is you, the pellets are your daily tasks.

**Q: What are the pellets between Pac-Man and the ghost?**
> Eight daily fitness tasks. Each one maps to a real metric threshold: 5K steps, 20 active minutes, 1 km distance, 100 calories, quality 50, sensor trust 60, cadence detected, model accuracy above 0.8. Completed tasks turn green with an asterisk. The counter at the top tracks N/8 and flips status text from "Daily Maze" to "Keep Going" to "Building Up" to "Nice Work" as you eat them.

**Q: Is the UI pure MATLAB?**
> 100%. Single `uifigure`, hand-coded pixel sprites for Pac-Man and the ghosts (no images, no SVG, no JS). The neon-arcade palette uses three colors. Everything you see is one MATLAB process — no external front-end, no asset bundle.

---

## Process / Submission

**Q: How is the project organized?**
> Public on GitHub, MIT licensed. Source under `source/pey_man/`. Docs split into `technical/`, `testing/`, `project/`, `presentation/`, `tr/`. Generated outputs land in `outputs/<session>/` and the UI consumes a JSON contract — `latest_metrics.json` — so model and UI iterate independently. Repo-hygiene CI gate runs on every push.

**Q: Can I run it right now?**
> Yes — one deeplink: `matlab.mathworks.com/open/github/v1?repo=YURDAKULOGLU/Pey-Man&file=source/pey_man/main.m`. Opens MATLAB Online in the browser with the entrypoint pre-loaded. Run `main` and the dashboard appears.

**Q: Who built what?**
> YURDAKULOGLU led model + backend pipeline + repo. Mertrenlab did UI design. azadbulut handled data collection + presentation.

---

## Pivot / Future

**Q: What would you do with another week?**
> Three directions: real-time mode — stream MATLAB Mobile sensor data live so the Pac-Man chase plays back as you exercise. Multi-user leaderboard — push session metrics to a shared scoreboard. Strava/Fitbit ingestion — we already prototyped a Strava-trained personalized pace model under `source/pey_man/trainStravaWorkoutModel.m`; next step is wiring it to per-user pacing in the UI.

**Q: Is the live stream demo working?**
> It's an opt-in path — `runPeyManLiveStream` connects to MATLAB Mobile via `mobiledev` and exports metrics to `outputs/live/`. We kept it as an option because the judged demo path should be the deterministic file-based one. The live mode is bonus evidence.

---

## Trap questions (be ready)

**Q: What's your biggest weakness?**
> The classifier currently treats all walking as one class. With more team-recorded data we'd split walk-fast vs walk-slow vs incline-walk for a real workout taxonomy.

**Q: Did you actually record real data?**
> Yes — MATLAB Mobile recordings ingested through `runLocalDataSession`. The bundled `outputs/example_file/` has the real session metrics. Raw `.mat` files stay local (gitignored) per the team's data-handling policy.

**Q: Will it scale?**
> The pipeline is window-based, so it's O(N) in samples. For a 5-minute session that's a few thousand windows — runs in seconds. Real-time mode uses the same pipeline incrementally over a sliding buffer. No scale problem visible at hackathon scope.
