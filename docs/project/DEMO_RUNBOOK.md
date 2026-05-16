# Demo Runbook

## Goal

Show that Pey-Man turns phone sensor data into a clear workout quality story.

## Five-Minute Demo Flow

| Time | Owner | Screen | Talk Track |
| --- | --- | --- | --- |
| 0:00-0:30 | Presenter | README hero screenshot | "Pey-Man turns a workout into a Pac-Man game. The point is not only step counting; it converts phone sensor motion into quality, fatigue, confidence, and game progress." |
| 0:30-1:20 | Data | MATLAB Mobile / repo files | "We record acceleration and optional GPS from MATLAB Mobile. The demo can run on bundled sample data, synthetic fallback, or team-recorded local `.mat` files." |
| 1:20-2:10 | Model | `main.m` console + raw sensor figure | "MATLAB loads timetables, windows the signal, extracts motion features, then classifies sit/walk/run. If Statistics Toolbox is available we use bagged trees; otherwise a toolbox-free centroid fallback still prints validation accuracy." |
| 2:10-3:00 | Model | Fatigue Index timeline | "The hero signal is Fatigue Index. Green/yellow/red threshold bands are fixed. The annotation marks the session peak without overclaiming low fatigue." |
| 3:00-4:15 | UI | `runPeyManPixelApp` | "The pixel UI consumes the exported JSON and CSV. Quality drives maze progress, fatigue drives ghost pressure, confidence is sensor trust, calories become the fruit bonus, and validation accuracy is visible in the header." |
| 4:15-4:45 | Results | Activity/calorie panel + summary | "This session is a walking session: 624 steps, 0.66 km, 26 kcal, 58.9 quality, 91.4% confidence, 92.9% local validation fallback accuracy." |
| 4:45-5:00 | Closing | GitHub / team slide | "Everything is MATLAB-only: processing, ML, plots, and UI. The repo is MIT licensed and ready for MATLAB Online review." |

Hard stop at 4:45. If anything slips, skip the optional GPS sentence and go straight to the UI.

## Commands

From repository root:

```matlab
cd source/pey_man
main
cd ../..
runPeyManPixelApp("outputs/example_file")
```

If MATLAB Mobile data or sync is delayed:

```matlab
cd source/pey_man
runSyntheticFatigueDemo
cd ../..
runPeyManPixelApp("outputs/synthetic")
```

## Demo Narrative

Pey-Man is not just counting steps. It looks at how movement changes during a workout and turns that into a fatigue and workout quality summary.

In this demo, bundled phone sensor data is loaded, split into short windows, classified as sit/walk/run, and scored. The output shows where the session was steady, where movement became less consistent, and how that affects the final score.

The baseline is MATLAB Online-safe. Machine learning is used for activity classification when available, while fatigue and quality remain explainable formulas.

## Screenshot / Recording Assets

- Hero screenshot: `docs/screenshots/ui.png`
- Real-session closeup: `docs/screenshots/ui_real_session.png`
- 30-second visual demo clip: `docs/screenshots/demo.mp4`

## Rehearsal Checklist

- [ ] Clean checkout opens in MATLAB Online.
- [ ] `main.m` runs from top to bottom.
- [ ] Console prints `Validation accuracy: XX.X%`.
- [ ] Demo mode does not require private phone data or live sensors.
- [ ] Plots have titles, labels, and readable legends.
- [ ] Activity classifier reports sit/walk/run or uses visible fallback.
- [ ] Scores stay between 0 and 100.
- [ ] Pixel UI opens and no panel is empty / NaN / overflowing.
- [ ] Presenter reaches the UI by 3:00.
- [ ] Demo is under 5 minutes.

## Rehearsal Log

| Attempt | Date/time | Duration | Result | Notes |
| --- | --- | --- | --- | --- |
| Proxy | 2026-05-16 | Not timed live | Pending team rehearsal | Clean-clone local MATLAB run passed; real MATLAB Online and team voice timing still required. |
