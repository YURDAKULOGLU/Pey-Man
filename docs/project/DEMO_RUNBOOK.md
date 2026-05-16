# Demo Runbook

## Goal

Show that Pey-Man turns phone sensor data into a clear workout quality story and a memorable Pac-Man style interface.

## Owner Split

- Presenter 1: problem, data, method, limitation, close.
- Presenter 2: UI walkthrough and product layer.
- Driver: shares screen, runs MATLAB Online, opens backup path if needed.

## Demo Script

1. `0:00 - 0:30` Problem and hook
   "Most fitness trackers show raw numbers. Pey-Man turns MATLAB Mobile sensor data into a workout quality story."
2. `0:30 - 1:10` Data
   Show that acceleration is the main input and GPS is optional enrichment.
3. `1:10 - 2:00` Method
   Explain the pipeline: magnitude, baseline removal, 4 second windows, features, sit/walk/run labels, fatigue and quality scoring.
4. `2:00 - 3:00` Results
   Show raw acceleration briefly, then activity breakdown, Fatigue Index timeline, Workout Quality, Confidence, steps, distance, cadence, and calories.
5. `3:00 - 3:45` Product
   Switch to the Pac-Man pixel UI and explain how the metrics appear in a game-style interface.
6. `3:45 - 4:20` Limitation
   State that calories are estimated, GPS may be unstable indoors, and the classifier is compact rather than deep learning.
7. `4:20 - 5:00` Close
   "Pey-Man is a MATLAB-only fitness tracker that combines interpretable scoring, activity classification, and a memorable interface."

## Mert UI Talk Track

Keep this section to about 45 seconds:

1. "This is the Pey-Man interface. It is built fully in MATLAB and keeps the whole product in a Pac-Man inspired pixel style."
2. "The UI is connected to real model outputs, not only theme graphics. We surface metrics such as detected sport, cadence, confidence, fatigue, and calories by activity."
3. "As workout quality improves, Pey-Man moves toward the goal. When fatigue rises or progress drops, the ghost pressure increases."
4. "This lets us present technical fitness outputs in a way that is faster to read and easier to remember during a short demo."

## MATLAB Steps

Preferred path:

```matlab
main
```

Backup path:

```matlab
runSyntheticFatigueDemo
```

If using a specific local file:

```matlab
runPeyManFile("../../local_data/fatigue_demo.mat")
```

## Rehearsal Checklist

- [ ] MATLAB Online opens the repo from a clean checkout.
- [ ] `main` runs without editing paths.
- [ ] Bundled data path is ready in case private phone data is not available.
- [ ] `runSyntheticFatigueDemo` is ready as backup.
- [ ] Raw acceleration is shown briefly, not for too long.
- [ ] Activity breakdown is visible.
- [ ] Fatigue timeline is visible.
- [ ] Workout Quality, Confidence, steps, distance, cadence, and calories are visible.
- [ ] Mert UI section stays under 45 seconds.
- [ ] Full demo stays under 5 minutes.

## Failure Handling

- If GPS is missing: say it is optional enrichment and continue with acceleration-based metrics.
- If ML fallback is active: say the rule-based fallback is intentional for demo reliability.
- If real phone data is delayed: use `runSyntheticFatigueDemo` and keep the story focused on the model outputs.
