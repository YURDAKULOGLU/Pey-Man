function fig = peyManPixelApp(metricsSource, uiOptions)
%PEYMANPIXELAPP Presentation-ready MATLAB-only Pac-Man fitness UI.
%
% The app is intentionally model-driven: it reads exported pipeline artifacts
% from outputs/<session>/ and maps them into the arcade surface.

if nargin < 1
    metricsSource = "";
end
if nargin < 2
    uiOptions = struct();
end

state.bundle = loadPeyManUiMetrics(metricsSource);
state.autoRefreshSeconds = getUiOption(uiOptions, "autoRefreshSeconds", 0);
state.refreshTimer = [];
state.task = defaultTaskState();
state.taskView = defaultTaskView();

colors.bg = [0.02 0.02 0.08];
colors.panel = [0.03 0.04 0.13];
colors.panel2 = [0.00 0.01 0.05];
colors.wall = [0.00 0.18 0.85];
colors.wallGlow = [0.00 0.72 1.00];
colors.yellow = [1.00 0.88 0.05];
colors.pellet = [1.00 0.92 0.55];
colors.ghost = [1.00 0.18 0.38];
colors.ghost2 = [0.20 0.85 1.00];
colors.white = [0.95 0.95 0.95];
colors.green = [0.12 0.90 0.35];
colors.orange = [1.00 0.56 0.05];
colors.red = [1.00 0.12 0.18];
colors.text = [1.00 0.95 0.72];
colors.muted = [0.58 0.62 0.78];

fig = uifigure( ...
    "Name", "Pey-Man Fitness Tracker", ...
    "Color", colors.bg, ...
    "Position", [80 80 1240 760]);

root = uigridlayout(fig, [1 2]);
root.ColumnWidth = {"1x", 400};
root.RowHeight = {"1x"};
root.Padding = [14 14 14 14];
root.ColumnSpacing = 14;
root.BackgroundColor = colors.bg;

left = uigridlayout(root, [3 1]);
left.Layout.Row = 1;
left.Layout.Column = 1;
left.RowHeight = {64, "1x", 190};
left.Padding = [0 0 0 0];
left.RowSpacing = 12;
left.BackgroundColor = colors.bg;

header = uigridlayout(left, [1 5]);
header.Layout.Row = 1;
header.Layout.Column = 1;
header.ColumnWidth = {"1x", 145, 145, 145, 145};
header.Padding = [0 0 0 0];
header.ColumnSpacing = 10;
header.BackgroundColor = colors.bg;

titleLabel = uilabel(header, ...
    "Text", "PEY-MAN", ...
    "FontName", "Courier New", ...
    "FontWeight", "bold", ...
    "FontSize", 38, ...
    "FontColor", colors.yellow, ...
    "BackgroundColor", colors.bg);
titleLabel.Layout.Row = 1;
titleLabel.Layout.Column = 1;

scoreLabel = makeHeaderLabel(header, "SCORE 000000", colors.text);
scoreLabel.Layout.Column = 2;

levelLabel = makeHeaderLabel(header, "LEVEL 01", colors.text);
levelLabel.Layout.Column = 3;

trustLabel = makeHeaderLabel(header, "TRUST --%", colors.text);
trustLabel.Layout.Column = 4;

validationLabel = makeHeaderLabel(header, "VAL --%", colors.text);
validationLabel.Layout.Column = 5;

gameAxes = uiaxes(left);
gameAxes.Layout.Row = 2;
gameAxes.Layout.Column = 1;
styleAxes(gameAxes, colors.bg);

timelineAxes = uiaxes(left);
timelineAxes.Layout.Row = 3;
timelineAxes.Layout.Column = 1;
styleAxes(timelineAxes, colors.bg);

side = uigridlayout(root, [6 1]);
side.Layout.Row = 1;
side.Layout.Column = 2;
side.RowHeight = {50, 238, 120, 178, "1x", 54};
side.Padding = [0 0 0 0];
side.RowSpacing = 8;
side.BackgroundColor = colors.bg;

statusLabel = uilabel(side, ...
    "Text", "LOADING", ...
    "HorizontalAlignment", "center", ...
    "FontName", "Courier New", ...
    "FontWeight", "bold", ...
    "FontSize", 22, ...
    "FontColor", colors.yellow, ...
    "BackgroundColor", colors.panel);
statusLabel.Layout.Row = 1;
statusLabel.Layout.Column = 1;

metricsPanel = makePanel(side, "SESSION METRICS");
metricsPanel.Layout.Row = 2;
metricGrid = uigridlayout(metricsPanel, [9 2]);
metricGrid.ColumnWidth = {150, "1x"};
metricGrid.RowHeight = repmat({19}, 1, 9);
metricGrid.Padding = [12 16 12 10];
metricGrid.RowSpacing = 2;
metricGrid.ColumnSpacing = 8;
metricGrid.BackgroundColor = colors.panel;

metricLabels.quality = addMetricRow(metricGrid, "QUALITY", 1);
metricLabels.fatigue = addMetricRow(metricGrid, "FATIGUE", 2);
metricLabels.confidence = addMetricRow(metricGrid, "CONFIDENCE", 3);
metricLabels.current = addMetricRow(metricGrid, "CURRENT", 4);
metricLabels.sport = addMetricRow(metricGrid, "SPORT", 5);
metricLabels.steps = addMetricRow(metricGrid, "STEPS", 6);
metricLabels.distance = addMetricRow(metricGrid, "DISTANCE", 7);
metricLabels.cadence = addMetricRow(metricGrid, "CADENCE", 8);
metricLabels.calories = addMetricRow(metricGrid, "CALORIES", 9);

