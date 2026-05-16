# Verify

## 2026-05-16 P0 MATLAB Pipeline

Command:

```powershell
matlab -batch "cd('C:/Projeler/Pey-Man/source/pey_man'); main"
```

Result: passed.

Observed output:

```text
WorkoutQualityScore: 58.9 / 100
FatigueIndex: 17.2 / 100
ConfidenceIndex: 91.4%
StepCount: 624
DistanceKm: 0.658
DistanceSource: gps
CadenceSpm: 104.8
EstimatedCalories: 26.0
ActiveMinutes: 6.1
PeakFatigueLabel: Peak Fatigue Signal at 5:56
```

Coverage:

- acceleration data loaded from bundled starter `.mat`,
- activity classifier path executed from `ActivityLogs.mat`,
- fatigue timeline computed,
- session summary generated in English,
- confidence index computed,
- step count, distance, cadence, and calories computed,
- raw sensor overview, hero plot, and dashboard code executed without MATLAB error.

Remaining checks:

- MATLAB Online clean checkout run,
- team-collected sit/walk/run/fatigue data run,
- demo rehearsal under 5 minutes.

## Repeatability

Command:

```powershell
matlab -batch "cd('C:/Projeler/Pey-Man/source/pey_man'); opts=struct(); opts.demoMode=true; opts.useML=true; opts.baselineSeconds=60; opts.windowSeconds=4; opts.windowOverlap=0.75; opts.bodyMassKg=70; opts.strideLengthM=0.72; opts.dataFile=fullfile('C:/Projeler/Pey-Man/source/matlab-mobile-fitness-tracker-master/ExampleData.mat'); opts.activityLogFile=fullfile('C:/Projeler/Pey-Man/source/matlab-mobile-fitness-tracker-master/ActivityLogs.mat'); r1=runPeyManPipeline(opts); close all; r2=runPeyManPipeline(opts); close all; assert(r1.summary.FatigueIndex==r2.summary.FatigueIndex); assert(r1.summary.WorkoutQualityScore==r2.summary.WorkoutQualityScore); assert(r1.summary.StepCount==r2.summary.StepCount); disp('REPEATABILITY_OK');"
```

Result: `REPEATABILITY_OK`.

## Rule Fallback

Command:

```powershell
matlab -batch "cd('C:/Projeler/Pey-Man/source/pey_man'); opts=struct(); opts.demoMode=true; opts.useML=false; opts.baselineSeconds=60; opts.windowSeconds=4; opts.windowOverlap=0.75; opts.bodyMassKg=70; opts.strideLengthM=0.72; opts.dataFile=fullfile('C:/Projeler/Pey-Man/source/matlab-mobile-fitness-tracker-master/ExampleData.mat'); opts.activityLogFile=''; r=runPeyManPipeline(opts); close all; assert(r.model.type=='rule'); assert(r.summary.FatigueIndex>=0 && r.summary.FatigueIndex<=100); assert(r.summary.WorkoutQualityScore>=0 && r.summary.WorkoutQualityScore<=100); disp('RULE_FALLBACK_OK');"
```

Result: `RULE_FALLBACK_OK`.

## 2026-05-16 V2 Synthetic Fallback Attempt

Added:

- `source/pey_man/generateSyntheticFatigueSession.m`
- `source/pey_man/runSyntheticFatigueDemo.m`
- `TEAM_DATA_INTAKE.md`

Repository hygiene:

```powershell
python tools/check_repo_hygiene.py
```

Result: `HYGIENE_OK`.

MATLAB rerun status: blocked by local MATLAB startup, not by a captured Pey-Man error. Even this minimal command timed out without writing a log:

```powershell
matlab -batch "disp('STARTUP_TEST')"
```

Follow-up status: MATLAB batch startup recovered and the V2 smoke tests below passed.

## 2026-05-16 V2 IRL Readiness Smoke

Synthetic fallback with artifact export:

```powershell
matlab -batch "cd('C:/Projeler/Pey-Man/source/pey_man'); runSyntheticFatigueDemo; assert(isfile(fullfile('C:/Projeler/Pey-Man','outputs','synthetic','latest_metrics.json'))); assert(isfile(fullfile('C:/Projeler/Pey-Man','outputs','synthetic','fatigue_timeline.csv'))); disp('SYNTHETIC_EXPORT_OK')"
```

