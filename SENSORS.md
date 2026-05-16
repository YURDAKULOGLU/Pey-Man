# Sensors

## Required Sensor

Acceleration is the required sensor for the baseline.

Expected fields after normalization:

- `Timestamp`
- `X`
- `Y`
- `Z`

The baseline computes acceleration magnitude and dynamic acceleration from these fields.

## Optional Sensor

GPS position is optional.

Expected fields after normalization:

- `Timestamp`
- `latitude`
- `longitude`

If GPS is unavailable, distance is reported as `NaN` and all score calculations continue from acceleration.

## Demo Mode

`demoMode=true` must run without live phone sensors. It should use bundled sample data or generated replay data.

## Sensor Assumptions

- Sampling intervals may be irregular.
- Acceleration includes gravity until baseline removal.
- Phone orientation can vary, so the algorithm uses magnitude rather than assuming a fixed axis.
- GPS can be missing, denied, noisy, or indoor-unusable.

## Guardrails

- Do not make live sensors mandatory for the demo.
- Do not commit private raw phone logs without explicit approval.
- Do not let optional GPS failures crash the baseline.
