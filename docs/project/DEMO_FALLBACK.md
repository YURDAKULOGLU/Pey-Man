# Demo Fallback Plan

Use this path if MATLAB Online is slow, unavailable, or not authenticated during judging.

Do not replace this fallback with `mobiledev` live streaming. Live streaming is optional rehearsal polish, not the safety path.

## Local Launch

From a local laptop with MATLAB R2025b:

```matlab
cd C:\Projeler\Pey-Man
runPeyManPixelApp("outputs/example_file")
```

If the sample output is missing, regenerate it:

```matlab
cd C:\Projeler\Pey-Man\source\pey_man
main
cd ..\..
runPeyManPixelApp("outputs/example_file")
```

Synthetic fallback:

```matlab
cd C:\Projeler\Pey-Man\source\pey_man
runSyntheticFatigueDemo
cd ..\..
runPeyManPixelApp("outputs/synthetic")
```

## What To Say During Warm-Up

> If MATLAB Online takes a moment, we have the same MATLAB code running locally. The pipeline exports stable JSON and CSV artifacts, and the UI reads those artifacts directly. This lets us show the exact same model outputs without changing the demo story.

## Expected Local Proof

- `main` prints validation accuracy.
- `outputs/example_file/latest_metrics.json` exists.
- Pixel UI opens with quality, fatigue, confidence, sport, cadence, calories, and validation accuracy populated.

## Current Verified Path

Local clean-clone MATLAB R2025b proxy passed on 2026-05-16:

```text
Validation accuracy: 92.9% (centroid fallback held-out 14 rows)
CLEAN_CLONE_MAIN_AND_UI_OK
```

Online and second-laptop verification remain team rehearsal tasks.