activityPanel = makePanel(side, "ACTIVITY + CALORIES");
activityPanel.Layout.Row = 3;
activityGrid = uigridlayout(activityPanel, [1 1]);
activityGrid.Padding = [8 18 8 8];
activityGrid.BackgroundColor = colors.panel;
activityAxes = uiaxes(activityGrid);
activityAxes.Layout.Row = 1;
activityAxes.Layout.Column = 1;
styleAxes(activityAxes, colors.panel);

taskPanel = makePanel(side, "LIVE TASKS");
taskPanel.Layout.Row = 4;
taskGrid = uigridlayout(taskPanel, [6 2]);
taskGrid.ColumnWidth = {112, "1x"};
taskGrid.RowHeight = {22, 22, 22, 22, 30, "1x"};
taskGrid.Padding = [10 16 10 8];
taskGrid.RowSpacing = 3;
taskGrid.ColumnSpacing = 8;
taskGrid.BackgroundColor = colors.panel;

addTaskText(taskGrid, "ACTIVITY", 1);
taskActivityDrop = uidropdown(taskGrid, ...
    "Items", ["any", "walk", "run"], ...
    "Value", "walk", ...
    "FontName", "Courier New", ...
    "FontSize", 12, ...
    "FontColor", colors.white, ...
    "BackgroundColor", [0 0 0]);
taskActivityDrop.Layout.Row = 1;
taskActivityDrop.Layout.Column = 2;

taskMinutesField = addTaskNumber(taskGrid, "MIN TARGET", 2, 2);
taskCaloriesField = addTaskNumber(taskGrid, "KCAL TARGET", 20, 3);
taskStepsField = addTaskNumber(taskGrid, "STEP TARGET", 300, 4);

taskButtonGrid = uigridlayout(taskGrid, [1 3]);
taskButtonGrid.Layout.Row = 5;
taskButtonGrid.Layout.Column = [1 2];
taskButtonGrid.ColumnWidth = {"1x", "1x", "1x"};
taskButtonGrid.Padding = [0 0 0 0];
taskButtonGrid.ColumnSpacing = 6;
taskButtonGrid.BackgroundColor = colors.panel;

startTaskButton = makePixelButton(taskButtonGrid, "START", colors.green, [0 0 0]);
startTaskButton.Layout.Column = 1;
startTaskButton.ButtonPushedFcn = @startTask;

endTaskButton = makePixelButton(taskButtonGrid, "END", colors.orange, [0 0 0]);
endTaskButton.Layout.Column = 2;
endTaskButton.ButtonPushedFcn = @endTask;

resetTaskButton = makePixelButton(taskButtonGrid, "RESET", colors.red, colors.white);
resetTaskButton.Layout.Column = 3;
resetTaskButton.ButtonPushedFcn = @resetTask;

taskStatusLabel = uilabel(taskGrid, ...
    "Text", "Set a live task and press START.", ...
    "FontName", "Courier New", ...
    "FontWeight", "bold", ...
    "FontSize", 11, ...
    "FontColor", colors.white, ...
    "BackgroundColor", colors.panel, ...
    "VerticalAlignment", "top", ...
    "WordWrap", "on");
taskStatusLabel.Layout.Row = 6;
taskStatusLabel.Layout.Column = [1 2];

logPanel = makePanel(side, "DEMO NARRATIVE");
logPanel.Layout.Row = 5;
logGrid = uigridlayout(logPanel, [1 1]);
logGrid.Padding = [12 18 12 12];
logGrid.BackgroundColor = colors.panel;
logLabel = uilabel(logGrid, ...
    "Text", "", ...
    "FontName", "Courier New", ...
    "FontSize", 11, ...
    "FontColor", colors.white, ...
    "BackgroundColor", colors.panel, ...
    "VerticalAlignment", "top", ...
    "WordWrap", "on");
logLabel.Layout.Row = 1;
logLabel.Layout.Column = 1;

buttonGrid = uigridlayout(side, [1 4]);
buttonGrid.Layout.Row = 6;
buttonGrid.Layout.Column = 1;
buttonGrid.ColumnWidth = {"1x", "1x", "1x", "1x"};
buttonGrid.Padding = [0 0 0 0];
buttonGrid.ColumnSpacing = 8;
buttonGrid.BackgroundColor = colors.bg;

refreshButton = makePixelButton(buttonGrid, "REFRESH", colors.yellow, [0 0 0]);
refreshButton.Layout.Column = 1;
refreshButton.ButtonPushedFcn = @refreshCurrent;

exampleButton = makePixelButton(buttonGrid, "EXAMPLE", colors.ghost2, [0 0 0]);
exampleButton.Layout.Column = 2;
exampleButton.ButtonPushedFcn = @loadExample;

syntheticButton = makePixelButton(buttonGrid, "SYNTH", colors.red, colors.white);
syntheticButton.Layout.Column = 3;
syntheticButton.ButtonPushedFcn = @loadSynthetic;

liveButton = makePixelButton(buttonGrid, "LIVE", colors.green, [0 0 0]);
liveButton.Layout.Column = 4;
liveButton.ButtonPushedFcn = @loadLive;

