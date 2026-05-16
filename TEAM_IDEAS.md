# Team Ideas Intake

## Raw Direction

The team wants Pey-Man to feel more like a product than a plain sensor script:

- Pac-Man style goals,
- fall event detection,
- inactivity detection,
- confidence index for probabilistic sensor estimates,
- fatigue measurement,
- step tracking,
- walk versus run detection,
- consistency score,
- treadmill/running-program research,
- Mert-led UI design,
- MATLAB-only project execution.

## MVP Translation

Ship these first:

- Fatigue Index Timeline,
- Session Summary in English,
- ML Activity Breakdown: sit / walk / run,
- Workout Quality Score,
- Step Count,
- Distance with GPS or stride fallback,
- Estimated Calories,
- Cadence,
- Confidence Index.

## Stretch Translation

Add only after P0 is demo-ready:

- Pac-Man pellet goals,
- fall event candidate,
- inactivity alerts,
- treadmill/running-program recommendations,
- character/persona mode for motivational polish.

## Guardrail

No hardcoded private person, customer, path, or phone log. The demo must run from clean checkout with `demoMode=true`.

