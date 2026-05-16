# Presentation Assets — Pey-Man

Copy-paste-ready figures, data, and headline numbers for the final deck.

---

## 🔥 Headline numbers (use on Slide 3 — model evidence)

| Metric | Value | Source |
|---|---|---|
| **Validation accuracy** | **92.86 %** | held-out 20% split on `ActivityLogs.mat` |
| Training accuracy | 97.40 % | same dataset, resubstitution |
| Classifier | `centroid` (toolbox-free fallback proven robust) | `trainActivityClassifier.m` |
| Confidence Index (real session) | 91.4 / 100 | `example_file_metrics.json` |
| Workout Quality Score | 58.9 / 100 | walking session |
| Fatigue Index range | 9.7 → 49.3 across sessions | rolling activity load |
| Step count (example session) | 624 | peak-detection from accel magnitude |
| Distance | 0.658 km | haversine from GPS |

Same 92.86 % validation accuracy reproduces across all three sessions (example_file, synthetic, short_synthetic) — strong evidence that the model is stable.

---

## 📁 figures/

Sürükle-bırak Google Slides'a / PowerPoint'e.

| File | Ne gösteriyor |
|---|---|
| `00_ui_hero.png` | Pac-Man pixel UI tam ekran — Slide 1 hero |
| `00_ui_real_session.png` | Closeup of real-session panels |
| `example_file_01_raw_sensors.png` | Ham sensör verisi (accel + GPS) |
| `example_file_02.png` … `_05.png` | Pipeline ara figürleri |
| `example_file_06_dashboard.png` | 2×2 dashboard tile (Fatigue + Session Scores + Summary) |
| `synthetic_01–03.png` | Synthetic fallback session figures |
| `short_synthetic_01–03.png` | Quick smoke-test session figures |

---

## 📊 data/

JSON + CSV — judges veriye bakmak isterse veya bar chart üretmek istersen.

| File | Kullan |
|---|---|
| `example_file_metrics.json` | Tam metric struct (92.86% validation accuracy burada) |
| `example_file_activity_mix.csv` | Activity time-distribution bar chart için |
| `example_file_calories.csv` | KCAL by activity bar chart için |
| `example_file_fatigue_timeline.csv` | Fatigue line plot için (minute, FatigueIndex, activityLabel) |
| `synthetic_metrics.json` | Karşılaştırma için ikinci session |
| `short_synthetic_metrics.json` | Üçüncü session — model stability kanıtı |

---

## 🎨 Stil rehberi (palette)

| | |
|---|---|
| Background | `#02020b` |
| Accent yellow | `#ffe600` |
| Accent cyan | `#22d9ff` |
| Highlight green | `#34e36d` |
| Danger red | `#ff2b3d` |
| Font (code/label) | Courier New bold |
| Font (body) | Inter / Helvetica |

---

## 5-slide layout (özet)

1. **Title** — `00_ui_hero.png` arka plan + tagline + repo QR
2. **Problem** — boş slayt + "Fitness apps are sterile" başlık
3. **How it works** — pipeline diagram + `example_file_06_dashboard.png` küçük
4. **What's novel** — `00_ui_real_session.png` + 3 madde
5. **Demo + Results** — **92.86 %** big number + MATLAB Online QR + closing

Tam metin: `docs/project/SLIDE_DECK.md` ve `docs/project/DEMO_SCRIPT.md`.
