# Phone Quickstart — 5 Minutes to a Pey-Man Session

Print or open on the laptop. Follow top to bottom, do not skip.

---

## STEP 1 · Install MATLAB Mobile (~60 sec)

- **iPhone**: App Store → search "MATLAB Mobile" → install.
- **Android**: Play Store → search "MATLAB Mobile" → install.
- Open the app → sign in with your MathWorks account (same one as MATLAB Online).

If sign-in fails: open `matlab.mathworks.com` in the phone browser, log in there first, then return to the app.

---

## STEP 2 · Configure Sensors (~30 sec)

In MATLAB Mobile:

1. Tap **Sensors** (bottom nav).
2. Top toggle: switch from **Stream to MATLAB** → **Log**.
3. Enable these sensors:
   - ✅ **Acceleration** (required)
   - ✅ **Position / GPS** (recommended)
   - ⚪ Orientation / Angular Velocity (optional)
4. (Optional) tap settings gear → enable **Background logging** so screen-off keeps recording.

Live rehearsal alternative:

- For `runPeyManLiveStream`, keep **Stream to MATLAB** selected instead of **Log**.
- Use live streaming only for rehearsal or testing. The judged demo should still work from bundled, synthetic, or local `.mat` data.

---

## STEP 3 · Record 4 Sessions (~10 min total)

Tap the red **Start** button to begin, **Stop** to end. Each one saves to MATLAB Drive as a `.mat`.

| File | Phone placement | Duration | What to do |
|---|---|---|---|
| `sit.mat` | flat on table | 60–90 s | sit still |
| `walk.mat` | front pocket | 60–90 s | walk indoors |
| `run.mat` | front pocket / strapped | 60–90 s | light jog 30s + walk 30s |
| `fatigue_demo.mat` | front pocket | 3 min | sit 30s → walk 60s → run 60s → walk 30s |

**Naming**: after each Stop, MATLAB Mobile asks for a filename. Type the exact names above.

---

## STEP 4 · Sync to MATLAB Drive (~30 sec)

The app uploads automatically when on Wi-Fi. To verify:

1. Open `matlab.mathworks.com` in the laptop browser.
2. Top-right → **Drive** → look in `MATLAB Drive/MATLAB Mobile/`.
3. You should see your 4 `.mat` files. If not, wait 30s and refresh.

---

## STEP 5 · Run Pey-Man on the Data (~60 sec)

In the laptop browser, open MATLAB Online with this deeplink (it auto-opens `main.m` from the repo):

```
https://matlab.mathworks.com/open/github/v1?repo=YURDAKULOGLU/Pey-Man&file=source/pey_man/main.m
```

Once loaded:

```matlab
% Copy one of your .mat files from MATLAB Drive into the repo folder
copyfile('/MATLAB Drive/MATLAB Mobile/fatigue_demo.mat', 'local_data/')

% Run the pipeline
cd source/pey_man
runLocalDataSession
```

If that prompts for a file: pick `fatigue_demo.mat`. The console should print:

```
Validation accuracy: XX.X% (held-out N rows)
```

And `outputs/<timestamp>/` will appear with `latest_metrics.json`.

---

## STEP 5B · Optional Live Stream (~60 sec)

If you want MATLAB Online to react to the phone in near real time:

```matlab
cd Pey-Man
runPeyManLiveStream
```

Expected behavior:

- MATLAB creates a `mobiledev` connection,
- live metrics are exported under `outputs/live/`,
- the pixel UI auto-refreshes from that folder,
- the `LIVE TASKS` panel can track activity, minute, calorie, and step targets,
- closing the UI or pressing Ctrl+C stops the live loop.

If MATLAB Online cannot see the phone, `runPeyManLiveStream` now falls back to
the synthetic live stream instead of crashing. That fallback still writes
`outputs/live/latest_metrics.json` and opens the UI, so it is safe for rehearsal.
For the real phone path, verify MATLAB Mobile uses the same MathWorks account and
Sensors -> More -> Sensor Access / Stream to MATLAB is enabled.

Do not use this as the only demo path. Keep the file-based path above working.

---

## STEP 6 · Open the UI (~30 sec)

```matlab
cd ..
cd ..
runPeyManPixelApp("outputs/<timestamp>")
```

(Replace `<timestamp>` with the exact folder name that just appeared.)

The Pac-Man pixel UI should open showing your real session.

---

## If something breaks

| Symptom | Fix |
|---|---|
| MATLAB Mobile sign-in loop | Sign in via browser first, then reopen app |
| `.mat` files don't appear in Drive | Wait 60s, refresh; ensure phone is on Wi-Fi |
| `runLocalDataSession` errors on classifier | Falls back automatically; UI still works |
| UI panel shows "n/a" | Sensor was missing for that metric — recheck Step 2 |
| `outputs/<timestamp>` not found | Check console for the printed path; it includes the timestamp |

---

## What to capture for the demo

After Step 6 works:

1. Screenshot the UI → save as `docs/screenshots/ui.png` (replaces README hero)
2. Note the validation accuracy number printed in Step 5
3. Commit `outputs/<timestamp>/latest_metrics.json` only if the team agrees (no PII)

Do **not** commit raw `.mat` files — `local_data/` is gitignored on purpose.
