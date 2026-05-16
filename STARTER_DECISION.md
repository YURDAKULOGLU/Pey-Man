# Starter Decision

## Decision

Build a MATLAB Online-safe Workout Quality Tracker.

The baseline will be deterministic and explainable:

- Required input: phone acceleration data.
- Optional input: GPS position data.
- Main output: Fatigue Index, 0 to 100.
- Main output: Workout Quality Score, 0 to 100.
- Supporting output: rule-based activity or intensity windows.
- Demo path: `demoMode=true` using bundled sample data.

Machine learning is optional and deferred until the deterministic baseline is green.

## Why This Starter

This direction scores better than a plain step counter because it is less like the official starter example and gives judges a clearer product story: not just "how many steps", but "how good was the workout and where did fatigue appear".

This direction is safer than an LSTM-first approach because this repository does not yet prove:

- labeled fatigue sequences,
- a reproducible training pipeline,
- Deep Learning Toolbox availability,
- a clean export and reload path,
- enough data to avoid overfitting.

The first win must be reliable, explainable, and demo-ready.

## Canonical Scope

Create a deterministic baseline under `source/pey_man/`:

- `PeyManDemo.mlx`
- `loadSessionData.m`
- `buildWindowFeatures.m`
- `classifyActivityRuleBased.m`
- `computeFatigueIndex.m`
- `computeWorkoutQualityScore.m`
- `plotWorkoutSummary.m`
- `haversineDistance.m`

## Deferred Scope

- LSTM or deep learning fatigue prediction.
- Classification Learner dependency.
- App Designer UI.
- Real-time streaming.
- Exported app artifacts.
- Private raw phone data commits.

## Council Evidence

YSIS task: `T-20260516114755611-001`

Council runs:

- `council-2b6a00a3d2`: product strategy, degraded because Kimi returned `LLM not set`.
- `council-81541d417e`: architecture review, degraded because Kimi returned `LLM not set` and GLM was rate-limited.
- `council-3d8b4c4ae3`: project-specific Pey-Man council, actionable with Codex and Claude agreement; Kimi still returned `LLM not set`.
- `council-2ea872ea98`: post-alias partial rerun; Kimi still degraded because council imported the duplicate `ysis.agents.platforms` path; Gemini returned investigation boilerplate.
- `council-b10d97abb7`: post-fix rerun; Kimi, Codex, and Claude produced substantive agreement; Gemini remained invalid with readiness/meta output.

Canonical decision: deterministic Workout Quality Tracker first.
