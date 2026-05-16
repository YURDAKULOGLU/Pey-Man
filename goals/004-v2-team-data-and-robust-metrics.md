# Goal 004 - V2 Team Data And Robust Metrics

## Objective

Make Pey-Man credible beyond starter data by running team-collected or synthetic fatigue sessions through the same pipeline.

## Required Work

1. Add a safe data intake note for team `.mat` files.
2. Add or document a synthetic fatigue demo generator if live data is delayed.
3. Run `source/pey_man/main.m` with one non-starter session if available.
4. Tune confidence and score formulas only with documented rationale.
5. Update `VERIFY.md`.

## Constraints

- Do not commit private raw phone logs without explicit approval.
- Do not hardcode person names, local paths, or one-off file names into source.
- Do not break V1.

## Completion Evidence

- Team or synthetic V2 run recorded.
- MATLAB command recorded.
- Score bounds and fallback paths still pass.
- Remote `origin/main` contains the final commit.

