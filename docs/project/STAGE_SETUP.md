# Stage Setup — 60-Second Mise-en-Place

Solo presenter: YURDAKULOGLU. Run this checklist 5 minutes before you go up.

---

## Laptop (primary)

- [ ] Charged ≥ 80% **and** charger plugged in (don't trust the battery)
- [ ] Wi-Fi confirmed — open `matlab.mathworks.com` once to prime the session
- [ ] HDMI / USB-C dongle attached and tested on the venue projector
- [ ] Display mirroring enabled (Cmd+F1 on Mac, Win+P on Windows)
- [ ] Resolution 1920×1080 — adjust if the projector clips edges

## MATLAB Online

- [ ] Logged in with your MathWorks account
- [ ] Deeplink already opened in a tab:
  ```
  https://matlab.mathworks.com/open/github/v1?repo=YURDAKULOGLU/Pey-Man&file=source/pey_man/main.m
  ```
- [ ] Cwd at repo root — verify with `pwd` showing `…/Pey-Man-2` (or similar)
- [ ] Pre-run `main` once so the dashboard already exists in `outputs/`
- [ ] Pre-run `runPeyManPixelApp` once and **leave the window open** — first launch can take 5s

## Phone (optional, only if using live stream)

- [ ] MATLAB Mobile open, signed in
- [ ] Sensor tab visible, **Stream to MATLAB** mode selected
- [ ] Wi-Fi same network as laptop (or both on cellular but reliable)
- [ ] Phone charger nearby — sensor + screen drains battery fast

## Backup laptop (if available)

- [ ] Same repo pre-cloned at `~/Pey-Man/`
- [ ] MATLAB R2025b or later installed locally
- [ ] `outputs/sample_demo/` populated (run `main` once)
- [ ] Knows the local launch command: `cd Pey-Man; runPeyManPixelApp`
- [ ] Plug-in cable ready

## Browser tabs (in order, left to right)

1. MATLAB Online (with `main.m` open)
2. https://github.com/YURDAKULOGLU/Pey-Man (public repo, README hero visible)
3. The slide deck (Google Slides full-screen mode pre-armed)
4. Devpost submission page (in case judges ask to see the form)
5. (optional) `docs/screenshots/demo.mp4` ready to play as video backup

## Slide deck

- [ ] Google Slides in **Present** mode (F5 on Windows, Cmd+Enter on Mac)
- [ ] Slide 1 visible on the projector, your laptop on the *presenter view*
- [ ] Speaker notes follow `docs/project/DEMO_SCRIPT.md`
- [ ] Slide 5 has the QR codes from `docs/presentation/figures/qr_repo.png` and `qr_matlab_online.png`

## Audio

- [ ] Microphone on if available — speak clearly, 150 wpm
- [ ] Laptop volume mid-high in case demo plays sound

---

## The 5 things you can NOT forget

1. **Open `runPeyManPixelApp` before you start** — first launch eats 5s of demo time
2. **The repo URL is public** — say it out loud at minute 4:30: "github.com/yurdakuloglu/Pey-Man, MIT licensed"
3. **Validation accuracy is 92.86%** — drop the number in slide 3
4. **MATLAB Online deeplink works for anyone** — invite judges to try it from their seats
5. **If something breaks, smile and say "let me show you the bundled session"** — `runPeyManPixelApp` on `outputs/example_file/` always works

---

## After the talk

- [ ] Leave laptop screen on the UI for judges who want a closer look
- [ ] Have `docs/project/QA_PREP.md` open in a side tab if questions get technical
- [ ] If asked to send something: share the repo URL — `https://github.com/YURDAKULOGLU/Pey-Man`
