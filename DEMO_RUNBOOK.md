# Demo Runbook

## Goal

Show that Pey-Man turns phone sensor data into a clear workout quality story.

## Demo Flow

1. Open the repository in MATLAB Online.
2. Open `source/pey_man/PeyManDemo.mlx`.
3. Set `demoMode=true`.
4. Run the live script.
5. Show raw acceleration data.
6. Show the windowed activity timeline.
7. Show Fatigue Index and Workout Quality Score.
8. Explain the recommendation.
9. Mention GPS only as an optional enrichment if it is stable.

## Demo Narrative

Pey-Man is not just counting steps. It looks at how movement changes during a workout and turns that into a fatigue and workout quality summary.

In this demo, bundled phone sensor data is loaded, split into short windows, and scored. The output shows where the session was steady, where movement became less consistent, and how that affects the final score.

The baseline is deterministic and MATLAB Online-safe. Machine learning is a future enhancement, not a dependency for the first working submission.

## Rehearsal Checklist

- [ ] Clean checkout opens in MATLAB Online.
- [ ] `PeyManDemo.mlx` runs from top to bottom.
- [ ] Demo mode does not require private phone data or live sensors.
- [ ] Plots have titles, labels, and readable legends.
- [ ] Scores stay between 0 and 100.
- [ ] Demo is under 5 minutes.
