# PLAN

Current focus: finish the user-owned launch checks for issues #10 and #11 without weakening the working baseline.

## Active Order

1. #10 IRL sensor data record
   - Record `sit_session.mat`, `walk_session.mat`, `run_session.mat`, and `fatigue_demo.mat` with MATLAB Mobile.
   - Keep raw `.mat` files in `local_data/`; do not commit them.
   - Log only sanitized session summaries in `docs/testing/IRL_TEST_LOG.md`.
   - Run `cd source/pey_man; runLocalDataSession` once `fatigue_demo.mat` exists.
2. #11 MATLAB Online clean checkout test
   - Open the MATLAB Online GitHub deeplink from `README.md`.
   - Run `cd source/pey_man; main`.
   - Confirm `outputs/example_file/latest_metrics.json` exists.
   - Run `cd ../..; runPeyManPixelApp`.
   - Comment on issue #11 with MATLAB release, toolbox availability, validation accuracy, and UI status.

## Latest Local Evidence

- 2026-05-16: Local MATLAB R2025b batch smoke ran `source/pey_man/main.m` successfully.
- Validation accuracy printed locally: `100.0% (held-out 15 rows)`.
- `outputs/example_file/latest_metrics.json` was generated locally with `modelValidationAccuracy = 1`.

## Blockers

- #10 still needs physical MATLAB Mobile recordings from the phone.
- #11 still needs an actual MATLAB Online fresh checkout confirmation.
