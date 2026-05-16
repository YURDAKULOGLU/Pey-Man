# Demo Runbook

## Goal

Show that Pey-Man turns phone sensor data into a clear workout quality story.

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

## Rehearsal Checklist

- [ ] Clean checkout opens in MATLAB Online.
- [ ] `main.m` runs from top to bottom.
- [ ] Demo mode does not require private phone data or live sensors.
- [ ] Plots have titles, labels, and readable legends.
- [ ] Activity classifier reports sit/walk/run or uses visible fallback.
- [ ] Scores stay between 0 and 100.
- [ ] Demo is under 5 minutes.
