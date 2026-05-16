# Pey-Man MATLAB Pixel UI Spec

## Non-Negotiables

- Entire app is MATLAB-only: UI, plotting, animation, sensor processing, ML, and optional API calls.
- No web frontend, game engine, external asset pack, or non-MATLAB runtime.
- Pac-Man is not a side animation. The whole product surface uses the arcade/pixel visual language.
- UI must consume exported model metrics. It must not invent its own fitness numbers.

## Product Concept

Pey-Man is a Pac-Man inspired fitness tracker. The user is represented by a yellow pixel character named Pey-Man. Fitness goals appear as maze pellets, power pellets, fruits, and level objectives. As the user moves, MATLAB processes phone sensor data and maps workout progress into the arcade scene.

The demo should make this clear:

1. phone sensor data comes in,
2. MATLAB extracts motion features,
3. ML labels activity as sit/walk/run,
4. fatigue and quality metrics are computed,
5. the Pac-Man UI turns those metrics into game progress.

## Visual System

Use:

- black or very dark navy background,
- neon blue maze walls,
- yellow Pey-Man character,
- red/pink/blue/orange ghost characters,
- white or pale yellow goal pellets,
- pixel-like labels using `Courier New`,
- score, streak, level, lives, and target panels,
- hard-edged panels and rectangles, not rounded modern cards.

Do not use:

- smooth gradient fitness-app styling,
- web CSS or external UI framework,
- imported image assets unless they are generated inside MATLAB,
- vague charts with no labels or units.

## Main Screen

The main screen is a MATLAB `uifigure` with an arcade game field and metric panels.

Required regions:

- Top arcade header: `PEY-MAN`, score, streak, level/progress.
- Center maze: Pey-Man, pellets, ghost danger, progress path.
- Right metrics panel: quality, fatigue, confidence, steps, distance, cadence, calories.
- Bottom status strip: English session summary or coach advice.

## Fitness-To-Game Mapping

| Fitness metric | Arcade representation |
| --- | --- |
| Steps | small maze pellets collected |
| Workout minutes | maze progress distance |
| Calories | fruit / bonus pickup |
| Confidence index | sensor trust meter |
| Fatigue index | ghost pressure / warning band |
| Streak | level chain / bonus multiplier |
| Recovery/water/sleep stretch metrics | power pellet or life restore |

## Modes

V1 must show Daily Maze Mode only.

V2+ modes:

- Streak Mode: missed goals move ghosts closer; completed days increase multiplier.
- Step Quest: steps drive maze progress.
- Calories Hunt: calories drive bonus fruit pickups.
- Recovery Mode: rest/water/sleep restore lives.
- Boss Chase: weekly goal review.

## Current Entrypoint

```matlab
runPeyManPixelApp
```

This opens a MATLAB-only pixel UI. The next integration step is to populate it from:

```text
outputs/<session>/latest_metrics.json
outputs/<session>/activity_mix.csv
outputs/<session>/fatigue_timeline.csv
```

## UI Integration Contract

The UI should read these fields first:

1. `workoutQualityScore`
2. `fatigueIndex`
3. `confidenceIndex`
4. `stepCount`
5. `distanceKm`
6. `cadenceSpm`
7. `estimatedCalories`
8. `activeMinutes`
9. `coachAdvice`

If a designer wants a new metric, add it to `UI_METRICS_CONTRACT.md` and `exportPeyManArtifacts.m` before showing it.

## Demo Standard

The UI demo is successful when a judge can understand the value in under 20 seconds:

- quality score answers "Was this a good workout?"
- fatigue timeline answers "When did tiredness appear?"
- confidence index answers "How much should I trust the sensor estimate?"
- maze progress answers "How close am I to today's goal?"

