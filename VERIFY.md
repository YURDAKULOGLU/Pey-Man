# Verify

## 2026-05-16 P0 MATLAB Pipeline

Command:

```powershell
matlab -batch "cd('C:/Projeler/Pey-Man/source/pey_man'); main"
```

Result: passed.

Observed output:

```text
WorkoutQualityScore: 76.2 / 100
FatigueIndex: 17.2 / 100
ConfidenceIndex: 91.2%
StepCount: 2478
DistanceKm: 0.658
DistanceSource: gps
CadenceSpm: 104.8
EstimatedCalories: 236.6
PeakFatigueLabel: Fatigue Signal Elevated at 5:56
```

Coverage:

- acceleration data loaded from bundled starter `.mat`,
- activity classifier path executed from `ActivityLogs.mat`,
- fatigue timeline computed,
- session summary generated in English,
- confidence index computed,
- step count, distance, cadence, and calories computed,
- hero plot and dashboard code executed without MATLAB error.

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
