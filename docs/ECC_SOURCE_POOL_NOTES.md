# ECC Source Pool Notes

Source pool: `C:\vendors\everything-claude-code`

Boundary: reference-only. Nothing in this repository should run ECC hooks, commands, MCP config, agents, or skills directly.

## Inspected Patterns

- `skills/mle-workflow/SKILL.md`
  - Use for data contract, baseline-before-complexity, eval/verification, and explicit mistake economics.
- `skills/ui-demo/SKILL.md`
  - Use the Discover -> Rehearse -> Record principle for the final demo, adapted to MATLAB demo prep rather than Playwright automation.
- `skills/skill-scout/SKILL.md`
  - Use the search-before-building habit before creating new project skills or helper workflows.
- `skills/workspace-surface-audit/SKILL.md`
  - Use the current-surface / primitive-gap / next-move framing for project onboarding.
- `agents/mle-reviewer.md`
  - Use as review inspiration for leakage, reproducibility, data contract, metric, and promotion discipline.

## Adopted Into Pey-Man Workflow

- Always start from a data contract and baseline.
- Do not introduce machine learning unless the baseline is stable and the data supports it.
- Treat demo reliability as a first-class deliverable.
- Preserve a short, reviewable spec before implementation.
- Keep security and private data boundaries explicit.

## Rejected For Runtime

- ECC agents as direct project executors.
- ECC hooks or command shims.
- Any skill that installs packages, modifies credentials, or changes shell/MCP settings.

## Current YSIS Council Shape

The project-specific council is stored at:

`./.ysis/councils/pey-man-spec-council.json`

It uses Kimi + Codex + Claude and excludes GLM because GLM was unavailable/rate-limited during the first YSIS council attempts.
