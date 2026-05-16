# Presentation Assets Index

For the teammate building the final deck. All paths are repo-relative.

---

## ✅ READY (commit'lenmiş, sürükle-bırak kullanılabilir)

### Slide-ready visuals

| Asset | Path | Size | Kullan |
|---|---|---|---|
| Hero UI screenshot | `docs/screenshots/ui.png` | 73 KB | Slide 1 hero + Slide 5 final shot |
| Real-session closeup | `docs/screenshots/ui_real_session.png` | 43 KB | Slide 4 "what's novel" |
| Demo video | `docs/screenshots/demo.mp4` | 2.5 MB | Slide 5 embed or backup if live demo fails |
| Devpost cover | `docs/project/devpost_cover.png` | 38 KB | Slide 1 alternate hero |
| Full slide deck PDF | `docs/project/PEY_MAN_DECK.pdf` | 109 KB | Reference layout / fallback deck |

### Slide content (copy-paste source)

| Asset | Path | Kullan |
|---|---|---|
| Slide narrative | `docs/project/SLIDE_DECK.md` | 5 slayt başlık+gövde+visual notları |
| 5-min demo script | `docs/project/DEMO_SCRIPT.md` | Sunum sırasında okunacak metin, timing dahil |
| Devpost submission text | `docs/project/DEVPOST_SUBMISSION.md` | Devpost form'una yapıştırılan tam metin |
| Backup plan | `docs/project/DEMO_FALLBACK.md` | Online ölürse local launch path |

---

## 🟡 EKSİK — Operatörün MATLAB Online'dan kapması gereken figure'lar

Pipeline çalıştığında `exportPeyManArtifacts` otomatik PNG export eder. Bu PNG'leri repo'ya taşımak için MATLAB Online konsoluna:

```matlab
% En son session klasörünü bul ve PNG'leri repo'ya kopyala
d = dir('outputs');
d = d([d.isdir] & ~startsWith({d.name}, '.'));
[~, idx] = max([d.datenum]);
sessionDir = fullfile('outputs', d(idx).name);
pngs = dir(fullfile(sessionDir, 'figure_*.png'));
if ~isfolder('docs/screenshots/figures'), mkdir('docs/screenshots/figures'); end
for i = 1:numel(pngs)
    copyfile(fullfile(sessionDir, pngs(i).name), fullfile('docs/screenshots/figures', pngs(i).name));
end
fprintf('Copied %d figure PNGs to docs/screenshots/figures/\n', numel(pngs));
```

Bu komut çalıştıktan sonra `!git add docs/screenshots/figures; !git commit -m "Add live session figures"; !git push` ile commit'le.

### Ek olarak çekmesi gereken ekran görüntüleri

| Asset | Nasıl alınır | Kullan |
|---|---|---|
| **Yeni daily-task UI** (commit a87f483) | `runPeyManPixelApp` aç → tam ekran screenshot → `docs/screenshots/ui_daily_tasks.png` | Slide 4 — yeni "what's novel" item |
| **Console validation accuracy** | Konsoldaki `Validation accuracy: XX.X% (held-out N rows)` satırını ekran görüntüsü ile yakala → `docs/screenshots/validation_accuracy.png` | Slide 3 model evidence |
| **Dashboard figure** (createDashboard 2×2) | `createDashboard` figure'ı → File → Save As → PNG → `docs/screenshots/dashboard.png` | Slide 3 — model + fatigue overview |

---

## 🎨 Stil rehberi (sunum tutarlılığı)

| Element | Değer |
|---|---|
| Background | `#02020b` veya `#0a0a14` (siyah-mor arası) |
| Accent yellow | `#ffe600` (Pac-Man sarısı) |
| Accent cyan | `#22d9ff` (ghost-eye mavisi) |
| Highlight green | `#34e36d` (completed task yeşili) |
| Danger red | `#ff2b3d` (fatigue chase kırmızısı) |
| Font (kod/etiket) | Courier New bold |
| Font (gövde) | Inter / Helvetica / sans-serif |

`tools/build_presentation_assets.py` zaten bu paletle deck'i üretiyor — yeni screenshot eklediğinde script'i tekrar çalıştırarak PDF'i refresh edebilirsin:

```bash
py -3 tools/build_presentation_assets.py
```

---

## 📦 Tek-zip submission paketi

Komple snapshot zip için:
```bash
git archive --format=zip --output=Pey-Man.zip HEAD
```

Üretilen `Pey-Man.zip` (~14 MB) Devpost'a tek dosya upload için hazır.
