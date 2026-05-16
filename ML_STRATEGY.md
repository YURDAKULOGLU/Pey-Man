# ML Strategy

## Decision

Use machine learning where it is easy to prove and explain:

- `P0`: supervised `sit / walk / run` activity classification from MATLAB Mobile activity logs.
- `P0`: deterministic Fatigue Index from baseline deviation, cadence drop, activity consistency, and late-session load.
- `P1`: step count, distance, calories, cadence, and dashboard polish.

Do not make the Fatigue Index a black-box model for the starter. Judges need to see why the fatigue signal rose.

## Why This Can Score Higher

The project still shows real ML through the activity classifier, but the hero score remains interpretable. This gives the demo three scoring hooks:

- model making: raw sensor data to features to ML labels to fatigue/quality scores,
- MATLAB mastery: timetables, window features, classifier training, plotting,
- presentation: annotated Fatigue Index timeline and English session narrative.

## P0 Technical Path

1. Load `ActivityLogs.mat`.
2. Build labeled windows from `sitAcceleration`, `walkAcceleration`, and `runAcceleration`.
3. Extract compact features:
   - mean dynamic acceleration,
   - standard deviation,
   - RMS,
   - peak count,
   - active ratio,
   - dominant cadence frequency,
   - spectral power,
   - optional GPS speed.
4. Train `fitctree` if Statistics and Machine Learning Toolbox is available.
5. Fall back to a toolbox-free nearest-centroid classifier if `fitctree` is unavailable.
6. Use deterministic rules only if labeled training data is unavailable.
7. Use classifier confidence as one component of the sensor confidence index.

## Evaluation Discipline

AgentLaboratory was inspected as a reference for research workflow quality. We are not adding it as a dependency. The reusable standard is:

- keep a dataset manifest,
- record train rows and label counts,
- separate training evidence from generalization claims,
- run a leakage audit before claiming model quality,
- map every metric to the hackathon rubric.

For the starter demo, `modelTrainingAccuracy` is only a sanity signal. It is not a final accuracy claim because the starter labels are used to train the classifier. Team data must be used for a stronger evaluation.

## What Not To Do Before Baseline Green

- No LSTM-first plan.
- No deep learning dependency.
- No safety claim for fall detection.
- No API dependency for the core demo.
- No UI polish that blocks `main.m`.

## 100-Point Demo Bet

The hero scene is:

1. raw acceleration becomes windows,
2. windows become ML activity labels,
3. labels and motion features become Fatigue Index,
4. Fatigue Index produces one annotated timeline,
5. the session summary explains what happened in English.

## Graph Verdict Rule

The project should show more than raw data. A good graph sequence is:

1. raw acceleration overview,
2. extracted feature windows with ML labels,
3. fatigue timeline with fixed threshold bands,
4. dashboard with score, confidence, steps, calories, cadence, and activity mix.

