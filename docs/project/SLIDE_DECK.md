# Pey-Man — 5-Slide Deck (Copy-Paste Ready)

Convert each block below into one Google Slides / PowerPoint slide. Theme: dark background (#0a0a14), neon yellow accent (#ffea00), Courier New for code/labels, Inter or sans for body.

---

## SLIDE 1 — Title

**Header**: PEY-MAN

**Tagline**: Turn your workout into a Pac-Man game.

**Subtitle**: MathWorks Hackathon 2025

**Footer**:
- YURDAKULOGLU · Mertrenlab · azadbulut
- `github.com/YURDAKULOGLU/Pey-Man` + QR code

**Visual**: Pac-Man eating a heart-rate pellet (or just the pixel logo).

---

## SLIDE 2 — Problem

**Header**: Fitness apps are sterile.

**Body** (3 bullets, big text):
- Same charts, same numbers, no story.
- Judges & users see *what*, never *why* you're tired.
- Pac-Man metaphor turns fatigue into a chase you can watch.

**Visual**: Two-panel split — left: boring Strava line chart. Right: Pey-Man neon dashboard.

---

## SLIDE 3 — How It Works

**Header**: Sensor → Model → Story

**Flow diagram** (left-to-right arrows):

```
MATLAB Mobile  →  Preprocess  →  Bagged Trees  →  Fatigue Index  →  Pac-Man UI
 (accel + GPS)    (timetable     (fitcensemble,    (rolling load     (pure MATLAB
                  windows 2s)    60 learners,      + peak label)     uifigure)
                                  20% holdout)
```

**Footer**: All in MATLAB, no external assets, toolbox-free fallback path.

---

## SLIDE 4 — What's Novel

**Header**: Three things you haven't seen.

1. **Pac-Man arcade UI in pure MATLAB** — every pixel from `uifigure`, no images, no JS.
2. **Fatigue Index narrative** — rolling activity-load with peak label ("walking → running spike at 2:14").
3. **Fallback ladder** — `fitcensemble` → `fitctree` → centroid → rule. Demo always runs.

**Visual**: Side-by-side: arcade ghost char + fatigue timeline annotation.

---

## SLIDE 5 — Demo + Results

**Header**: 92.9% validation accuracy on held-out windows.

**Body**:
- Live: `runPeyManPixelApp` on MATLAB Online (deeplink + QR).
- Bundled session: 4 IRL recordings (sit / walk / run / fatigue_demo).
- Repo: MIT licensed, public, README has the quickstart.

**Big call-to-action**: scan QR → `matlab.mathworks.com/open/github/v1?repo=YURDAKULOGLU/Pey-Man&file=source/pey_man/main.m`

**Closing line**: "Pey-Man eats your steps. Don't let the ghost catch you."

---

## Quick build (copy-paste path)

1. Open Google Slides → blank deck → 16:9 → dark theme.
2. For each slide above: paste Header into title, body into one big text box, swap visual.
3. Add QR for slide 1 + 5 via `https://qrcode.tec-it.com/` pointing at the repo URL.
4. Export PDF → `docs/project/PEY_MAN_DECK.pdf`.
5. Share link (view-only) in #20 comment.
