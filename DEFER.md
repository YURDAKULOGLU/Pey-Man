# Deferred Scope

The following items are intentionally deferred until the deterministic baseline is green.

## LSTM / Deep Learning

Reason: no labeled fatigue sequence dataset, no proven toolbox availability, and high overfitting risk.

Reactivation condition: at least 200 labeled windows or sequences, confirmed Deep Learning Toolbox access, and a reproducible train/eval script.

## Classification Learner App

Reason: useful for exploration, but not reliable as a baseline dependency for a clean repo run.

Reactivation condition: export a stable classifier and keep the deterministic baseline independent.

## App Designer UI

Reason: adds presentation surface and debugging risk before the model is proven.

Reactivation condition: baseline demo is green and time remains for polish.

## GPS-First Experience

Reason: phone GPS permission and indoor reliability can fail during demos.

Reactivation condition: acceleration-only baseline is green and GPS missing-data path is verified.

## Real-Time Streaming

Reason: live sensor streaming can fail due to device/account/session state.

Reactivation condition: demo mode and sample-data path are already reliable.

## Private Phone Logs

Reason: raw personal sensor data may contain location or behavior traces.

Reactivation condition: operator explicitly approves sanitized sample data for commit.
