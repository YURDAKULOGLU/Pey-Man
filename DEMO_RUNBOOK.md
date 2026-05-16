# Demo Runbook

## Goal

Show that Pey-Man turns phone sensor data into a clear workout quality story.

Canonical detailed script: `docs/project/DEMO_RUNBOOK.md`

## Demo Flow

1. Open the repository in MATLAB Online.
2. Open `source/pey_man/main.m`.
3. Set `demoMode=true`.
4. Run the script.
5. Show raw acceleration data.
6. Show the ML activity breakdown: sit/walk/run.
7. Show the annotated Fatigue Index timeline.
8. Show Workout Quality, Confidence, steps, distance, cadence, and calories.
9. Read the English session summary.
10. Mention GPS only as an optional enrichment if it is stable.

Backup path:

```matlab
source/pey_man/runSyntheticFatigueDemo
```

Use this if team phone data or MATLAB Mobile sync is delayed.

## Demo Narrative

Pey-Man is not just counting steps. It looks at how movement changes during a workout and turns that into a fatigue and workout quality summary.

In this demo, bundled phone sensor data is loaded, split into short windows, classified as sit/walk/run, and scored. The output shows where the session was steady, where movement became less consistent, and how that affects the final score.

The baseline is MATLAB Online-safe. Machine learning is used for activity classification when available, while fatigue and quality remain explainable formulas.

## Timed Walkthrough

1. `0:00 - 0:30` Problem and hook
   "Most fitness trackers show numbers. Pey-Man turns phone sensor data into a workout quality story and a Pac-Man style interface."
2. `0:30 - 1:10` Data source
   Show that the input is MATLAB Mobile acceleration, with optional GPS enrichment.
3. `1:10 - 2:00` Method
   Explain windowing, feature extraction, sit/walk/run classification, and the explainable fatigue formula.
4. `2:00 - 3:00` Model output
   Show raw acceleration, activity breakdown, Fatigue Index timeline, Workout Quality, Confidence, steps, distance, cadence, and calories.
5. `3:00 - 3:45` Product layer
   Open the Pac-Man inspired pixel UI and explain how model metrics drive the visual state.
6. `3:45 - 4:20` Limitation
   State that calories are estimated, GPS can be unstable indoors, and the first classifier is compact rather than deep learning.
7. `4:20 - 5:00` Close
   "This is a MATLAB-only fitness tracker that combines interpretable scoring, activity classification, and a game-style interface."

## UI Walkthrough For Mert

Mert should cover the product layer in about 45 seconds:

1. "This is the Pey-Man UI. It is built fully in MATLAB and keeps the whole experience in a Pac-Man pixel style."
2. "The screen is not only decorative. The panels come from computed model outputs such as detected sport, cadence, confidence, fatigue, and calorie breakdown."
3. "When the user performs better, Pey-Man advances toward the goal. When performance drops or fatigue rises, the ghost pressure increases."
4. "So the interface translates raw sensor metrics into a game-like progress system that is easier to read in a demo."

## Backup Ladder

1. Preferred path: run `main` in MATLAB Online.
2. If private phone data is unavailable: keep `demoMode=true` and use bundled starter data.
3. If sync or local data is delayed: run `runSyntheticFatigueDemo`.
4. If ML toolbox is unavailable: use the visible rule fallback path and say so directly.

## Rehearsal Checklist

- [ ] Clean checkout opens in MATLAB Online.
- [ ] `main.m` runs from top to bottom.
- [ ] Demo mode does not require private phone data or live sensors.
- [ ] Plots have titles, labels, and readable legends.
- [ ] Activity classifier reports sit/walk/run or uses visible fallback.
- [ ] Scores stay between 0 and 100.
- [ ] UI walkthrough stays under 45 seconds.
- [ ] One person handles transitions between MATLAB figures and the pixel UI.
- [ ] A backup run using `runSyntheticFatigueDemo` is ready.
- [ ] Demo is under 5 minutes.