drawAll();
configureRefreshTimer();

    function label = addMetricRow(parent, name, row)
        nameLabel = uilabel(parent, ...
            "Text", name, ...
            "FontName", "Courier New", ...
            "FontWeight", "bold", ...
            "FontSize", 13, ...
            "FontColor", colors.text, ...
            "BackgroundColor", colors.panel);
        nameLabel.Layout.Row = row;
        nameLabel.Layout.Column = 1;

        label = uilabel(parent, ...
            "Text", "--", ...
            "HorizontalAlignment", "right", ...
            "FontName", "Courier New", ...
            "FontWeight", "bold", ...
            "FontSize", 13, ...
            "FontColor", colors.white, ...
            "BackgroundColor", colors.panel);
        label.Layout.Row = row;
        label.Layout.Column = 2;
    end

    function addTaskText(parent, textValue, row)
        label = uilabel(parent, ...
            "Text", textValue, ...
            "FontName", "Courier New", ...
            "FontWeight", "bold", ...
            "FontSize", 11, ...
            "FontColor", colors.text, ...
            "BackgroundColor", colors.panel);
        label.Layout.Row = row;
        label.Layout.Column = 1;
    end

    function field = addTaskNumber(parent, labelText, value, row)
        addTaskText(parent, labelText, row);
        field = uieditfield(parent, "numeric", ...
            "Value", value, ...
            "Limits", [0 Inf], ...
            "RoundFractionalValues", "off", ...
            "FontName", "Courier New", ...
            "FontWeight", "bold", ...
            "FontSize", 11, ...
            "FontColor", colors.white, ...
            "BackgroundColor", [0 0 0]);
        field.Layout.Row = row;
        field.Layout.Column = 2;
    end

    function refreshCurrent(varargin)
        state.bundle = loadPeyManUiMetrics(state.bundle.outputDir);
        drawAll();
    end

    function loadExample(varargin)
        state.bundle = loadPeyManUiMetrics(defaultOutputDir("example_file"));
        drawAll();
    end

    function loadSynthetic(varargin)
        state.bundle = loadPeyManUiMetrics(defaultOutputDir("synthetic"));
        drawAll();
    end

    function loadLive(varargin)
        state.bundle = loadPeyManUiMetrics(defaultOutputDir("live"));
        drawAll();
    end

    function startTask(varargin)
        state.task = defaultTaskState();
        state.task.activity = string(taskActivityDrop.Value);
        state.task.targetMinutes = max(0, taskMinutesField.Value);
        state.task.targetCalories = max(0, taskCaloriesField.Value);
        state.task.targetSteps = max(0, taskStepsField.Value);
        state.task.baseline = currentTaskSnapshot(state.task.activity);
        state.task.active = true;
        state.task.startedAt = datetime("now", "Format", "HH:mm:ss");
        drawAll();
    end

    function endTask(varargin)
        if ~state.task.active && ~state.task.completed && ~state.task.failed
            drawAll();
            return;
        elseif ~state.task.active && ~state.task.completed
            state.task.ended = true;
            state.task.failed = true;
        else
            view = evaluateTaskView();
            state.task.ended = true;
            state.task.active = false;
            state.task.completed = view.complete;
            state.task.failed = ~view.complete;
        end
        drawAll();
    end

    function resetTask(varargin)
        state.task = defaultTaskState();
        drawAll();
    end

    function drawAll()
        quality = metricNumber("workoutQualityScore", 0);
        fatigue = metricNumber("fatigueIndex", 0);
        confidence = metricNumber("confidenceIndex", 0);
        validationAcc = metricNumber("validationAccuracy", metricNumber("modelValidationAccuracy", NaN));
        score = round(quality * 1000 + confidence * 100);
        isLiveSource = metricText("sourceKind", "") == "live_mobile_stream";
        currentActivity = upper(char(metricText("currentActivity", "N/A")));
        state.taskView = evaluateTaskView();
        if state.task.active && state.taskView.complete
            state.task.active = false;
            state.task.ended = true;
            state.task.completed = true;
            state.task.failed = false;
            state.taskView = evaluateTaskView();
        end

        scoreLabel.Text = sprintf("SCORE %06d", score);
        levelLabel.Text = sprintf("LEVEL %02d", max(1, ceil(max(quality, 1) / 20)));
        trustLabel.Text = sprintf("TRUST %.0f%%", confidence);
        if isnan(validationAcc)
            validationLabel.Text = "VAL --%";
        else
            validationLabel.Text = sprintf("VAL %.0f%%", validationAcc * 100);
        end

        if ~state.bundle.hasMetrics || ~metricAvailable("workoutQualityScore")
            statusLabel.Text = "NO DATA";
            statusLabel.FontColor = colors.red;
        elseif state.taskView.completed
            statusLabel.Text = "TASK CLEAR";
            statusLabel.FontColor = colors.green;
        elseif state.taskView.failed
            statusLabel.Text = "TASK MISS";
            statusLabel.FontColor = colors.red;
        elseif state.taskView.active
            statusLabel.Text = sprintf("TASK %.0f%%", state.taskView.progress);
            statusLabel.FontColor = colors.ghost2;
        elseif fatigue >= 70
            statusLabel.Text = "FATIGUE!";
            statusLabel.FontColor = colors.red;
        elseif isLiveSource && metricAvailable("currentActivity")
            statusLabel.Text = "LIVE " + currentActivity;
            statusLabel.FontColor = colors.ghost2;
        elseif quality >= 75
            statusLabel.Text = "POWER RUN";
            statusLabel.FontColor = colors.green;
        else
            statusLabel.Text = "MODEL READY";
            statusLabel.FontColor = colors.yellow;
        end

        metricLabels.quality.Text = char(metricDisplayNumber("workoutQualityScore", "%.1f / 100"));
        metricLabels.fatigue.Text = char(metricDisplayNumber("fatigueIndex", "%.1f / 100"));
        metricLabels.confidence.Text = char(metricDisplayNumber("confidenceIndex", "%.1f %%"));
        metricLabels.current.Text = char(metricDisplayText("currentActivity"));
        metricLabels.sport.Text = char(metricDisplayText("detectedSport"));
        metricLabels.steps.Text = char(metricDisplayNumber("stepCount", "%.0f"));
        metricLabels.distance.Text = char(metricDisplayNumber("distanceKm", "%.2f km"));
        metricLabels.cadence.Text = char(metricDisplayNumber("cadenceSpm", "%.1f spm"));
        metricLabels.calories.Text = char(metricDisplayNumber("estimatedCalories", "%.1f kcal"));
        taskStatusLabel.Text = composeTaskStatus(state.taskView);

        logLabel.Text = composeNarrative();
        drawGame();
        drawTimeline();
        drawActivity();
    end

    function snapshot = currentTaskSnapshot(activity)
        if nargin < 1
            activity = string(taskActivityDrop.Value);
        end
        snapshot = struct();
        snapshot.steps = metricNumber("stepCount", 0);
        snapshot.calories = metricNumber("estimatedCalories", 0);
        snapshot.activeMinutes = metricNumber("activeMinutes", 0);
        snapshot.activityMinutes = activityMinutesFor(activity);
        snapshot.currentActivity = metricText("currentActivity", "unknown");
    end

    function minutes = activityMinutesFor(activity)
        activity = string(activity);
        if activity == "any"
            minutes = metricNumber("activeMinutes", 0);
            return;
        end

        minutes = 0;
        tbl = state.bundle.caloriesByActivity;
        if ~state.bundle.hasMetrics || height(tbl) == 0 || ...
                ~all(ismember(["activity", "minutes"], string(tbl.Properties.VariableNames)))
            return;
        end

        mask = string(tbl.activity) == activity;
        if any(mask)
            minutes = sum(tbl.minutes(mask), "omitnan");
        end
    end

    function view = evaluateTaskView()
        view = defaultTaskView();
        view.activity = state.task.activity;
        if ~state.task.active && ~state.task.ended && ~state.task.completed && ~state.task.failed
            return;
        end

        view.active = state.task.active;
        view.completed = state.task.completed;
        view.failed = state.task.failed;
        view.ended = state.task.ended;

        nowSnapshot = currentTaskSnapshot(state.task.activity);
        requiredActivity = state.task.activity;
        if requiredActivity == "any"
            minutesDone = max(0, nowSnapshot.activeMinutes - state.task.baseline.activeMinutes);
        else
            minutesDone = max(0, nowSnapshot.activityMinutes - state.task.baseline.activityMinutes);
        end
        caloriesDone = max(0, nowSnapshot.calories - state.task.baseline.calories);
        stepsDone = max(0, nowSnapshot.steps - state.task.baseline.steps);

        minuteRatio = ratioOrComplete(minutesDone, state.task.targetMinutes);
        calorieRatio = ratioOrComplete(caloriesDone, state.task.targetCalories);
        stepRatio = ratioOrComplete(stepsDone, state.task.targetSteps);
        targetCount = enabledTaskTargetCount();

        if targetCount == 0
            progress = double(requiredActivity == "any" || nowSnapshot.currentActivity == requiredActivity) * 100;
        else
            progress = 100 * mean([minuteRatio calorieRatio stepRatio]);
        end
        progress = clampValue(progress, 0, 100);

        minuteOk = state.task.targetMinutes <= 0 || minutesDone >= state.task.targetMinutes;
        calorieOk = state.task.targetCalories <= 0 || caloriesDone >= state.task.targetCalories;
        stepOk = state.task.targetSteps <= 0 || stepsDone >= state.task.targetSteps;
        activityOk = requiredActivity == "any" || nowSnapshot.currentActivity == requiredActivity || minutesDone > 0;
        complete = minuteOk && calorieOk && stepOk && activityOk && targetCount > 0;

        if state.task.completed
            complete = true;
            progress = 100;
        elseif state.task.failed
            complete = false;
            progress = max(0, progress - 35);
        end

        view.progress = round(progress, 1);
        view.complete = complete;
        view.completed = state.task.completed || complete;
        view.failed = state.task.failed;
        view.minutesDone = round(minutesDone, 2);
        view.caloriesDone = round(caloriesDone, 1);
        view.stepsDone = round(stepsDone);
        view.currentActivity = nowSnapshot.currentActivity;
        view.activityMatch = activityOk;
    end

    function ratio = ratioOrComplete(value, target)
        if target <= 0
            ratio = 1;
        else
            ratio = min(max(value / target, 0), 1);
        end
    end

    function count = enabledTaskTargetCount()
        count = double(state.task.targetMinutes > 0) + ...
            double(state.task.targetCalories > 0) + ...
            double(state.task.targetSteps > 0);
    end

    function textValue = composeTaskStatus(view)
        if ~view.active && ~view.ended && ~view.completed && ~view.failed
            textValue = "Set activity, minutes, calories, or steps. START locks current live metrics as baseline.";
            return;
        end

        if view.completed
            stateText = "CLEAR";
        elseif view.failed
            stateText = "MISSED";
        elseif view.active
            stateText = "ACTIVE";
        else
            stateText = "ENDED";
        end

        matchText = "MATCH";
        if ~view.activityMatch
            matchText = "NO MATCH";
        end

        textValue = sprintf([ ...
            '%s %s | %.0f%% | NOW %s (%s)\n' ...
            'MIN %.1f/%.1f | KCAL %.1f/%.1f | STEP %.0f/%.0f'], ...
            upper(char(state.task.activity)), stateText, view.progress, ...
            upper(char(view.currentActivity)), matchText, ...
            view.minutesDone, state.task.targetMinutes, ...
            view.caloriesDone, state.task.targetCalories, ...
            view.stepsDone, state.task.targetSteps);
    end

    function textValue = composeNarrative()
        if ~state.bundle.hasMetrics || ~metricAvailable("workoutQualityScore")
            textValue = sprintf("%s\n\nRun main, runSyntheticFatigueDemo, or load a session output folder.", ...
                char(state.bundle.statusMessage));
            return;
        end

        coachText = metricText("coachAdvice", "");
        sourceText = metricText("coachAdviceSource", "template");
        modelType = metricText("modelType", "unknown");
        modelRows = metricNumber("modelTrainingRows", 0);
        modelAcc = metricNumber("modelTrainingAccuracy", NaN);
        validationAcc = metricNumber("validationAccuracy", metricNumber("modelValidationAccuracy", NaN));
        validationRows = metricNumber("validationRows", metricNumber("modelValidationRows", 0));
        sourceKind = metricText("sourceKind", "mat_file");
        currentActivity = metricText("currentActivity", "unknown");
        if strlength(coachText) == 0
            coachText = "Coach advice unavailable.";
        end
        coachText = truncateText(coachText, 95);

        if ~isnan(validationAcc) && validationRows > 0
            modelLine = sprintf("MODEL %s | VAL %.0f ROWS | ACC %.1f%%", ...
                upper(char(modelType)), validationRows, validationAcc * 100);
        elseif isnan(modelAcc)
            modelLine = sprintf("MODEL %s | TRAINING ROWS %.0f", upper(char(modelType)), modelRows);
        else
            modelLine = sprintf("MODEL %s | TRAIN %.0f ROWS | ACC %.1f%%", ...
                upper(char(modelType)), modelRows, modelAcc * 100);
        end

        textValue = sprintf([ ...
            '%s\n' ...
            'QUALITY %.1f | FATIGUE %.1f | TRUST %.1f%%\n' ...
            '%s | NOW %s | %.0f steps, %.2f km, %.1f kcal.\n' ...
            'FLOW: sensors -> ML -> fatigue -> game progress.\n' ...
            'SOURCE: %s\n' ...
            'COACH (%s): %s'], ...
            modelLine, ...
            metricNumber("workoutQualityScore", 0), ...
            metricNumber("fatigueIndex", 0), ...
            metricNumber("confidenceIndex", 0), ...
            char(metricText("detectedSport", "Session")), ...
            upper(char(currentActivity)), ...
            metricNumber("stepCount", 0), ...
            metricNumber("distanceKm", 0), ...
            metricNumber("estimatedCalories", 0), ...
            upper(char(sourceKind)), ...
            char(sourceText), char(coachText));
    end

    function drawGame()
        quality = metricNumber("workoutQualityScore", 0);
        fatigue = metricNumber("fatigueIndex", 0);
        confidence = metricNumber("confidenceIndex", 0);
        calories = metricNumber("estimatedCalories", 0);
        sport = metricText("detectedSport", "SESSION");
        progress = min(max(quality, 0), 100);
        danger = min(max(fatigue, 0), 100);
        titleText = "DAILY MAZE MODE";
        titleColor = colors.pellet;

        if state.taskView.active || state.taskView.ended || state.taskView.completed || state.taskView.failed
            progress = state.taskView.progress;
            titleText = "LIVE TASK MAZE";
            titleColor = colors.ghost2;
            if state.taskView.completed
                progress = 100;
                danger = min(danger, 20);
                titleText = "TASK CLEAR";
                titleColor = colors.green;
            elseif state.taskView.failed
                progress = max(0, min(progress, 18));
                danger = 92;
                titleText = "TASK MISSED";
                titleColor = colors.red;
            end
        end

        cla(gameAxes);
        hold(gameAxes, "on");
        gameAxes.Color = colors.bg;
        xlim(gameAxes, [0 36]);
        ylim(gameAxes, [0 23]);

        drawMazeFrame();
        drawPellets(progress);

        laneStart = 4;
        laneEnd = 27;
        pacX = laneStart + (laneEnd - laneStart) * progress / 100;
        pacY = 10.3;
        ghostX = 31 - 14 * danger / 100;
        ghostX = max(pacX + 3.2, ghostX);
        ghostX = min(ghostX, 31);

        if danger >= 70
            drawPixelGhost(gameAxes, ghostX, pacY, colors.red, 0.36);
            if state.taskView.failed
                dangerText = titleText;
            else
                dangerText = "FATIGUE CHASE";
            end
            text(gameAxes, 13.2, 18.6, dangerText, ...
                "FontName", "Courier New", "FontWeight", "bold", ...
                "FontSize", 18, "Color", colors.red);
        else
            drawPixelGhost(gameAxes, ghostX, pacY, colors.ghost, 0.36);
            text(gameAxes, 11.6, 18.6, titleText, ...
                "FontName", "Courier New", "FontWeight", "bold", ...
                "FontSize", 18, "Color", titleColor);
        end

        drawPixelPacman(gameAxes, pacX, pacY, colors.yellow, 0.38);
        drawFruit(calories);

        text(gameAxes, 3.1, 2.1, sprintf("QUALITY %.0f%%", progress), ...
            "FontName", "Courier New", "FontWeight", "bold", ...
            "FontSize", 14, "Color", scoreColor(progress, false));
        text(gameAxes, 17.0, 2.1, sprintf("SENSOR TRUST %.0f%%", confidence), ...
            "FontName", "Courier New", "FontWeight", "bold", ...
            "FontSize", 14, "Color", scoreColor(confidence, false));
        text(gameAxes, 3.1, 20.9, upper(char(sport)), ...
            "FontName", "Courier New", "FontWeight", "bold", ...
            "FontSize", 13, "Color", colors.muted);
        if state.taskView.active || state.taskView.ended || state.taskView.completed || state.taskView.failed
            text(gameAxes, 22.0, 20.9, sprintf("TASK %.0f%%", state.taskView.progress), ...
                "FontName", "Courier New", "FontWeight", "bold", ...
                "FontSize", 13, "Color", titleColor);
        end

        hold(gameAxes, "off");
    end

    function drawTimeline()
        cla(timelineAxes);
        hold(timelineAxes, "on");
        timelineAxes.Color = colors.panel2;
        timelineAxes.XColor = colors.text;
        timelineAxes.YColor = colors.text;
        timelineAxes.FontName = "Courier New";
        timelineAxes.FontWeight = "bold";
        timelineAxes.Box = "on";
        timelineAxes.LineWidth = 1;
        title(timelineAxes, "FATIGUE INDEX TIMELINE", "Color", colors.text, "FontName", "Courier New");
        xlabel(timelineAxes, "Minute", "Color", colors.text);
        ylabel(timelineAxes, "FI", "Color", colors.text);
        ylim(timelineAxes, [0 100]);

        tbl = state.bundle.fatigueTimeline;
        if state.bundle.hasMetrics && height(tbl) > 0 && all(ismember(["minute", "FatigueIndex"], string(tbl.Properties.VariableNames)))
            x = tbl.minute;
            y = tbl.FatigueIndex;
            xMin = min(x);
            xMax = max(x);
            if xMax <= xMin
                xMax = xMin + 1;
            end
            rectangle(timelineAxes, "Position", [xMin 0 xMax - xMin 30], ...
                "FaceColor", [0.03 0.18 0.08], "EdgeColor", "none");
            rectangle(timelineAxes, "Position", [xMin 30 xMax - xMin 40], ...
                "FaceColor", [0.24 0.16 0.03], "EdgeColor", "none");
            rectangle(timelineAxes, "Position", [xMin 70 xMax - xMin 30], ...
                "FaceColor", [0.22 0.02 0.04], "EdgeColor", "none");
            plot(timelineAxes, x, y, "Color", colors.yellow, "LineWidth", 2.5);
            [peakValue, idx] = max(y);
            plot(timelineAxes, x(idx), peakValue, "o", ...
                "MarkerFaceColor", colors.red, "MarkerEdgeColor", colors.white, "MarkerSize", 7);
            text(timelineAxes, x(idx), min(95, peakValue + 8), sprintf("PEAK %.0f", peakValue), ...
                "FontName", "Courier New", "FontWeight", "bold", ...
                "FontSize", 11, "Color", colors.white);
            xlim(timelineAxes, [xMin xMax]);
            grid(timelineAxes, "on");
        else
            text(timelineAxes, 0.5, 50, "RUN PIPELINE TO LOAD TIMELINE", ...
                "HorizontalAlignment", "center", ...
                "FontName", "Courier New", "FontWeight", "bold", ...
                "FontSize", 14, "Color", colors.red);
            xlim(timelineAxes, [0 1]);
        end
        hold(timelineAxes, "off");
    end

    function drawActivity()
        cla(activityAxes);
        hold(activityAxes, "on");
        activityAxes.Color = colors.panel;
        activityAxes.XColor = colors.text;
        activityAxes.YColor = colors.text;
        activityAxes.FontName = "Courier New";
        activityAxes.FontWeight = "bold";

        tbl = state.bundle.caloriesByActivity;
        if state.bundle.hasMetrics && height(tbl) > 0 && all(ismember(["activity", "minutes"], string(tbl.Properties.VariableNames)))
            labels = string(tbl.activity);
            minutes = tbl.minutes;
            if ismember("calories", string(tbl.Properties.VariableNames))
                values = tbl.calories;
                title(activityAxes, "KCAL BY ACTIVITY", "Color", colors.text, "FontName", "Courier New");
                xText = "kcal";
            else
                values = minutes;
                title(activityAxes, "MINUTES BY ACTIVITY", "Color", colors.text, "FontName", "Courier New");
                xText = "min";
            end
            keep = minutes > 0 | values > 0;
            labels = labels(keep);
            values = values(keep);
            if isempty(values)
                labels = "none";
                values = 0;
            end
            barh(activityAxes, categorical(labels), values, "FaceColor", colors.yellow, "EdgeColor", colors.wallGlow);
            xlabel(activityAxes, xText, "Color", colors.text);
            grid(activityAxes, "on");
        else
            text(activityAxes, 0.5, 0.5, "NO ACTIVITY CSV", ...
                "HorizontalAlignment", "center", ...
                "FontName", "Courier New", "FontWeight", "bold", ...
                "FontSize", 13, "Color", colors.red);
            xlim(activityAxes, [0 1]);
            ylim(activityAxes, [0 1]);
        end
        hold(activityAxes, "off");
    end

    function drawMazeFrame()
        drawWall(1, 1, 34, 1);
        drawWall(1, 21, 34, 1);
        drawWall(1, 1, 1, 21);
        drawWall(34, 1, 1, 21);
        drawWall(4, 4, 7, 1);
        drawWall(14, 4, 8, 1);
        drawWall(25, 4, 6, 1);
        drawWall(4, 17, 7, 1);
        drawWall(14, 17, 8, 1);
        drawWall(25, 17, 6, 1);
        drawWall(7, 6, 1, 5);
        drawWall(28, 6, 1, 5);
        drawWall(7, 12, 1, 4);
        drawWall(28, 12, 1, 4);
        drawWall(13, 7, 2, 3);
        drawWall(21, 7, 2, 3);
        drawWall(13, 13, 2, 3);
        drawWall(21, 13, 2, 3);
        drawWall(16, 9, 4, 1);
        drawWall(16, 13, 4, 1);
    end

    function drawWall(x, y, w, h)
        rectangle(gameAxes, ...
            "Position", [x y w h], ...
            "FaceColor", colors.wall, ...
            "EdgeColor", colors.wallGlow, ...
            "LineWidth", 1.2);
    end

    function drawPellets(progress)
        pelletXs = 5:1.6:29;
        collectedCount = floor(numel(pelletXs) * progress / 100);
        for i = 1:numel(pelletXs)
            if i <= collectedCount
                pelletColor = [0.08 0.08 0.12];
            else
                pelletColor = colors.pellet;
            end
            rectangle(gameAxes, ...
                "Position", [pelletXs(i) 11.25 0.30 0.30], ...
                "FaceColor", pelletColor, ...
                "EdgeColor", pelletColor);
        end
    end

    function drawFruit(calories)
        if calories <= 0
            return;
        end
        fruitScale = min(1.4, max(0.7, calories / 30));
        rectangle(gameAxes, ...
            "Position", [30.1 5.2 0.9 * fruitScale 0.9 * fruitScale], ...
            "Curvature", [1 1], ...
            "FaceColor", colors.red, ...
            "EdgeColor", colors.pellet, ...
            "LineWidth", 1.2);
        rectangle(gameAxes, ...
            "Position", [30.6 6.1 0.32 0.20], ...
            "FaceColor", colors.green, ...
            "EdgeColor", colors.green);
        text(gameAxes, 28.7, 4.1, sprintf("%.0f KCAL", calories), ...
            "FontName", "Courier New", "FontWeight", "bold", ...
            "FontSize", 11, "Color", colors.text);
    end

    function value = metricNumber(name, defaultValue)
        value = defaultValue;
        if metricAvailable(name)
            raw = state.bundle.metrics.(name);
            if isnumeric(raw)
                value = double(raw);
            elseif ischar(raw) || isstring(raw)
                parsed = str2double(string(raw));
                if ~isnan(parsed)
                    value = parsed;
                end
            end
        end
    end

    function value = metricText(name, defaultValue)
        value = string(defaultValue);
        if metricAvailable(name)
            raw = state.bundle.metrics.(name);
            if ischar(raw) || isstring(raw)
                value = string(raw);
            elseif isnumeric(raw)
                value = string(raw);
            end
        end
    end

    function textValue = metricDisplayNumber(name, formatSpec)
        if metricAvailable(name)
            textValue = string(sprintf(formatSpec, metricNumber(name, 0)));
        else
            textValue = "n/a";
        end
    end

    function textValue = metricDisplayText(name)
        if metricAvailable(name)
            textValue = metricText(name, "n/a");
        else
            textValue = "n/a";
        end
    end

    function tf = metricAvailable(name)
        tf = false;
        if ~state.bundle.hasMetrics || ~isfield(state.bundle.metrics, name)
            return;
        end
        raw = state.bundle.metrics.(name);
        if isnumeric(raw)
            tf = ~isempty(raw) && all(isfinite(raw(:)));
        elseif ischar(raw) || isstring(raw)
            tf = strlength(string(raw)) > 0 && string(raw) ~= "n/a";
        else
            tf = ~isempty(raw);
        end
    end

    function outputDir = defaultOutputDir(name)
        thisDir = fileparts(mfilename("fullpath"));
        projectRoot = fileparts(fileparts(thisDir));
        outputDir = fullfile(projectRoot, "outputs", name);
    end

    function configureRefreshTimer()
        if state.autoRefreshSeconds <= 0
            return;
        end
        state.refreshTimer = timer( ...
            "ExecutionMode", "fixedSpacing", ...
            "BusyMode", "drop", ...
            "Period", state.autoRefreshSeconds, ...
            "TimerFcn", @safeAutoRefresh);
        fig.CloseRequestFcn = @closeFigure;
        start(state.refreshTimer);
    end

    function safeAutoRefresh(varargin)
        if ~isvalid(fig)
            return;
        end
        try
            refreshCurrent();
            drawnow limitrate nocallbacks;
        catch
        end
    end

    function closeFigure(varargin)
        if ~isempty(state.refreshTimer) && isvalid(state.refreshTimer)
            stop(state.refreshTimer);
            delete(state.refreshTimer);
        end
        delete(fig);
    end

    function color = scoreColor(value, inverse)
        if nargin < 2
            inverse = false;
        end
        if inverse
            value = 100 - value;
        end
        if value >= 75
            color = colors.green;
        elseif value >= 45
            color = colors.orange;
        else
            color = colors.red;
        end
    end

    function drawPixelPacman(ax, x, y, color, scale)
        pattern = {
            "0011110"
            "0111111"
            "1111100"
            "1111000"
            "1111100"
            "0111111"
            "0011110"
        };
        drawPixelShape(ax, pattern, x, y, color, scale);
        rectangle(ax, ...
            "Position", [x + 4.3 * scale y + 4.6 * scale scale scale], ...
            "FaceColor", [0 0 0], ...
            "EdgeColor", [0 0 0]);
    end

    function drawPixelGhost(ax, x, y, color, scale)
        pattern = {
            "0111110"
            "1111111"
            "1011101"
            "1111111"
            "1111111"
            "1101011"
            "1001001"
        };
        drawPixelShape(ax, pattern, x, y, color, scale);
        rectangle(ax, ...
            "Position", [x + 1.8 * scale y + 4.6 * scale 0.9 * scale 0.9 * scale], ...
            "FaceColor", [0 0 0], ...
            "EdgeColor", [0 0 0]);
        rectangle(ax, ...
            "Position", [x + 4.4 * scale y + 4.6 * scale 0.9 * scale 0.9 * scale], ...
            "FaceColor", [0 0 0], ...
            "EdgeColor", [0 0 0]);
    end
