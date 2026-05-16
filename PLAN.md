# Pey-Man Plan

## Objective

Build a practical MATLAB Mobile fitness tracker from the starter package and prepare a strong hackathon submission.

## Immediate Phases

1. Repository setup
   - Create private GitHub repo.
   - Commit starter package and project hygiene files.
   - Keep every future step pushed.

2. Rubric extraction
   - Read the official instructions and grading rubric.
   - Convert them into a concise implementation checklist.

3. Baseline model
   - Open the starter live script.
   - Confirm data loads.
   - Produce at least one reliable metric and one plot.

4. Competitive feature
   - Add one higher-value feature after the baseline works: activity classification, workout quality scoring, peak detection, or model comparison.

5. Demo and submission
   - Prepare a short English demo path.
   - Package final files.
   - Verify no private or unrelated files are included.

## Current Decision

Start pragmatic: keep the model baseline available, but add a memorable 100% MATLAB pixel UI early so the hackathon demo has a clear product story.

## Pixel UI Phase

- Launch with `runPeyManPixelApp`.
- Keep the first version manual-input so the team can demo before sensor integration is complete.
- Next step: connect the UI inputs to computed metrics from the MATLAB Mobile pipeline under `source/pey_man/`.
