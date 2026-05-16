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

## Live Stream Mode

Optional live mode uses MATLAB Mobile sensor streaming through `mobiledev` in MATLAB Online.

Requirements:

- same MathWorks account on phone and MATLAB Online,
- `Stream to -> MATLAB` in MATLAB Mobile,
- sensor access enabled on the device,
- network connection stable enough for rehearsal.

Live mode can disconnect, stall, or lose Position samples. The pipeline must continue to support file-based `.mat` replay as the primary path.

## Sensor Assumptions

- Sampling intervals may be irregular.
- Acceleration includes gravity until baseline removal.
- Phone orientation can vary, so the algorithm uses magnitude rather than assuming a fixed axis.
- GPS can be missing, denied, noisy, or indoor-unusable.
- `mobiledev` streams can disconnect or pause without warning.

## Guardrails

- Do not make live sensors mandatory for the demo.
- Do not commit private raw phone logs without explicit approval.
- Do not let optional GPS failures crash the baseline.
- Do not let live `mobiledev` failures replace the bundled or synthetic fallback path.
