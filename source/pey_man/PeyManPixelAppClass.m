classdef PeyManPixelAppClass < handle
    %PEYMANPIXELAPPCLASS Object-Oriented MATLAB-only Pac-Man fitness UI.
    %
    % This class manages the figure layout, graphics rendering, background refresh
    % timers, and callbacks, separating presentation from core calculations.
    
    properties
        Figure         % Native MATLAB uifigure handle
    end
    
    properties (Access = private)
        State          % Struct storing metrics bundle, active task state, refresh timer
        Colors         % RGB neon arcade color palette constants
        Widgets        % Struct to store UI component handles
        Axes           % Struct to store axes handles (game, timeline, activity)
    end
    
    methods
        function obj = PeyManPixelAppClass(metricsSource, uiOptions)
            if nargin < 1
                metricsSource = "";
            end
            if nargin < 2
                uiOptions = struct();
            end
            
            % Initialize State
            obj.State.bundle = loadPeyManUiMetrics(metricsSource);
            obj.State.autoRefreshSeconds = obj.getUiOption(uiOptions, "autoRefreshSeconds", 0);
            obj.State.refreshTimer = [];
            obj.State.task = obj.defaultTaskState();
            obj.State.taskView = obj.defaultTaskView();
            
            % Initialize Color Palette
            obj.Colors.bg = [0.02 0.02 0.08];
            obj.Colors.panel = [0.03 0.04 0.13];
            obj.Colors.panel2 = [0.00 0.01 0.05];
            obj.Colors.wall = [0.00 0.18 0.85];
            obj.Colors.wallGlow = [0.00 0.72 1.00];
            obj.Colors.yellow = [1.00 0.88 0.05];
            obj.Colors.pellet = [1.00 0.92 0.55];
            obj.Colors.ghost = [1.00 0.18 0.38];
            obj.Colors.ghost2 = [0.20 0.85 1.00];
            obj.Colors.white = [0.95 0.95 0.95];
            obj.Colors.green = [0.12 0.90 0.35];
            obj.Colors.orange = [1.00 0.56 0.05];
            obj.Colors.red = [1.00 0.12 0.18];
            obj.Colors.text = [1.00 0.95 0.72];
            obj.Colors.muted = [0.58 0.62 0.78];
            
            % Build Visual Structure
            obj.createLayout();
            
            % Draw Initial Frame
            obj.drawAll();
            
            % Configure Refresh Thread
            obj.configureRefreshTimer();
        end
    end
    
    methods (Access = private)
        function createLayout(obj)
            obj.Figure = uifigure( ...
                "Name", "Pey-Man Fitness Tracker", ...
                "Color", obj.Colors.bg, ...
                "Position", [80 80 1240 760]);
            
            root = uigridlayout(obj.Figure, [1 2]);
            root.ColumnWidth = {"1x", 400};
            root.RowHeight = {"1x"};
            root.Padding = [14 14 14 14];
            root.ColumnSpacing = 14;
            root.BackgroundColor = obj.Colors.bg;
            
            % Left Pane: Title, Game Board, Timeline
            left = uigridlayout(root, [3 1]);
            left.Layout.Row = 1;
            left.Layout.Column = 1;
            left.RowHeight = {64, "1x", 190};
            left.Padding = [0 0 0 0];
            left.RowSpacing = 12;
            left.BackgroundColor = obj.Colors.bg;
            
            header = uigridlayout(left, [1 5]);
            header.Layout.Row = 1;
            header.Layout.Column = 1;
            header.ColumnWidth = {"1x", 145, 145, 145, 145};
            header.Padding = [0 0 0 0];
            header.ColumnSpacing = 10;
            header.BackgroundColor = obj.Colors.bg;
            
            titleLabel = uilabel(header, ...
                "Text", "PEY-MAN", ...
                "FontName", "Courier New", ...
                "FontWeight", "bold", ...
                "FontSize", 38, ...
                "FontColor", obj.Colors.yellow, ...
                "BackgroundColor", obj.Colors.bg);
            titleLabel.Layout.Row = 1;
            titleLabel.Layout.Column = 1;
            
            obj.Widgets.scoreLabel = obj.makeHeaderLabel(header, "SCORE 000000", obj.Colors.text);
            obj.Widgets.scoreLabel.Layout.Column = 2;
            
            obj.Widgets.levelLabel = obj.makeHeaderLabel(header, "LEVEL 01", obj.Colors.text);
            obj.Widgets.levelLabel.Layout.Column = 3;
            
            obj.Widgets.trustLabel = obj.makeHeaderLabel(header, "TRUST --%", obj.Colors.text);
            obj.Widgets.trustLabel.Layout.Column = 4;
            
            obj.Widgets.validationLabel = obj.makeHeaderLabel(header, "VAL --%", obj.Colors.text);
            obj.Widgets.validationLabel.Layout.Column = 5;
            
            obj.Axes.gameAxes = uiaxes(left);
            obj.Axes.gameAxes.Layout.Row = 2;
            obj.Axes.gameAxes.Layout.Column = 1;
            obj.styleAxes(obj.Axes.gameAxes, obj.Colors.bg);
            
            obj.Axes.timelineAxes = uiaxes(left);
            obj.Axes.timelineAxes.Layout.Row = 3;
            obj.Axes.timelineAxes.Layout.Column = 1;
            obj.styleAxes(obj.Axes.timelineAxes, obj.Colors.bg);
            
            % Right Pane: Sidebar & Metrics Panel
            side = uigridlayout(root, [6 1]);
            side.Layout.Row = 1;
            side.Layout.Column = 2;
            side.RowHeight = {50, 238, 120, 178, "1x", 54};
            side.Padding = [0 0 0 0];
            side.RowSpacing = 8;
            side.BackgroundColor = obj.Colors.bg;
            
            obj.Widgets.statusLabel = uilabel(side, ...
                "Text", "LOADING", ...
                "HorizontalAlignment", "center", ...
                "FontName", "Courier New", ...
                "FontWeight", "bold", ...
                "FontSize", 22, ...
                "FontColor", obj.Colors.yellow, ...
                "BackgroundColor", obj.Colors.panel);
            obj.Widgets.statusLabel.Layout.Row = 1;
            obj.Widgets.statusLabel.Layout.Column = 1;
            
            metricsPanel = obj.makePanel(side, "SESSION METRICS");
            metricsPanel.Layout.Row = 2;
            metricGrid = uigridlayout(metricsPanel, [9 2]);
            metricGrid.ColumnWidth = {150, "1x"};
            metricGrid.RowHeight = repmat({19}, 1, 9);
            metricGrid.Padding = [12 16 12 10];
            metricGrid.RowSpacing = 2;
            metricGrid.ColumnSpacing = 8;
            metricGrid.BackgroundColor = obj.Colors.panel;
            
            obj.Widgets.metricLabels.quality = obj.addMetricRow(metricGrid, "QUALITY", 1);
            obj.Widgets.metricLabels.fatigue = obj.addMetricRow(metricGrid, "FATIGUE", 2);
            obj.Widgets.metricLabels.confidence = obj.addMetricRow(metricGrid, "CONFIDENCE", 3);
            obj.Widgets.metricLabels.current = obj.addMetricRow(metricGrid, "CURRENT", 4);
            obj.Widgets.metricLabels.sport = obj.addMetricRow(metricGrid, "SPORT", 5);
            obj.Widgets.metricLabels.steps = obj.addMetricRow(metricGrid, "STEPS", 6);
            obj.Widgets.metricLabels.distance = obj.addMetricRow(metricGrid, "DISTANCE", 7);
            obj.Widgets.metricLabels.cadence = obj.addMetricRow(metricGrid, "CADENCE", 8);
            obj.Widgets.metricLabels.calories = obj.addMetricRow(metricGrid, "CALORIES", 9);
            
            activityPanel = obj.makePanel(side, "ACTIVITY + CALORIES");
            activityPanel.Layout.Row = 3;
            activityGrid = uigridlayout(activityPanel, [1 1]);
            activityGrid.Padding = [8 18 8 8];
            activityGrid.BackgroundColor = obj.Colors.panel;
            obj.Axes.activityAxes = uiaxes(activityGrid);
            obj.Axes.activityAxes.Layout.Row = 1;
            obj.Axes.activityAxes.Layout.Column = 1;
            obj.styleAxes(obj.Axes.activityAxes, obj.Colors.panel);
            
            taskPanel = obj.makePanel(side, "LIVE TASKS");
            taskPanel.Layout.Row = 4;
            taskGrid = uigridlayout(taskPanel, [6 2]);
            taskGrid.ColumnWidth = {112, "1x"};
            taskGrid.RowHeight = {22, 22, 22, 22, 30, "1x"};
            taskGrid.Padding = [10 16 10 8];
            taskGrid.RowSpacing = 3;
            taskGrid.ColumnSpacing = 8;
            taskGrid.BackgroundColor = obj.Colors.panel;
            
            obj.addTaskText(taskGrid, "ACTIVITY", 1);
            obj.Widgets.taskActivityDrop = uidropdown(taskGrid, ...
                "Items", ["any", "walk", "run"], ...
                "Value", "walk", ...
                "FontName", "Courier New", ...
                "FontSize", 12, ...
                "FontColor", obj.Colors.white, ...
                "BackgroundColor", [0 0 0]);
            obj.Widgets.taskActivityDrop.Layout.Row = 1;
            obj.Widgets.taskActivityDrop.Layout.Column = 2;
            
            obj.Widgets.taskMinutesField = obj.addTaskNumber(taskGrid, "MIN TARGET", 2, 2);
            obj.Widgets.taskCaloriesField = obj.addTaskNumber(taskGrid, "KCAL TARGET", 20, 3);
            obj.Widgets.taskStepsField = obj.addTaskNumber(taskGrid, "STEP TARGET", 300, 4);
            
            taskButtonGrid = uigridlayout(taskGrid, [1 3]);
            taskButtonGrid.Layout.Row = 5;
            taskButtonGrid.Layout.Column = [1 2];
            taskButtonGrid.ColumnWidth = {"1x", "1x", "1x"};
            taskButtonGrid.Padding = [0 0 0 0];
            taskButtonGrid.ColumnSpacing = 6;
            taskButtonGrid.BackgroundColor = obj.Colors.panel;
            
            startTaskButton = obj.makePixelButton(taskButtonGrid, "START", obj.Colors.green, [0 0 0]);
            startTaskButton.Layout.Column = 1;
            startTaskButton.ButtonPushedFcn = @(src, event) obj.onStartTask(src, event);
            
            endTaskButton = obj.makePixelButton(taskButtonGrid, "END", obj.Colors.orange, [0 0 0]);
            endTaskButton.Layout.Column = 2;
            endTaskButton.ButtonPushedFcn = @(src, event) obj.onEndTask(src, event);
            
            resetTaskButton = obj.makePixelButton(taskButtonGrid, "RESET", obj.Colors.red, obj.Colors.white);
            resetTaskButton.Layout.Column = 3;
            resetTaskButton.ButtonPushedFcn = @(src, event) obj.onResetTask(src, event);
            
            obj.Widgets.taskStatusLabel = uilabel(taskGrid, ...
                "Text", "Set a live task and press START.", ...
                "FontName", "Courier New", ...
                "FontWeight", "bold", ...
                "FontSize", 11, ...
                "FontColor", obj.Colors.white, ...
                "BackgroundColor", obj.Colors.panel, ...
                "VerticalAlignment", "top", ...
                "WordWrap", "on");
            obj.Widgets.taskStatusLabel.Layout.Row = 6;
            obj.Widgets.taskStatusLabel.Layout.Column = [1 2];
            
            logPanel = obj.makePanel(side, "DEMO NARRATIVE");
            logPanel.Layout.Row = 5;
            logGrid = uigridlayout(logPanel, [1 1]);
            logGrid.Padding = [12 18 12 12];
            logGrid.BackgroundColor = obj.Colors.panel;
            obj.Widgets.logLabel = uilabel(logGrid, ...
                "Text", "", ...
                "FontName", "Courier New", ...
                "FontSize", 11, ...
                "FontColor", obj.Colors.white, ...
                "BackgroundColor", obj.Colors.panel, ...
                "VerticalAlignment", "top", ...
                "WordWrap", "on");
            obj.Widgets.logLabel.Layout.Row = 1;
            obj.Widgets.logLabel.Layout.Column = 1;
            
            buttonGrid = uigridlayout(side, [1 4]);
            buttonGrid.Layout.Row = 6;
            buttonGrid.Layout.Column = 1;
            buttonGrid.ColumnWidth = {"1x", "1x", "1x", "1x"};
            buttonGrid.Padding = [0 0 0 0];
            buttonGrid.ColumnSpacing = 8;
            buttonGrid.BackgroundColor = obj.Colors.bg;
            
            refreshButton = obj.makePixelButton(buttonGrid, "REFRESH", obj.Colors.yellow, [0 0 0]);
            refreshButton.Layout.Column = 1;
            refreshButton.ButtonPushedFcn = @(src, event) obj.onRefreshCurrent(src, event);
            
            exampleButton = obj.makePixelButton(buttonGrid, "EXAMPLE", obj.Colors.ghost2, [0 0 0]);
            exampleButton.Layout.Column = 2;
            exampleButton.ButtonPushedFcn = @(src, event) obj.onLoadExample(src, event);
            
            syntheticButton = obj.makePixelButton(buttonGrid, "SYNTH", obj.Colors.red, obj.Colors.white);
            syntheticButton.Layout.Column = 3;
            syntheticButton.ButtonPushedFcn = @(src, event) obj.onLoadSynthetic(src, event);
            
            liveButton = obj.makePixelButton(buttonGrid, "LIVE", obj.Colors.green, [0 0 0]);
            liveButton.Layout.Column = 4;
            liveButton.ButtonPushedFcn = @(src, event) obj.onLoadLive(src, event);
        end
        
        function configureRefreshTimer(obj)
            if obj.State.autoRefreshSeconds <= 0
                return;
            end
            obj.State.refreshTimer = timer( ...
                "ExecutionMode", "fixedSpacing", ...
                "BusyMode", "drop", ...
                "Period", obj.State.autoRefreshSeconds, ...
                "TimerFcn", @(src, event) obj.safeAutoRefresh(src, event));
            obj.Figure.CloseRequestFcn = @(src, event) obj.closeFigure(src, event);
            start(obj.State.refreshTimer);
        end
        
        function safeAutoRefresh(obj, varargin)
            if ~isvalid(obj.Figure)
                return;
            end
            try
                obj.onRefreshCurrent();
                drawnow limitrate nocallbacks;
            catch
            end
        end
        
        function closeFigure(obj, varargin)
            if ~isempty(obj.State.refreshTimer) && isvalid(obj.State.refreshTimer)
                stop(obj.State.refreshTimer);
                delete(obj.State.refreshTimer);
            end
            delete(obj.Figure);
        end
        
        function drawAll(obj)
            quality = obj.metricNumber("workoutQualityScore", 0);
            fatigue = obj.metricNumber("fatigueIndex", 0);
            confidence = obj.metricNumber("confidenceIndex", 0);
            validationAcc = obj.metricNumber("validationAccuracy", obj.metricNumber("modelValidationAccuracy", NaN));
            score = round(quality * 1000 + confidence * 100);
            isLiveSource = obj.metricText("sourceKind", "") == "live_mobile_stream";
            currentActivity = upper(char(obj.metricText("currentActivity", "N/A")));
            
            obj.State.taskView = obj.evaluateTaskView();
            if obj.State.task.active && obj.State.taskView.complete
                obj.State.task.active = false;
                obj.State.task.ended = true;
                obj.State.task.completed = true;
                obj.State.task.failed = false;
                obj.State.taskView = obj.evaluateTaskView();
            end
            
            obj.Widgets.scoreLabel.Text = sprintf("SCORE %06d", score);
            obj.Widgets.levelLabel.Text = sprintf("LEVEL %02d", max(1, ceil(max(quality, 1) / 20)));
            obj.Widgets.trustLabel.Text = sprintf("TRUST %.0f%%", confidence);
            if isnan(validationAcc)
                obj.Widgets.validationLabel.Text = "VAL --%";
            else
                obj.Widgets.validationLabel.Text = sprintf("VAL %.0f%%", validationAcc * 100);
            end
            
            if ~obj.State.bundle.hasMetrics || ~obj.metricAvailable("workoutQualityScore")
                obj.Widgets.statusLabel.Text = "NO DATA";
                obj.Widgets.statusLabel.FontColor = obj.Colors.red;
            elseif obj.State.taskView.completed
                obj.Widgets.statusLabel.Text = "TASK CLEAR";
                obj.Widgets.statusLabel.FontColor = obj.Colors.green;
            elseif obj.State.taskView.failed
                obj.Widgets.statusLabel.Text = "TASK MISS";
                obj.Widgets.statusLabel.FontColor = obj.Colors.red;
            elseif obj.State.taskView.active
                obj.Widgets.statusLabel.Text = sprintf("TASK %.0f%%", obj.State.taskView.progress);
                obj.Widgets.statusLabel.FontColor = obj.Colors.ghost2;
            elseif fatigue >= 70
                obj.Widgets.statusLabel.Text = "FATIGUE!";
                obj.Widgets.statusLabel.FontColor = obj.Colors.red;
            elseif isLiveSource && obj.metricAvailable("currentActivity")
                obj.Widgets.statusLabel.Text = "LIVE " + currentActivity;
                obj.Widgets.statusLabel.FontColor = obj.Colors.ghost2;
            elseif quality >= 75
                obj.Widgets.statusLabel.Text = "POWER RUN";
                obj.Widgets.statusLabel.FontColor = obj.Colors.green;
            else
                obj.Widgets.statusLabel.Text = "MODEL READY";
                obj.Widgets.statusLabel.FontColor = obj.Colors.yellow;
            end
            
            obj.Widgets.metricLabels.quality.Text = char(obj.metricDisplayNumber("workoutQualityScore", "%.1f / 100"));
            obj.Widgets.metricLabels.fatigue.Text = char(obj.metricDisplayNumber("fatigueIndex", "%.1f / 100"));
            obj.Widgets.metricLabels.confidence.Text = char(obj.metricDisplayNumber("confidenceIndex", "%.1f %%"));
            obj.Widgets.metricLabels.current.Text = char(obj.metricDisplayText("currentActivity"));
            obj.Widgets.metricLabels.sport.Text = char(obj.metricDisplayText("detectedSport"));
            obj.Widgets.metricLabels.steps.Text = char(obj.metricDisplayNumber("stepCount", "%.0f"));
            obj.Widgets.metricLabels.distance.Text = char(obj.metricDisplayNumber("distanceKm", "%.2f km"));
            obj.Widgets.metricLabels.cadence.Text = char(obj.metricDisplayNumber("cadenceSpm", "%.1f spm"));
            obj.Widgets.metricLabels.calories.Text = char(obj.metricDisplayNumber("estimatedCalories", "%.1f kcal"));
            obj.Widgets.taskStatusLabel.Text = obj.composeTaskStatus(obj.State.taskView);
            
            obj.Widgets.logLabel.Text = obj.composeNarrative();
            obj.drawGame();
            obj.drawTimeline();
            obj.drawActivity();
        end
        
        function drawGame(obj)
            quality = obj.metricNumber("workoutQualityScore", 0);
            fatigue = obj.metricNumber("fatigueIndex", 0);
            confidence = obj.metricNumber("confidenceIndex", 0);
            calories = obj.metricNumber("estimatedCalories", 0);
            sport = obj.metricText("detectedSport", "SESSION");
            progress = min(max(quality, 0), 100);
            danger = min(max(fatigue, 0), 100);
            titleText = "DAILY MAZE MODE";
            titleColor = obj.Colors.pellet;
            
            if obj.State.taskView.active || obj.State.taskView.ended || obj.State.taskView.completed || obj.State.taskView.failed
                progress = obj.State.taskView.progress;
                titleText = "LIVE TASK MAZE";
                titleColor = obj.Colors.ghost2;
                if obj.State.taskView.completed
                    progress = 100;
                    danger = min(danger, 20);
                    titleText = "TASK CLEAR";
                    titleColor = obj.Colors.green;
                elseif obj.State.taskView.failed
                    progress = max(0, min(progress, 18));
                    danger = 92;
                    titleText = "TASK MISSED";
                    titleColor = obj.Colors.red;
                end
            end
            
            cla(obj.Axes.gameAxes);
            hold(obj.Axes.gameAxes, "on");
            obj.Axes.gameAxes.Color = obj.Colors.bg;
            xlim(obj.Axes.gameAxes, [0 36]);
            ylim(obj.Axes.gameAxes, [0 23]);
            
            obj.drawMazeFrame();
            obj.drawPellets(progress);
            
            laneStart = 4;
            laneEnd = 27;
            pacX = laneStart + (laneEnd - laneStart) * progress / 100;
            pacY = 10.3;
            ghostX = 31 - 14 * danger / 100;
            ghostX = max(pacX + 3.2, ghostX);
            ghostX = min(ghostX, 31);
            
            if danger >= 70
                obj.drawPixelGhost(obj.Axes.gameAxes, ghostX, pacY, obj.Colors.red, 0.36);
                if obj.State.taskView.failed
                    dangerText = titleText;
                else
                    dangerText = "FATIGUE CHASE";
                end
                text(obj.Axes.gameAxes, 13.2, 18.6, dangerText, ...
                    "FontName", "Courier New", "FontWeight", "bold", ...
                    "FontSize", 18, "Color", obj.Colors.red);
            else
                obj.drawPixelGhost(obj.Axes.gameAxes, ghostX, pacY, obj.Colors.ghost, 0.36);
                text(obj.Axes.gameAxes, 11.6, 18.6, titleText, ...
                    "FontName", "Courier New", "FontWeight", "bold", ...
                    "FontSize", 18, "Color", titleColor);
            end
            
            obj.drawPixelPacman(obj.Axes.gameAxes, pacX, pacY, obj.Colors.yellow, 0.38);
            obj.drawFruit(calories);
            
            text(obj.Axes.gameAxes, 3.1, 2.1, sprintf("QUALITY %.0f%%", progress), ...
                "FontName", "Courier New", "FontWeight", "bold", ...
                "FontSize", 14, "Color", obj.scoreColor(progress, false));
            text(obj.Axes.gameAxes, 17.0, 2.1, sprintf("SENSOR TRUST %.0f%%", confidence), ...
                "FontName", "Courier New", "FontWeight", "bold", ...
                "FontSize", 14, "Color", obj.scoreColor(confidence, false));
            text(obj.Axes.gameAxes, 3.1, 20.9, upper(char(sport)), ...
                "FontName", "Courier New", "FontWeight", "bold", ...
                "FontSize", 13, "Color", obj.Colors.muted);
            if obj.State.taskView.active || obj.State.taskView.ended || obj.State.taskView.completed || obj.State.taskView.failed
                text(obj.Axes.gameAxes, 22.0, 20.9, sprintf("TASK %.0f%%", obj.State.taskView.progress), ...
                    "FontName", "Courier New", "FontWeight", "bold", ...
                    "FontSize", 13, "Color", titleColor);
            end
            
            hold(obj.Axes.gameAxes, "off");
        end
        
        function drawTimeline(obj)
            cla(obj.Axes.timelineAxes);
            hold(obj.Axes.timelineAxes, "on");
            obj.Axes.timelineAxes.Color = obj.Colors.panel2;
            obj.Axes.timelineAxes.XColor = obj.Colors.text;
            obj.Axes.timelineAxes.YColor = obj.Colors.text;
            obj.Axes.timelineAxes.FontName = "Courier New";
            obj.Axes.timelineAxes.FontWeight = "bold";
            obj.Axes.timelineAxes.Box = "on";
            obj.Axes.timelineAxes.LineWidth = 1;
            title(obj.Axes.timelineAxes, "FATIGUE INDEX TIMELINE", "Color", obj.Colors.text, "FontName", "Courier New");
            xlabel(obj.Axes.timelineAxes, "Minute", "Color", obj.Colors.text);
            ylabel(obj.Axes.timelineAxes, "FI", "Color", obj.Colors.text);
            ylim(obj.Axes.timelineAxes, [0 100]);
            
            tbl = obj.State.bundle.fatigueTimeline;
            if obj.State.bundle.hasMetrics && height(tbl) > 0 && all(ismember(["minute", "FatigueIndex"], string(tbl.Properties.VariableNames)))
                x = tbl.minute;
                y = tbl.FatigueIndex;
                xMin = min(x);
                xMax = max(x);
                if xMax <= xMin
                    xMax = xMin + 1;
                end
                rectangle(obj.Axes.timelineAxes, "Position", [xMin 0 xMax - xMin 30], ...
                    "FaceColor", [0.03 0.18 0.08], "EdgeColor", "none");
                rectangle(obj.Axes.timelineAxes, "Position", [xMin 30 xMax - xMin 40], ...
                    "FaceColor", [0.24 0.16 0.03], "EdgeColor", "none");
                rectangle(obj.Axes.timelineAxes, "Position", [xMin 70 xMax - xMin 30], ...
                    "FaceColor", [0.22 0.02 0.04], "EdgeColor", "none");
                plot(obj.Axes.timelineAxes, x, y, "Color", obj.Colors.yellow, "LineWidth", 2.5);
                [peakValue, idx] = max(y);
                plot(obj.Axes.timelineAxes, x(idx), peakValue, "o", ...
                    "MarkerFaceColor", obj.Colors.red, "MarkerEdgeColor", obj.Colors.white, "MarkerSize", 7);
                text(obj.Axes.timelineAxes, x(idx), min(95, peakValue + 8), sprintf("PEAK %.0f", peakValue), ...
                    "FontName", "Courier New", "FontWeight", "bold", ...
                    "FontSize", 11, "Color", obj.Colors.white);
                xlim(obj.Axes.timelineAxes, [xMin xMax]);
                grid(obj.Axes.timelineAxes, "on");
            else
                text(obj.Axes.timelineAxes, 0.5, 50, "RUN PIPELINE TO LOAD TIMELINE", ...
                    "HorizontalAlignment", "center", ...
                    "FontName", "Courier New", "FontWeight", "bold", ...
                    "FontSize", 14, "Color", obj.Colors.red);
                xlim(obj.Axes.timelineAxes, [0 1]);
            end
            hold(obj.Axes.timelineAxes, "off");
        end
        
        function drawActivity(obj)
            cla(obj.Axes.activityAxes);
            hold(obj.Axes.activityAxes, "on");
            obj.Axes.activityAxes.Color = obj.Colors.panel;
            obj.Axes.activityAxes.XColor = obj.Colors.text;
            obj.Axes.activityAxes.YColor = obj.Colors.text;
            obj.Axes.activityAxes.FontName = "Courier New";
            obj.Axes.activityAxes.FontWeight = "bold";
            
            tbl = obj.State.bundle.caloriesByActivity;
            if obj.State.bundle.hasMetrics && height(tbl) > 0 && all(ismember(["activity", "minutes"], string(tbl.Properties.VariableNames)))
                labels = string(tbl.activity);
                minutes = tbl.minutes;
                if ismember("calories", string(tbl.Properties.VariableNames))
                    values = tbl.calories;
                    title(obj.Axes.activityAxes, "KCAL BY ACTIVITY", "Color", obj.Colors.text, "FontName", "Courier New");
                    xText = "kcal";
                else
                    values = minutes;
                    title(obj.Axes.activityAxes, "MINUTES BY ACTIVITY", "Color", obj.Colors.text, "FontName", "Courier New");
                    xText = "min";
                end
                keep = minutes > 0 | values > 0;
                labels = labels(keep);
                values = values(keep);
                if isempty(values)
                    labels = "none";
                    values = 0;
                end
                barh(obj.Axes.activityAxes, categorical(labels), values, "FaceColor", obj.Colors.yellow, "EdgeColor", obj.Colors.wallGlow);
                xlabel(obj.Axes.activityAxes, xText, "Color", obj.Colors.text);
                grid(obj.Axes.activityAxes, "on");
            else
                text(obj.Axes.activityAxes, 0.5, 0.5, "NO ACTIVITY CSV", ...
                    "HorizontalAlignment", "center", ...
                    "FontName", "Courier New", "FontWeight", "bold", ...
                    "FontSize", 13, "Color", obj.Colors.red);
                xlim(obj.Axes.activityAxes, [0 1]);
                ylim(obj.Axes.activityAxes, [0 1]);
            end
            hold(obj.Axes.activityAxes, "off");
        end
        
        function drawMazeFrame(obj)
            obj.drawWall(1, 1, 34, 1);
            obj.drawWall(1, 21, 34, 1);
            obj.drawWall(1, 1, 1, 21);
            obj.drawWall(34, 1, 1, 21);
            obj.drawWall(4, 4, 7, 1);
            obj.drawWall(14, 4, 8, 1);
            obj.drawWall(25, 4, 6, 1);
            obj.drawWall(4, 17, 7, 1);
            obj.drawWall(14, 17, 8, 1);
            obj.drawWall(25, 17, 6, 1);
            obj.drawWall(7, 6, 1, 5);
            obj.drawWall(28, 6, 1, 5);
            obj.drawWall(7, 12, 1, 4);
            obj.drawWall(28, 12, 1, 4);
            obj.drawWall(13, 7, 2, 3);
            obj.drawWall(21, 7, 2, 3);
            obj.drawWall(13, 13, 2, 3);
            obj.drawWall(21, 13, 2, 3);
            obj.drawWall(16, 9, 4, 1);
            obj.drawWall(16, 13, 4, 1);
        end
        
        function drawWall(obj, x, y, w, h)
            rectangle(obj.Axes.gameAxes, ...
                "Position", [x y w h], ...
                "FaceColor", obj.Colors.wall, ...
                "EdgeColor", obj.Colors.wallGlow, ...
                "LineWidth", 1.2);
        end
        
        function drawPellets(obj, ~)
            taskNames = ["STEPS 5K", "ACTIVE 20m", "DIST 1KM", "CALS 100", ...
                         "QUALITY 50", "SENSOR 60", "CADENCE", "MODEL .8"];
            taskDone = [
                obj.metricNumber("stepCount", 0) >= 5000;
                obj.metricNumber("activeMinutes", 0) >= 20;
                obj.metricNumber("distanceKm", 0) >= 1.0;
                obj.metricNumber("estimatedCalories", 0) >= 100;
                obj.metricNumber("workoutQualityScore", 0) >= 50;
                obj.metricNumber("confidenceIndex", 0) >= 60;
                obj.metricNumber("cadenceSpm", 0) > 0;
                obj.metricNumber("validationAccuracy", 0) >= 0.8
            ];
            
            pelletXs = linspace(5.2, 28.8, numel(taskNames));
            pelletY = 11.25;
            labelY = pelletY + 1.15;
            
            doneFill = [0.06 0.28 0.14];
            doneEdge = [0.32 0.92 0.55];
            doneText = [0.40 0.98 0.62];
            
            for i = 1:numel(taskNames)
                x = pelletXs(i);
                if taskDone(i)
                    rectangle(obj.Axes.gameAxes, ...
                        "Position", [x pelletY 0.32 0.32], ...
                        "FaceColor", doneFill, ...
                        "EdgeColor", doneEdge, ...
                        "LineWidth", 0.9);
                    text(obj.Axes.gameAxes, x + 0.16, labelY, taskNames(i) + " *", ...
                        "FontName", "Courier New", "FontSize", 7, "FontWeight", "bold", ...
                        "HorizontalAlignment", "center", "Color", doneText);
                else
                    rectangle(obj.Axes.gameAxes, ...
                        "Position", [x pelletY 0.30 0.30], ...
                        "FaceColor", obj.Colors.pellet, ...
                        "EdgeColor", obj.Colors.pellet);
                    text(obj.Axes.gameAxes, x + 0.15, labelY, taskNames(i), ...
                        "FontName", "Courier New", "FontSize", 7, "FontWeight", "bold", ...
                        "HorizontalAlignment", "center", "Color", obj.Colors.muted);
                end
            end
            
            completedCount = sum(taskDone);
            completionRatio = completedCount / numel(taskNames);
            if completionRatio >= 0.75
                flashMsg = "NICE WORK!";
                flashColor = doneText;
            elseif completionRatio >= 0.45
                flashMsg = "BUILDING UP!";
                flashColor = obj.Colors.pellet;
            elseif completionRatio > 0
                flashMsg = "KEEP GOING";
                flashColor = obj.Colors.muted;
            else
                flashMsg = "DAILY MAZE";
                flashColor = obj.Colors.muted;
            end
            text(obj.Axes.gameAxes, 17.0, 13.55, ...
                sprintf("DAILY TASKS %d/%d  -  %s", completedCount, numel(taskNames), flashMsg), ...
                "FontName", "Courier New", "FontWeight", "bold", "FontSize", 10, ...
                "HorizontalAlignment", "center", "Color", flashColor);
        end
        
        function drawFruit(obj, calories)
            if calories <= 0
                return;
            end
            fruitScale = min(1.4, max(0.7, calories / 30));
            rectangle(obj.Axes.gameAxes, ...
                "Position", [30.1 5.2 0.9 * fruitScale 0.9 * fruitScale], ...
                "Curvature", [1 1], ...
                "FaceColor", obj.Colors.red, ...
                "EdgeColor", obj.Colors.pellet, ...
                "LineWidth", 1.2);
            rectangle(obj.Axes.gameAxes, ...
                "Position", [30.6 6.1 0.32 0.20], ...
                "FaceColor", obj.Colors.green, ...
                "EdgeColor", obj.Colors.green);
            text(obj.Axes.gameAxes, 28.7, 4.1, sprintf("%.0f KCAL", calories), ...
                "FontName", "Courier New", "FontWeight", "bold", ...
                "FontSize", 11, "Color", obj.Colors.text);
        end
        
        function value = metricNumber(obj, name, defaultValue)
            value = defaultValue;
            if obj.metricAvailable(name)
                raw = obj.State.bundle.metrics.(name);
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
        
        function value = metricText(obj, name, defaultValue)
            value = string(defaultValue);
            if obj.metricAvailable(name)
                raw = obj.State.bundle.metrics.(name);
                if ischar(raw) || isstring(raw)
                    value = string(raw);
                elseif isnumeric(raw)
                    value = string(raw);
                end
            end
        end
        
        function textValue = metricDisplayNumber(obj, name, formatSpec)
            if obj.metricAvailable(name)
                textValue = string(sprintf(formatSpec, obj.metricNumber(name, 0)));
            else
                textValue = "n/a";
            end
        end
        
        function textValue = metricDisplayText(obj, name)
            if obj.metricAvailable(name)
                textValue = obj.metricText(name, "n/a");
            else
                textValue = "n/a";
            end
        end
        
        function tf = metricAvailable(obj, name)
            tf = false;
            if ~obj.State.bundle.hasMetrics || ~isfield(obj.State.bundle.metrics, name)
                return;
            end
            raw = obj.State.bundle.metrics.(name);
            if isnumeric(raw)
                tf = ~isempty(raw) && all(isfinite(raw(:)));
            elseif ischar(raw) || isstring(raw)
                tf = strlength(string(raw)) > 0 && string(raw) ~= "n/a";
            else
                tf = ~isempty(raw);
            end
        end
        
        function outputDir = defaultOutputDir(obj, name)
            thisDir = fileparts(mfilename("fullpath"));
            projectRoot = fileparts(fileparts(thisDir));
            outputDir = fullfile(projectRoot, "outputs", name);
        end
        
        function color = scoreColor(obj, value, inverse)
            if nargin < 3
                inverse = false;
            end
            if inverse
                value = 100 - value;
            end
            if value >= 75
                color = obj.Colors.green;
            elseif value >= 45
                color = obj.Colors.orange;
            else
                color = obj.Colors.red;
            end
        end
        
        function snapshot = currentTaskSnapshot(obj, activity)
            if nargin < 2
                activity = string(obj.Widgets.taskActivityDrop.Value);
            end
            snapshot = struct();
            snapshot.steps = obj.metricNumber("stepCount", 0);
            snapshot.calories = obj.metricNumber("estimatedCalories", 0);
            snapshot.activeMinutes = obj.metricNumber("activeMinutes", 0);
            snapshot.activityMinutes = obj.activityMinutesFor(activity);
            snapshot.currentActivity = obj.metricText("currentActivity", "unknown");
        end
        
        function minutes = activityMinutesFor(obj, activity)
            activity = string(activity);
            if activity == "any"
                minutes = obj.metricNumber("activeMinutes", 0);
                return;
            end
            
            minutes = 0;
            tbl = obj.State.bundle.caloriesByActivity;
            if ~obj.State.bundle.hasMetrics || height(tbl) == 0 || ...
                    ~all(ismember(["activity", "minutes"], string(tbl.Properties.VariableNames)))
                return;
            end
            
            mask = string(tbl.activity) == activity;
            if any(mask)
                minutes = sum(tbl.minutes(mask), "omitnan");
            end
        end
        
        function view = evaluateTaskView(obj)
            view = obj.defaultTaskView();
            view.activity = obj.State.task.activity;
            if ~obj.State.task.active && ~obj.State.task.ended && ~obj.State.task.completed && ~obj.State.task.failed
                return;
            end
            
            view.active = obj.State.task.active;
            view.completed = obj.State.task.completed;
            view.failed = obj.State.task.failed;
            view.ended = obj.State.task.ended;
            
            nowSnapshot = obj.currentTaskSnapshot(obj.State.task.activity);
            requiredActivity = obj.State.task.activity;
            if requiredActivity == "any"
                minutesDone = max(0, nowSnapshot.activeMinutes - obj.State.task.baseline.activeMinutes);
            else
                minutesDone = max(0, nowSnapshot.activityMinutes - obj.State.task.baseline.activityMinutes);
            end
            caloriesDone = max(0, nowSnapshot.calories - obj.State.task.baseline.calories);
            stepsDone = max(0, nowSnapshot.steps - obj.State.task.baseline.steps);
            
            minuteRatio = obj.ratioOrComplete(minutesDone, obj.State.task.targetMinutes);
            calorieRatio = obj.ratioOrComplete(caloriesDone, obj.State.task.targetCalories);
            stepRatio = obj.ratioOrComplete(stepsDone, obj.State.task.targetSteps);
            targetCount = obj.enabledTaskTargetCount();
            
            if targetCount == 0
                progress = double(requiredActivity == "any" || nowSnapshot.currentActivity == requiredActivity) * 100;
            else
                progress = 100 * mean([minuteRatio calorieRatio stepRatio]);
            end
            progress = clampValue(progress, 0, 100);
            
            minuteOk = obj.State.task.targetMinutes <= 0 || minutesDone >= obj.State.task.targetMinutes;
            calorieOk = obj.State.task.targetCalories <= 0 || caloriesDone >= obj.State.task.targetCalories;
            stepOk = obj.State.task.targetSteps <= 0 || stepsDone >= obj.State.task.targetSteps;
            activityOk = requiredActivity == "any" || nowSnapshot.currentActivity == requiredActivity || minutesDone > 0;
            complete = minuteOk && calorieOk && stepOk && activityOk && targetCount > 0;
            
            if obj.State.task.completed
                complete = true;
                progress = 100;
            elseif obj.State.task.failed
                complete = false;
                progress = max(0, progress - 35);
            end
            
            view.progress = round(progress, 1);
            view.complete = complete;
            view.completed = obj.State.task.completed || complete;
            view.failed = obj.State.task.failed;
            view.minutesDone = round(minutesDone, 2);
            view.caloriesDone = round(caloriesDone, 1);
            view.stepsDone = round(stepsDone);
            view.currentActivity = nowSnapshot.currentActivity;
            view.activityMatch = activityOk;
        end
        
        function ratio = ratioOrComplete(obj, value, target)
            if target <= 0
                ratio = 1;
            else
                ratio = min(max(value / target, 0), 1);
            end
        end
        
        function count = enabledTaskTargetCount(obj)
            count = double(obj.State.task.targetMinutes > 0) + ...
                double(obj.State.task.targetCalories > 0) + ...
                double(obj.State.task.targetSteps > 0);
        end
        
        function textValue = composeTaskStatus(obj, view)
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
                upper(char(obj.State.task.activity)), stateText, view.progress, ...
                upper(char(view.currentActivity)), matchText, ...
                view.minutesDone, obj.State.task.targetMinutes, ...
                view.caloriesDone, obj.State.task.targetCalories, ...
                view.stepsDone, obj.State.task.targetSteps);
        end
        
        function textValue = composeNarrative(obj)
            if ~obj.State.bundle.hasMetrics || ~obj.metricAvailable("workoutQualityScore")
                textValue = sprintf("%s\n\nRun main, runSyntheticFatigueDemo, or load a session output folder.", ...
                    char(obj.State.bundle.statusMessage));
                return;
            end
            
            coachText = obj.metricText("coachAdvice", "");
            sourceText = obj.metricText("coachAdviceSource", "template");
            modelType = obj.metricText("modelType", "unknown");
            modelRows = obj.metricNumber("modelTrainingRows", 0);
            modelAcc = obj.metricNumber("modelTrainingAccuracy", NaN);
            validationAcc = obj.metricNumber("validationAccuracy", obj.metricNumber("modelValidationAccuracy", NaN));
            validationRows = obj.metricNumber("validationRows", obj.metricNumber("modelValidationRows", 0));
            sourceKind = obj.metricText("sourceKind", "mat_file");
            currentActivity = obj.metricText("currentActivity", "unknown");
            if strlength(coachText) == 0
                coachText = "Coach advice unavailable.";
            end
            coachText = obj.truncateText(coachText, 95);
            
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
                obj.metricNumber("workoutQualityScore", 0), ...
                obj.metricNumber("fatigueIndex", 0), ...
                obj.metricNumber("confidenceIndex", 0), ...
                char(obj.metricText("detectedSport", "Session")), ...
                upper(char(currentActivity)), ...
                obj.metricNumber("stepCount", 0), ...
                obj.metricNumber("distanceKm", 0), ...
                obj.metricNumber("estimatedCalories", 0), ...
                upper(char(sourceKind)), ...
                char(sourceText), char(coachText));
        end
        
        function drawPixelPacman(obj, ax, x, y, color, scale)
            pattern = {
                "0011110"
                "0111111"
                "1111100"
                "1111000"
                "1111100"
                "0111111"
                "0011110"
            };
            obj.drawPixelShape(ax, pattern, x, y, color, scale);
            rectangle(ax, ...
                "Position", [x + 4.3 * scale y + 4.6 * scale scale scale], ...
                "FaceColor", [0 0 0], ...
                "EdgeColor", [0 0 0]);
        end
        
        function drawPixelGhost(obj, ax, x, y, color, scale)
            pattern = {
                "0111110"
                "1111111"
                "1011101"
                "1111111"
                "1111111"
                "1101011"
                "1001001"
            };
            obj.drawPixelShape(ax, pattern, x, y, color, scale);
            rectangle(ax, ...
                "Position", [x + 1.8 * scale y + 4.6 * scale 0.9 * scale 0.9 * scale], ...
                "FaceColor", [0 0 0], ...
                "EdgeColor", [0 0 0]);
            rectangle(ax, ...
                "Position", [x + 4.4 * scale y + 4.6 * scale 0.9 * scale 0.9 * scale], ...
                "FaceColor", [0 0 0], ...
                "EdgeColor", [0 0 0]);
        end
        
        % Layout Factory Helpers
        function label = addMetricRow(obj, parent, name, row)
            nameLabel = uilabel(parent, ...
                "Text", name, ...
                "FontName", "Courier New", ...
                "FontWeight", "bold", ...
                "FontSize", 13, ...
                "FontColor", obj.Colors.text, ...
                "BackgroundColor", obj.Colors.panel);
            nameLabel.Layout.Row = row;
            nameLabel.Layout.Column = 1;
            
            label = uilabel(parent, ...
                "Text", "--", ...
                "HorizontalAlignment", "right", ...
                "FontName", "Courier New", ...
                "FontWeight", "bold", ...
                "FontSize", 13, ...
                "FontColor", obj.Colors.white, ...
                "BackgroundColor", obj.Colors.panel);
            label.Layout.Row = row;
            label.Layout.Column = 2;
        end
        
        function addTaskText(obj, parent, textValue, row)
            label = uilabel(parent, ...
                "Text", textValue, ...
                "FontName", "Courier New", ...
                "FontWeight", "bold", ...
                "FontSize", 11, ...
                "FontColor", obj.Colors.text, ...
                "BackgroundColor", obj.Colors.panel);
            label.Layout.Row = row;
            label.Layout.Column = 1;
        end
        
        function field = addTaskNumber(obj, parent, labelText, value, row)
            obj.addTaskText(parent, labelText, row);
            field = uieditfield(parent, "numeric", ...
                "Value", value, ...
                "Limits", [0 Inf], ...
                "RoundFractionalValues", "off", ...
                "FontName", "Courier New", ...
                "FontWeight", "bold", ...
                "FontSize", 11, ...
                "FontColor", obj.Colors.white, ...
                "BackgroundColor", [0 0 0]);
            field.Layout.Row = row;
            field.Layout.Column = 2;
        end
        
        function panel = makePanel(obj, parent, titleValue)
            panel = uipanel(parent, ...
                "Title", titleValue, ...
                "FontName", "Courier New", ...
                "FontWeight", "bold", ...
                "FontSize", 13, ...
                "ForegroundColor", obj.Colors.text, ...
                "BackgroundColor", obj.Colors.panel);
        end
        
        function label = makeHeaderLabel(obj, parent, textValue, colorValue)
            label = uilabel(parent, ...
                "Text", textValue, ...
                "HorizontalAlignment", "center", ...
                "FontName", "Courier New", ...
                "FontWeight", "bold", ...
                "FontSize", 17, ...
                "FontColor", colorValue, ...
                "BackgroundColor", obj.Colors.panel);
            label.Layout.Row = 1;
        end
        
        function button = makePixelButton(obj, parent, textValue, bgColor, fontColor)
            button = uibutton(parent, "push", ...
                "Text", textValue, ...
                "FontName", "Courier New", ...
                "FontWeight", "bold", ...
                "FontSize", 12, ...
                "BackgroundColor", bgColor, ...
                "FontColor", fontColor);
            button.Layout.Row = 1;
        end
        
        function styleAxes(obj, ax, bgColor)
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
        
        function drawPixelShape(obj, ax, pattern, x0, y0, color, scale)
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
        
        function textValue = truncateText(obj, textValue, maxChars)
            textValue = string(textValue);
            if strlength(textValue) > maxChars
                textValue = extractBefore(textValue, maxChars - 2) + "...";
            end
        end
        
        function task = defaultTaskState(obj)
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
        
        function view = defaultTaskView(obj)
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
        
        function value = getUiOption(obj, options, name, defaultValue)
            if isfield(options, name)
                value = options.(name);
            else
                value = defaultValue;
            end
        end
        
        % Callback Implementation Methods
        function onRefreshCurrent(obj, varargin)
            obj.State.bundle = loadPeyManUiMetrics(obj.State.bundle.outputDir);
            obj.drawAll();
        end
        
        function onLoadExample(obj, varargin)
            obj.State.bundle = loadPeyManUiMetrics(obj.defaultOutputDir("example_file"));
            obj.drawAll();
        end
        
        function onLoadSynthetic(obj, varargin)
            obj.State.bundle = loadPeyManUiMetrics(obj.defaultOutputDir("synthetic"));
            obj.drawAll();
        end
        
        function onLoadLive(obj, varargin)
            obj.State.bundle = loadPeyManUiMetrics(obj.defaultOutputDir("live"));
            obj.drawAll();
        end
        
        function onStartTask(obj, varargin)
            obj.State.task = obj.defaultTaskState();
            obj.State.task.activity = string(obj.Widgets.taskActivityDrop.Value);
            obj.State.task.targetMinutes = max(0, obj.Widgets.taskMinutesField.Value);
            obj.State.task.targetCalories = max(0, obj.Widgets.taskCaloriesField.Value);
            obj.State.task.targetSteps = max(0, obj.Widgets.taskStepsField.Value);
            obj.State.task.baseline = obj.currentTaskSnapshot(obj.State.task.activity);
            obj.State.task.active = true;
            obj.State.task.startedAt = datetime("now", "Format", "HH:mm:ss");
            obj.drawAll();
        end
        
        function onEndTask(obj, varargin)
            if ~obj.State.task.active && ~obj.State.task.completed && ~obj.State.task.failed
                obj.drawAll();
                return;
            elseif ~obj.State.task.active && ~obj.State.task.completed
                obj.State.task.ended = true;
                obj.State.task.failed = true;
            else
                view = obj.evaluateTaskView();
                obj.State.task.ended = true;
                obj.State.task.active = false;
                obj.State.task.completed = view.complete;
                obj.State.task.failed = ~view.complete;
            end
            obj.drawAll();
        end
        
        function onResetTask(obj, varargin)
            obj.State.task = obj.defaultTaskState();
            obj.drawAll();
        end
    end
end
