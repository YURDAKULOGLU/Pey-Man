# Live Stream Test Scenarios

Two paths: with a real phone (the demo path) or with the synthetic simulator (no phone needed).

---

## SENARYO A — Real Phone, Real Stream

**Süre**: 5 dakika. **Gerek**: Phone with MATLAB Mobile, laptop with MATLAB Online, same MathWorks account.

### Adım 1 — Phone

1. MATLAB Mobile aç → Sensors
2. Üst toggle → **Stream to MATLAB** (Log değil)
3. Acceleration + Position ON
4. **Start** bas

Doğrulama: Telefonda "Streaming to MATLAB..." görmelisin.

### Adım 2 — Laptop, MATLAB Online

```matlab
!git pull
cd /MATLAB Drive/Repositories/Pey-Man-2
runPeyManLiveStream
```

Beklenen konsol çıktısı:
```
Pey-Man live stream ready.
MATLAB Mobile should be signed into the same MathWorks account.
LIVE WAIT | no new samples yet.
LIVE BUFFER | 12.0s collected, waiting for 24.0s.
LIVE BUFFER | 24.0s collected, waiting for 24.0s.
(then per-tick metric updates)
```

İlk 24 saniyede analiz yapmaz (buffer dolduruyor). Sonra her 3 sn'de bir metric refresh.

### Adım 3 — UI panel kullan

`runPeyManLiveStream` UI'ı otomatik açar.

1. Sidebar'daki **LIVE TASKS** panelinde:
   - Activity: `walk`
   - Minutes: `1`
   - Calories: `5`
   - Steps: `100`
2. **START** bas
3. Telefonu cebine koy, **gerçekten yürü** 1 dakika
4. Beklenen davranış:
   - Daily-task pelletları (maze içi) yeşil dolar
   - Pac-Man ilerler
   - Live timer panel'de geri sayar
5. 1 dk sonra target hit → Pac-Man pellet yer
6. **END** bas (veya targetı tamamlamadan END'lersen Pac-Man geri kayar)

### Başarı kriteri

- [ ] Konsol "LIVE … samples" satırlarını basıyor
- [ ] `outputs/live/latest_metrics.json` mtime'ı 3-5 sn'de bir güncelleniyor
- [ ] UI panelindeki sayılar canlı değişiyor
- [ ] LIVE TASKS panelinde START/END butonu çalışıyor
- [ ] Pac-Man hareket etti

3'ü tutarsa demo'da bonus path. Tutmazsa **fallback'e geç** (Senaryo B).

---

## SENARYO B — Synthetic Simulator (Phone'siz)

**Süre**: 2 dakika. **Gerek**: Sadece MATLAB (Online veya local).
**Amaç**: UI auto-refresh + LIVE TASKS panel'in canlı veriyle çalıştığını telefonsuz test et.

### Tek MATLAB session'da

En kısa demo-safe yol:

```matlab
cd /MATLAB Drive/Repositories/Pey-Man-2
runPeyManLiveStream
```

Telefon MATLAB Online tarafından görülmezse bu komut otomatik olarak synthetic
live fallback'e düşer, `outputs/live/` yazar ve UI'ı açar. Böylece jürinin
önünde `mobiledev` bağlantısı yok diye app çökmez.

Manuel simulator testi için iki ayrı MATLAB pencere (veya iki sekme) kullan:
biri simulator yazıyor, biri UI okuyor.

**Pencere 1 — Simulator**:
```matlab
cd /MATLAB Drive/Repositories/Pey-Man-2
addpath('source/pey_man')
simulateLiveStream(struct("durationSeconds", 60, "tickSeconds", 3))
```

Her 3 saniyede bir konsola yazacak:
```
[ 1/20] steps=42  kcal=3  fat=10  qual=31  sport=Mixed Session
[ 2/20] steps=68  kcal=4  fat=12  qual=33  sport=Mixed Session
[ 3/20] steps=92  kcal=6  fat=15  qual=35  sport=Walking Session
...
```

**Pencere 2 — UI** (simulator çalışıyorken):
```matlab
runPeyManPixelApp("outputs/live", struct("autoRefreshSeconds", 2))
```

UI penceresi açılır, her 2 sn'de bir auto-refresh. Pencere 1'in ürettiği verilere göre paneller değişir.

### Tek MATLAB session — alternatif

`simulateLiveStream` blocking (pause kullanıyor). Tek pencerede çalıştırmak için simulator'ı background timer'a koymak gerekir. Önerilen: iki ayrı tab.

### Başarı kriteri

- [ ] Simulator konsola tick basıyor
- [ ] UI auto-refresh ediyor (sayılar değişiyor)
- [ ] DAILY TASKS sayacı (maze üstü) artıyor
- [ ] Fatigue timeline panel doluyor
- [ ] LIVE TASKS panel kullanılabiliyor (START/END butonu ekranda)

---

## ÇÖKMELER & KURTARMA

| Belirti | Çözüm |
|---|---|
| `runPeyManLiveStream` phone bulamıyor | Normal: launcher synthetic live fallback'e düşer. Gerçek stream için MATLAB Mobile > Sensors > More > Sensor Access ve Stream to MATLAB'ı aç |
| Fallback de başlamıyor | `simulateLiveStream(struct("durationSeconds", 60, "tickSeconds", 3))` çalıştır, sonra `runPeyManPixelApp("outputs/live", struct("autoRefreshSeconds", 2))` |
| Telefon stream LED yeşil ama konsol no samples | Aynı MathWorks hesabıyla giriş yap. Phone Wi-Fi |
| LIVE TASKS panel görünmüyor | Eski UI cache'i. `close all; runPeyManPixelApp` ile yeniden aç |
| UI auto-refresh etmiyor | `autoRefreshSeconds` 0 verilmiş. `struct("autoRefreshSeconds", 2)` parametresiyle aç |
| Tamamen patlama | `git checkout stable-pre-livestream` → file-based path sağlam |

---

## DEMO İÇİN HANGİSİ?

**Sahne kararı**:
- Senaryo A test edip GREEN → demo'da live mode kullan (bonus güç)
- Senaryo A test edip RED → demo'da sadece dosya-tabanlı path (`runPeyManPixelApp("outputs/example_file")`) ile devam et, "live mode is opt-in for rehearsal" de
- Telefon yok / hiç deneme yapamadın → Senaryo B ile UI'yı judges'a göster, "live mode also supported via simulator" diyebilirsin

File-based judged path **HER ZAMAN** çalışır. Live = bonus.
