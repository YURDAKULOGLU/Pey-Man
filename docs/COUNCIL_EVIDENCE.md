# Council Evidence

YSIS task: `T-20260516114755611-001`

## Runs

| Run | Council | Status | Notes |
| --- | --- | --- | --- |
| `council-2b6a00a3d2` | `product-strategy-council` | degraded | Claude proposed fatigue/activity intelligence; Kimi returned `LLM not set`. |
| `council-81541d417e` | `architecture-council` | degraded | Claude recommended deterministic Fatigue Index; Kimi returned `LLM not set`; GLM was rate-limited. |
| `council-3d8b4c4ae3` | `pey-man-spec-council` | actionable | Codex and Claude converged on deterministic Workout Quality Tracker; Kimi returned `LLM not set`. |
| `council-2ea872ea98` | `pey-man-spec-council` | degraded | Kimi still returned `LLM not set`; root cause was duplicate council import path missing alias normalization; Gemini returned unrelated investigation output. |
| `council-b10d97abb7` | `pey-man-spec-council` | actionable | Kimi, Codex, and Claude produced substantive agreement; Gemini remained invalid with readiness/meta output. |

## Kimi Fix

Root cause:

- Council runtime imports `ysis.agents.platforms`.
- Alias normalization existed in `system.agents.platforms`, but not in `ysis.agents.platforms`.
- Council sent `-m kimi-k2.5`; Kimi CLI only accepts `kimi-code/kimi-for-coding`.
- Direct Kimi default prompts worked, but council model-specific prompts returned `LLM not set`.

Fix:

- YSIS commit `0e5e243b`: added Kimi model aliases in `config/integrations/kimi.json`.
- YSIS commit `38e92478`: added alias normalization to `ysis/agents/platforms.py`.

Verification:

- `system.agents.platforms` alias test returned `KIMI_ALIAS_FIXED`.
- `ysis.agents.platforms` alias test returned `KIMI_COUNCIL_PATH_FIXED`.
- Final council rerun produced real Kimi content.

## Canonical Decision

Reject LSTM-first and step-counter-first scope.

Build a deterministic Workout Quality Tracker:

- Fatigue Index
- Workout Quality Score
- rule-based activity windows
- demo mode from bundled data
- optional ML only after baseline verification passes
- GPS as stretch only, never a core blocker

## Tooling Boundary

`C:\vendors\everything-claude-code` is reference-only. ECC patterns inform project gates but are not runtime dependencies.