end

function textValue = truncateText(textValue, maxChars)
textValue = string(textValue);
if strlength(textValue) > maxChars
    textValue = extractBefore(textValue, maxChars - 2) + "...";
end
end

function task = defaultTaskState()
task = struct();
task.activity = "walk";
task.targetMinutes = 0;
task.targetCalories = 0;
task.targetSteps = 0;
task.baseline = struct("steps", 0, "calories", 0, "activeMinutes", 0, ...
    "activityMinutes", 0, "currentActivity", "unknown");
task.active = false;
task.ended = false;
task.completed = false;
task.failed = false;
task.startedAt = "";
end

function view = defaultTaskView()
view = struct();
view.activity = "walk";
view.active = false;
view.ended = false;
view.completed = false;
view.failed = false;
view.complete = false;
view.progress = 0;
view.minutesDone = 0;
view.caloriesDone = 0;
view.stepsDone = 0;
view.currentActivity = "unknown";
view.activityMatch = false;
end

function value = getUiOption(options, name, defaultValue)
if isfield(options, name)
    value = options.(name);
else
    value = defaultValue;
end
end

function panel = makePanel(parent, titleValue)
panel = uipanel(parent, ...
    "Title", titleValue, ...
    "FontName", "Courier New", ...
    "FontWeight", "bold", ...
    "FontSize", 13, ...
    "ForegroundColor", [1.00 0.95 0.72], ...
    "BackgroundColor", [0.03 0.04 0.13]);