Result: `SYNTHETIC_EXPORT_OK`.

Observed synthetic output:

```text
WorkoutQualityScore: 52.3 / 100
FatigueIndex: 49.3 / 100
ConfidenceIndex: 92.5%
StepCount: 597
DistanceKm: 0.679
DistanceSource: gps
CadenceSpm: 90.0
EstimatedCalories: 37.8
ActiveMinutes: 7.2
PeakFatigueLabel: Moderate Fatigue Signal at 7:07
```

Local data fallback when `local_data/*.mat` is absent:

```powershell
matlab -batch "cd('C:/Projeler/Pey-Man/source/pey_man'); runLocalDataSession; assert(isfile(fullfile('C:/Projeler/Pey-Man','outputs','synthetic','latest_metrics.json'))); disp('LOCAL_DATA_FALLBACK_OK')"
```

Result: `LOCAL_DATA_FALLBACK_OK`.

Specific `.mat` file runner using starter data as stand-in for a real phone file:

```powershell
matlab -batch "cd('C:/Projeler/Pey-Man/source/pey_man'); r=runPeyManFile('../matlab-mobile-fitness-tracker-master/ExampleData.mat', fullfile('C:/Projeler/Pey-Man','outputs','example_file')); assert(isfile(fullfile('C:/Projeler/Pey-Man','outputs','example_file','latest_metrics.json'))); assert(r.summary.WorkoutQualityScore>=0 && r.summary.WorkoutQualityScore<=100); disp('RUN_FILE_OK')"
```

Result: `RUN_FILE_OK`.

Artifacts are written under ignored `outputs/`.

## 2026-05-16 Overlap Metrics + Graph Semantics Fix

Problem found during visual review: 4-second analysis windows with 75% overlap were being summed as full independent duration. This inflated active minutes, steps, calories, and activity mix by roughly the overlap factor.

Fix:

- added `effectiveDurationSec`,
- changed steps, calories, active minutes, quality score, and activity mix to use represented non-overlap duration,
- added raw acceleration + ML feature overview figure,
- changed fatigue plot to fixed low/moderate/elevated threshold bands,
- changed low-fatigue annotation from "elevated" to "peak",
- added model diagnostics to exported JSON,
- added toolbox-free nearest-centroid ML fallback so training still happens without `fitctree`,
- added optional MATLAB `webwrite` coaching path with deterministic fallback.

Commands:

```powershell
matlab -batch "cd('C:/Projeler/Pey-Man/source/pey_man'); main"
matlab -batch "cd('C:/Projeler/Pey-Man/source/pey_man'); runSyntheticFatigueDemo; assert(isfile(fullfile('C:/Projeler/Pey-Man','outputs','synthetic','latest_metrics.json'))); disp('SYNTHETIC_EXPORT_OK')"
matlab -batch "cd('C:/Projeler/Pey-Man/source/pey_man'); r=runPeyManFile('../matlab-mobile-fitness-tracker-master/ExampleData.mat', fullfile('C:/Projeler/Pey-Man','outputs','example_file')); assert(isfile(fullfile('C:/Projeler/Pey-Man','outputs','example_file','latest_metrics.json'))); assert(r.summary.WorkoutQualityScore>=0 && r.summary.WorkoutQualityScore<=100); disp('RUN_FILE_OK')"
matlab -batch "cd('C:/Projeler/Pey-Man/source/pey_man'); runLocalDataSession; assert(isfile(fullfile('C:/Projeler/Pey-Man','outputs','synthetic','latest_metrics.json'))); disp('LOCAL_DATA_FALLBACK_OK')"
python tools/check_repo_hygiene.py
```

Results:

- `main`: passed.
- `SYNTHETIC_EXPORT_OK`: passed.
- `RUN_FILE_OK`: passed.
- `LOCAL_DATA_FALLBACK_OK`: passed.
- `HYGIENE_OK`: passed.

Visual review:

- `outputs/example_file/figure_2.png`: threshold bands now fixed; low fatigue is labelled as peak, not elevated.
- `outputs/example_file/figure_3.png`: raw acceleration and ML feature labels are visible.
- `outputs/synthetic/figure_2.png`: fatigue rises during sustained effort and drops during rest.
- `outputs/synthetic/figure_3.png`: rest segment is visible and low-motion guard prevents the rest segment from being fully over-called as run.
