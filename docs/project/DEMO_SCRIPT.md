# Pey-Man — 5-Minute Demo Script (Timed)

Read out loud at 150 wpm. Total: **5:00**. Cuts marked with `▶ [action]`.

---

## 0:00 – 0:30 · Hook & Concept (30s)

> "Hi judges, we're Pey-Man.
> Fitness apps show you charts. We show you a Pac-Man game.
>
> Pey-Man takes the accelerometer and GPS from your phone, classifies what
> you're doing, and tells the story as an arcade chase.
>
> The harder you push, the further Pac-Man runs. The more you slack, the
> closer the ghost gets."

▶ Splash screen visible on dashboard.

---

## 0:30 – 1:30 · Sensors & Recording (60s)

> "We use MATLAB Mobile to record on the phone. Two sensor streams:
> three-axis accelerometer at one hundred hertz, and GPS position with speed."

▶ Show phone screen / sample MATLAB Mobile recording for 5s.

> "Each session lands as a timetable, we resample to a fixed grid, and slice
> into two-second sliding windows with seventy-five percent overlap. From
> each window we pull eight features — mean, standard deviation, RMS,
> peak count, active ratio, dominant frequency, spectral power, and speed."

▶ Switch to MATLAB Online showing `extractFeatures.m` for 5s.

---

## 1:30 – 2:30 · Model (60s)

> "The classifier is a bagged trees ensemble, sixty learners, trained on the
> starter ActivityLogs and our own walk and run recordings."

▶ Show console with `Validation accuracy: 92.9% (held-out 14 rows)` line.

> "We use a twenty percent holdout split so the score you see is real, not
> resubstitution. We hit ninety-two point nine percent on the held-out windows."

▶ Highlight validationAccuracy pill on the UI.

> "If the Statistics Toolbox is missing, we drop to `fitctree`. If that's
> missing, we drop to a toolbox-free nearest-centroid classifier. The demo
> always runs — even on a fresh MATLAB install."

---

## 2:30 – 3:30 · Fatigue Index & Quality (60s)

> "Beyond classification, we compute a Fatigue Index — a rolling activity
> load metric that picks up the moment your running session breaks into a
> slog. Peak labeling tells the story: 'walking peaked at minute 4, running
> spike at 7.'"

▶ Pan across fatigue timeline; pointer follows the peak annotation.

> "Workout Quality Score combines fatigue, cadence, active minutes, and GPS
> coverage. Confidence Index tells the judge how trustworthy the numbers are
> based on sensor regularity and session length."

---

## 3:30 – 4:30 · Pac-Man UI Walkthrough (60s)

> "Now the part you came for. Everything you see is one MATLAB `uifigure`."

▶ Mertrenlab takes over here, pans through:

1. Activity Mix bars
2. Calories by Activity
3. Sport / Cadence pill
4. Confidence gauge
5. Fatigue timeline
6. Pac-Man + ghost character row

> "No images, no JavaScript, no external assets. Every pixel of the Pac-Man
> and the ghosts is rendered from a hand-coded byte matrix. The neon-arcade
> theme uses Courier New and three colors. We wanted judges to *feel* the
> arcade, not just see a chart."

---

## 4:30 – 5:00 · Close (30s)

> "Pey-Man is MIT licensed and public. The README has a one-line MATLAB
> Online deeplink, so you can run it from your browser without cloning.
> Validation accuracy ships in the JSON contract — `modelValidationAccuracy`
> next to `modelValidationAccuracy_source` so it's auditable.
>
> We're YURDAKULOGLU, Mertrenlab, and azadbulut. Pey-Man eats your steps.
> Don't let the ghost catch you. Thank you."

▶ Hold on final dashboard wide shot until applause.

---

## Time budget cheat-sheet

| Section | Window | Cumulative |
|---|---|---|
| Hook | 0:30 | 0:30 |
| Sensors | 1:00 | 1:30 |
| Model | 1:00 | 2:30 |
| Fatigue | 1:00 | 3:30 |
| UI (Mert) | 1:00 | 4:30 |
| Close | 0:30 | 5:00 |

**Slip rules**: if you're 15s behind by 2:30, cut sensor description; if behind by 3:30, hand off to Mert immediately and shorten UI tour.
