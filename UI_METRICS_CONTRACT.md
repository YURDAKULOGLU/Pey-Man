# UI Metrics Contract

UI design is owned by the designer. The model exports stable values for the UI to consume.

## Artifact Location

Running a real or local session writes:

```text
outputs/<session-name>/latest_metrics.json
outputs/<session-name>/activity_mix.csv
outputs/<session-name>/calories_by_activity.csv
outputs/<session-name>/window_features.csv
outputs/<session-name>/fatigue_timeline.csv
outputs/<session-name>/figure_*.png
```

`outputs/` is ignored by git.

## JSON Fields

```json
{
  "summaryText": "Solid session...",
  "fatigueIndex": 17.2,
  "workoutQualityScore": 76.2,
  "confidenceIndex": 91.2,
  "stepCount": 2478,
  "distanceKm": 0.658,
  "distanceSource": "gps",
  "estimatedCalories": 236.6,
  "detectedSport": "Running Session",
  "dominantActivity": "run",
  "dominantActivityMinutes": 12.4,
  "dominantActivityCalories": 164.2,
  "averageCaloriesPerMinute": 7.8,
  "activeCaloriesPerMinute": 9.6,
  "cadenceSpm": 104.8,
  "activeMinutes": 24.1,
  "peakFatigueMinute": 5.9,
  "peakFatigueLabel": "Fatigue Signal Elevated at 5:56"
}
```

## UI Priority

The UI should show, in this order:

1. Workout Quality Score.
2. Fatigue Index.
3. Confidence Index.
4. Activity breakdown.
5. Detected sport and calories by activity.
6. Steps, distance, cadence, calories.
7. Pac-Man goal pellets and streak polish.

## Guardrail

The UI must not invent metrics that the model does not export. If a new visual needs a new value, add it to this contract and the exporter first.
