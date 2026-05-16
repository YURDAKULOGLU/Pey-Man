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
  "workoutQualityScore": 58.9,
  "confidenceIndex": 91.4,
  "stepCount": 624,
  "distanceKm": 0.658,
  "distanceSource": "gps",
  "estimatedCalories": 26.0,
  "detectedSport": "Walking Session",
  "dominantActivity": "walk",
  "dominantActivityMinutes": 6.1,
  "dominantActivityCalories": 25.9,
  "averageCaloriesPerMinute": 4.3,
  "activeCaloriesPerMinute": 4.3,
  "cadenceSpm": 104.8,
  "activeMinutes": 6.1,
  "peakFatigueMinute": 5.9,
  "peakFatigueLabel": "Peak Fatigue Signal at 5:56",
  "currentActivity": "walk",
  "currentActivityConfidence": 92.1,
  "currentActivityWindowCount": 3,
  "sourceKind": "live_mobile_stream",
  "sourceName": "iPhone",
  "liveSampleCount": 742,
  "livePositionSampleCount": 81,
  "lastSampleSeconds": 118.4,
  "lastUpdatedAt": "2026-05-16T12:30:04Z",
  "coachAdvice": "Strong session...",
  "coachAdviceSource": "template_fallback",
  "modelType": "fitcensemble-bag",
  "modelTrainingRows": 147,
  "modelTrainingAccuracy": 0.99,
  "validationAccuracy": 0.94,
  "validationRows": 29,
  "modelValidationAccuracy": 0.94,
  "modelValidationRows": 29
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
8. Optional coach advice.

## Pac-Man UI Standard

The MATLAB UI must use the full pixel arcade concept from `source/pey_man/PEY_MAN_UI.md`. It should render the model outputs as maze progress, pellets, ghost pressure, score, and streak. Pac-Man styling is the product surface, not a decorative chart wrapper.

## Guardrail

The UI must not invent metrics that the model does not export. If a new visual needs a new value, add it to this contract and the exporter first.