end

function label = makeHeaderLabel(parent, textValue, colorValue)
label = uilabel(parent, ...
    "Text", textValue, ...
    "HorizontalAlignment", "center", ...
    "FontName", "Courier New", ...
    "FontWeight", "bold", ...
    "FontSize", 17, ...
    "FontColor", colorValue, ...
    "BackgroundColor", [0.03 0.04 0.13]);
label.Layout.Row = 1;
end

function button = makePixelButton(parent, textValue, bgColor, fontColor)
button = uibutton(parent, "push", ...
    "Text", textValue, ...
    "FontName", "Courier New", ...
    "FontWeight", "bold", ...
    "FontSize", 12, ...
    "BackgroundColor", bgColor, ...
    "FontColor", fontColor);
button.Layout.Row = 1;
end

function styleAxes(ax, bgColor)
ax.Color = bgColor;
ax.XColor = bgColor;
ax.YColor = bgColor;
ax.Box = "off";
try
    ax.Toolbar.Visible = "off";
catch
end
ax.XTick = [];
ax.YTick = [];
axis(ax, "manual");
end

function drawPixelShape(ax, pattern, x0, y0, color, scale)
rowCount = numel(pattern);
for row = 1:rowCount
    line = char(pattern{row});
    for col = 1:numel(line)
        if line(col) == '1'
            px = x0 + (col - 1) * scale;
            py = y0 + (rowCount - row) * scale;
            rectangle(ax, ...
                "Position", [px py scale scale], ...
                "FaceColor", color, ...
                "EdgeColor", color);
        end
    end
end
end
