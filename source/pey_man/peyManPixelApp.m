function peyManPixelApp
% PEYMANPIXELAPP Pixel-art Pac-Man inspired fitness tracker UI.
% Run with:
%   peyManPixelApp

targets.steps = 8000;
targets.workoutMinutes = 30;
targets.waterCups = 8;
targets.sleepHours = 7;

state.score = 0;
state.streak = 0;
state.danger = 0;
state.day = 1;
state.progress = 0;
state.lastStatus = "READY";
state.metrics = [0 0 0 0];

colors.bg = [0.02 0.02 0.08];
colors.panel = [0.03 0.04 0.13];
colors.wall = [0.0 0.18 0.85];
colors.wallGlow = [0.0 0.72 1.0];
colors.yellow = [1.0 0.88 0.05];
colors.pellet = [1.0 0.92 0.55];
colors.ghost = [1.0 0.18 0.38];
colors.ghost2 = [0.2 0.85 1.0];
colors.white = [0.95 0.95 0.95];
colors.green = [0.12 0.9 0.35];
colors.orange = [1.0 0.56 0.05];
colors.red = [1.0 0.12 0.18];
colors.text = [1.0 0.95 0.72];

fig = uifigure( ...
    "Name", "Pey-Man Fitness Tracker", ...
    "Color", colors.bg, ...
    "Position", [100 100 1180 720]);

root = uigridlayout(fig, [1 2]);
root.ColumnWidth = {"1x", 330};
root.RowHeight = {"1x"};
root.Padding = [14 14 14 14];
root.ColumnSpacing = 14;
root.BackgroundColor = colors.bg;

left = uigridlayout(root, [3 1]);
left.Layout.Row = 1;
left.Layout.Column = 1;
left.RowHeight = {58, "1x", 120};
left.Padding = [0 0 0 0];
left.RowSpacing = 12;
left.BackgroundColor = colors.bg;

header = uigridlayout(left, [1 3]);
header.Layout.Row = 1;
header.Layout.Column = 1;
header.ColumnWidth = {"1x", 170, 170};
header.Padding = [0 0 0 0];
header.ColumnSpacing = 10;
header.BackgroundColor = colors.bg;

titleLabel = uilabel(header, ...
    "Text", "PEY-MAN", ...
    "FontName", "Courier New", ...
    "FontWeight", "bold", ...
    "FontSize", 36, ...
    "FontColor", colors.yellow);
titleLabel.Layout.Row = 1;
titleLabel.Layout.Column = 1;

scoreLabel = makePixelLabel(header, "SCORE 000000", colors.text, 18);
scoreLabel.Layout.Row = 1;
scoreLabel.Layout.Column = 2;

streakLabel = makePixelLabel(header, "STREAK 0", colors.text, 18);
streakLabel.Layout.Row = 1;
streakLabel.Layout.Column = 3;

gameAxes = uiaxes(left);
gameAxes.Layout.Row = 2;
gameAxes.Layout.Column = 1;
styleAxes(gameAxes, colors.bg);

barAxes = uiaxes(left);
barAxes.Layout.Row = 3;
barAxes.Layout.Column = 1;
styleAxes(barAxes, colors.bg);

side = uigridlayout(root, [5 1]);
side.Layout.Row = 1;
side.Layout.Column = 2;
side.RowHeight = {56, 230, 168, "1x", 56};
side.Padding = [0 0 0 0];
side.RowSpacing = 12;
side.BackgroundColor = colors.bg;

statusLabel = uilabel(side, ...
    "Text", "READY", ...
    "HorizontalAlignment", "center", ...
    "FontName", "Courier New", ...
    "FontWeight", "bold", ...
    "FontSize", 22, ...
    "FontColor", colors.yellow, ...
    "BackgroundColor", colors.panel);
statusLabel.Layout.Row = 1;
statusLabel.Layout.Column = 1;

inputPanel = uipanel(side, ...
    "Title", "DAILY INPUT", ...
    "FontName", "Courier New", ...
    "FontWeight", "bold", ...
    "FontSize", 13, ...
    "ForegroundColor", colors.text, ...
    "BackgroundColor", colors.panel);
inputPanel.Layout.Row = 2;
inputPanel.Layout.Column = 1;

inputGrid = uigridlayout(inputPanel, [4 2]);
inputGrid.ColumnWidth = {"1x", 112};
inputGrid.RowHeight = {40, 40, 40, 40};
inputGrid.Padding = [12 18 12 12];
inputGrid.RowSpacing = 8;
inputGrid.ColumnSpacing = 10;
inputGrid.BackgroundColor = colors.panel;

stepsField = addInput(inputGrid, "STEPS", 0, 1);
workoutField = addInput(inputGrid, "WORKOUT MIN", 0, 2);
waterField = addInput(inputGrid, "WATER CUP", 0, 3);
sleepField = addInput(inputGrid, "SLEEP HOUR", 0, 4);

targetPanel = uipanel(side, ...
    "Title", "TARGETS", ...
    "FontName", "Courier New", ...
    "FontWeight", "bold", ...
    "FontSize", 13, ...
    "ForegroundColor", colors.text, ...
    "BackgroundColor", colors.panel);
targetPanel.Layout.Row = 3;
targetPanel.Layout.Column = 1;

targetGrid = uigridlayout(targetPanel, [4 1]);
targetGrid.RowHeight = {"1x", "1x", "1x", "1x"};
targetGrid.Padding = [12 18 12 12];
targetGrid.RowSpacing = 2;
targetGrid.BackgroundColor = colors.panel;

makeTargetText(targetGrid, sprintf("STEPS        %5d", targets.steps), 1);
makeTargetText(targetGrid, sprintf("WORKOUT      %5d MIN", targets.workoutMinutes), 2);
makeTargetText(targetGrid, sprintf("WATER        %5d CUP", targets.waterCups), 3);
makeTargetText(targetGrid, sprintf("SLEEP        %5d HOUR", targets.sleepHours), 4);

logPanel = uipanel(side, ...
    "Title", "MISSION LOG", ...
    "FontName", "Courier New", ...
    "FontWeight", "bold", ...
    "FontSize", 13, ...
    "ForegroundColor", colors.text, ...
    "BackgroundColor", colors.panel);
logPanel.Layout.Row = 4;
logPanel.Layout.Column = 1;

logLabel = uilabel(logPanel, ...
    "Text", "Enter today metrics and press SAVE DAY.", ...
    "FontName", "Courier New", ...
    "FontSize", 13, ...
    "FontColor", colors.white, ...
    "BackgroundColor", colors.panel, ...
    "VerticalAlignment", "top", ...
    "WordWrap", "on");
logLabel.Position = [12 12 288 134];

buttonGrid = uigridlayout(side, [1 3]);
buttonGrid.Layout.Row = 5;
buttonGrid.Layout.Column = 1;
buttonGrid.ColumnWidth = {"1x", "1x", "1x"};
buttonGrid.Padding = [0 0 0 0];
buttonGrid.ColumnSpacing = 8;
buttonGrid.BackgroundColor = colors.bg;

saveButton = makePixelButton(buttonGrid, "SAVE DAY", colors.yellow, [0 0 0]);
saveButton.Layout.Row = 1;
saveButton.Layout.Column = 1;
saveButton.ButtonPushedFcn = @saveDay;

demoButton = makePixelButton(buttonGrid, "DEMO +", colors.ghost2, [0 0 0]);
demoButton.Layout.Row = 1;
demoButton.Layout.Column = 2;
demoButton.ButtonPushedFcn = @demoGoodDay;

resetButton = makePixelButton(buttonGrid, "RESET", colors.red, colors.white);
resetButton.Layout.Row = 1;
resetButton.Layout.Column = 3;
resetButton.ButtonPushedFcn = @resetGame;

drawAll();

    function field = addInput(parent, labelText, value, row)
        label = uilabel(parent, ...
            "Text", labelText, ...
            "FontName", "Courier New", ...
            "FontWeight", "bold", ...
            "FontSize", 13, ...
            "FontColor", colors.text, ...
            "BackgroundColor", colors.panel);
        label.Layout.Row = row;
        label.Layout.Column = 1;

        field = uieditfield(parent, "numeric", ...
            "Value", value, ...
            "Limits", [0 Inf], ...
            "RoundFractionalValues", "off", ...
            "FontName", "Courier New", ...
            "FontWeight", "bold", ...
            "FontSize", 13, ...
            "FontColor", colors.white, ...
            "BackgroundColor", [0 0 0]);
        field.Layout.Row = row;
        field.Layout.Column = 2;
    end

    function makeTargetText(parent, textValue, row)
        label = uilabel(parent, ...
            "Text", textValue, ...
            "FontName", "Courier New", ...
            "FontWeight", "bold", ...
            "FontSize", 13, ...
            "FontColor", colors.white, ...
            "BackgroundColor", colors.panel);
        label.Layout.Row = row;
        label.Layout.Column = 1;
    end

    function saveDay(varargin)
        metrics = [
            stepsField.Value
            workoutField.Value
            waterField.Value
            sleepField.Value
        ];

        state.metrics = metrics(:)';
        ratios = [
            metrics(1) / targets.steps
            metrics(2) / targets.workoutMinutes
            metrics(3) / targets.waterCups
            metrics(4) / targets.sleepHours
        ];
        ratios = min(max(ratios, 0), 1);

        weights = [0.45 0.25 0.15 0.15]';
        state.progress = round(100 * sum(ratios .* weights));
        state.score = state.score + state.progress * 10;

        if state.progress >= 100
            state.streak = state.streak + 1;
            state.danger = max(state.danger - 1, 0);
            state.lastStatus = "CLEAR!";
        elseif state.progress >= 70
            state.danger = max(state.danger, 1);
            state.lastStatus = "CLOSE";
        else
            state.streak = 0;
            state.danger = min(state.danger + 1, 5);
            state.lastStatus = "CHASE";
        end

        state.day = state.day + 1;
        drawAll();
    end

    function demoGoodDay(varargin)
        stepsField.Value = targets.steps + randi([250 1800]);
        workoutField.Value = targets.workoutMinutes + randi([5 25]);
        waterField.Value = targets.waterCups;
        sleepField.Value = targets.sleepHours + 0.5;
        saveDay();
    end

    function resetGame(varargin)
        state.score = 0;
        state.streak = 0;
        state.danger = 0;
        state.day = 1;
        state.progress = 0;
        state.lastStatus = "READY";
        state.metrics = [0 0 0 0];

        stepsField.Value = 0;
        workoutField.Value = 0;
        waterField.Value = 0;
        sleepField.Value = 0;
        drawAll();
    end

    function drawAll()
        scoreLabel.Text = sprintf("SCORE %06d", state.score);
        streakLabel.Text = sprintf("STREAK %d", state.streak);
        statusLabel.Text = char(state.lastStatus);

        if state.danger >= 4
            statusLabel.FontColor = colors.red;
        elseif state.progress >= 100
            statusLabel.FontColor = colors.green;
        elseif state.progress >= 70
            statusLabel.FontColor = colors.orange;
        else
            statusLabel.FontColor = colors.yellow;
        end

        logLabel.Text = composeLogText();
        drawGame();
        drawBars();
    end

    function textValue = composeLogText()
        if state.progress >= 100
            message = "Pey-Man cleared the maze. Streak is alive.";
        elseif state.progress >= 70
            message = "Pey-Man is close. Finish one more small target.";
        elseif state.danger > 0
            message = "Ghost is chasing. Missed goals move it closer.";
        else
            message = "Enter today metrics and press SAVE DAY.";
        end

        textValue = sprintf([ ...
            "DAY %02d\n" ...
            "PROGRESS %3d%%\n" ...
            "DANGER   %3d/5\n\n" ...
            "%s"], state.day, state.progress, state.danger, char(message));
    end

    function drawGame()
        cla(gameAxes);
        hold(gameAxes, "on");
        gameAxes.Color = colors.bg;
        xlim(gameAxes, [0 34]);
        ylim(gameAxes, [0 22]);

        drawMazeFrame();
        drawPelletLane();

        laneStart = 4;
        laneEnd = 25;
        pacX = laneStart + round((laneEnd - laneStart) * min(state.progress, 100) / 100);
        pacY = 10;

        ghostBaseX = 29;
        ghostX = max(pacX + 3, ghostBaseX - state.danger * 3);
        ghostX = min(ghostX, 29);
        ghostY = 10;

        if state.danger >= 4 && state.progress < 70
            drawPixelGhost(gameAxes, ghostX, ghostY, colors.red, 0.34);
            drawPixelGhost(gameAxes, ghostX + 2.8, ghostY + 5.8, colors.ghost, 0.22);
        else
            drawPixelGhost(gameAxes, ghostX, ghostY, colors.ghost, 0.34);
        end

        drawPixelPacman(gameAxes, pacX, pacY, colors.yellow, 0.34);

        if state.progress >= 100
            drawPixelText(gameAxes, "LEVEL CLEAR", 10.0, 17.2, colors.green, 0.24);
        elseif state.danger >= 4
            drawPixelText(gameAxes, "RUN", 14.4, 17.2, colors.red, 0.28);
        else
            drawPixelText(gameAxes, "EAT THE GOALS", 8.4, 17.2, colors.pellet, 0.22);
        end

        hold(gameAxes, "off");
    end

    function drawMazeFrame()
        drawWall(1, 1, 32, 1);
        drawWall(1, 20, 32, 1);
        drawWall(1, 1, 1, 20);
        drawWall(32, 1, 1, 20);

        drawWall(3, 3, 6, 1);
        drawWall(12, 3, 8, 1);
        drawWall(24, 3, 6, 1);
        drawWall(3, 17, 6, 1);
        drawWall(12, 17, 8, 1);
        drawWall(24, 17, 6, 1);

        drawWall(6, 5, 1, 4);
        drawWall(27, 5, 1, 4);
        drawWall(6, 12, 1, 4);
        drawWall(27, 12, 1, 4);

        drawWall(12, 6, 2, 3);
        drawWall(20, 6, 2, 3);
        drawWall(12, 13, 2, 3);
        drawWall(20, 13, 2, 3);

        drawWall(15, 8, 4, 1);
        drawWall(15, 12, 4, 1);
    end

    function drawWall(x, y, w, h)
        rectangle(gameAxes, ...
            "Position", [x y w h], ...
            "FaceColor", colors.wall, ...
            "EdgeColor", colors.wallGlow, ...
            "LineWidth", 1.2);
    end

    function drawPelletLane()
        for x = 5:2:27
            if x < 5 + round(22 * min(state.progress, 100) / 100)
                pelletColor = [0.08 0.08 0.12];
            else
                pelletColor = colors.pellet;
            end

            rectangle(gameAxes, ...
                "Position", [x 10.9 0.32 0.32], ...
                "FaceColor", pelletColor, ...
                "EdgeColor", pelletColor);
        end

        rectangle(gameAxes, ...
            "Position", [29.2 10.6 0.9 0.9], ...
            "FaceColor", colors.white, ...
            "EdgeColor", colors.pellet, ...
            "LineWidth", 1.4);
    end

    function drawBars()
        cla(barAxes);
        hold(barAxes, "on");
        xlim(barAxes, [0 100]);
        ylim(barAxes, [0 5]);

        names = ["STEPS", "WORK", "WATER", "SLEEP"];
        values = [
            state.metrics(1) / targets.steps
            state.metrics(2) / targets.workoutMinutes
            state.metrics(3) / targets.waterCups
            state.metrics(4) / targets.sleepHours
        ];
        values = min(max(values, 0), 1);

        for i = 1:4
            y = 5 - i;
            drawPixelText(barAxes, char(names(i)), 2, y + 0.2, colors.text, 0.12);
            rectangle(barAxes, ...
                "Position", [24 y + 0.17 70 0.54], ...
                "FaceColor", [0 0 0], ...
                "EdgeColor", colors.wallGlow, ...
                "LineWidth", 1.0);

            barColor = colors.red;
            if values(i) >= 1
                barColor = colors.green;
            elseif values(i) >= 0.7
                barColor = colors.orange;
            end

            fillWidth = 70 * values(i);
            if fillWidth > 0
                rectangle(barAxes, ...
                    "Position", [24 y + 0.17 fillWidth 0.54], ...
                    "FaceColor", barColor, ...
                    "EdgeColor", barColor);
            end

            drawPixelText(barAxes, sprintf("%3d%%", round(values(i) * 100)), 94.8, y + 0.2, colors.white, 0.11);
        end

        hold(barAxes, "off");
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

        eyeColor = [0 0 0];
        rectangle(ax, ...
            "Position", [x + 1.8 * scale y + 4.6 * scale 0.9 * scale 0.9 * scale], ...
            "FaceColor", eyeColor, ...
            "EdgeColor", eyeColor);
        rectangle(ax, ...
            "Position", [x + 4.4 * scale y + 4.6 * scale 0.9 * scale 0.9 * scale], ...
            "FaceColor", eyeColor, ...
            "EdgeColor", eyeColor);
    end
end

function label = makePixelLabel(parent, textValue, colorValue, fontSize)
label = uilabel(parent, ...
    "Text", textValue, ...
    "HorizontalAlignment", "center", ...
    "FontName", "Courier New", ...
    "FontWeight", "bold", ...
    "FontSize", fontSize, ...
    "FontColor", colorValue, ...
    "BackgroundColor", [0.03 0.04 0.13]);
end

function button = makePixelButton(parent, textValue, bgColor, fontColor)
button = uibutton(parent, "push", ...
    "Text", textValue, ...
    "FontName", "Courier New", ...
    "FontWeight", "bold", ...
    "FontSize", 12, ...
    "BackgroundColor", bgColor, ...
    "FontColor", fontColor);
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

function drawPixelText(ax, textValue, x, y, color, scale)
letters = pixelFont();
cursor = x;
textValue = upper(char(textValue));

for i = 1:numel(textValue)
    ch = textValue(i);
    if ch == ' '
        cursor = cursor + 4 * scale;
        continue;
    end

    key = sprintf("x%d", double(ch));
    if isfield(letters, key)
        drawPixelShape(ax, letters.(key), cursor, y, color, scale);
        cursor = cursor + 6 * scale;
    else
        cursor = cursor + 4 * scale;
    end
end
end

function letters = pixelFont()
p.A = {"01110"; "10001"; "10001"; "11111"; "10001"; "10001"; "10001"};
p.C = {"01111"; "10000"; "10000"; "10000"; "10000"; "10000"; "01111"};
p.D = {"11110"; "10001"; "10001"; "10001"; "10001"; "10001"; "11110"};
p.E = {"11111"; "10000"; "10000"; "11110"; "10000"; "10000"; "11111"};
p.F = {"11111"; "10000"; "10000"; "11110"; "10000"; "10000"; "10000"};
p.G = {"01111"; "10000"; "10000"; "10011"; "10001"; "10001"; "01111"};
p.H = {"10001"; "10001"; "10001"; "11111"; "10001"; "10001"; "10001"};
p.I = {"11111"; "00100"; "00100"; "00100"; "00100"; "00100"; "11111"};
p.K = {"10001"; "10010"; "10100"; "11000"; "10100"; "10010"; "10001"};
p.L = {"10000"; "10000"; "10000"; "10000"; "10000"; "10000"; "11111"};
p.M = {"10001"; "11011"; "10101"; "10101"; "10001"; "10001"; "10001"};
p.N = {"10001"; "11001"; "10101"; "10011"; "10001"; "10001"; "10001"};
p.O = {"01110"; "10001"; "10001"; "10001"; "10001"; "10001"; "01110"};
p.P = {"11110"; "10001"; "10001"; "11110"; "10000"; "10000"; "10000"};
p.R = {"11110"; "10001"; "10001"; "11110"; "10100"; "10010"; "10001"};
p.S = {"01111"; "10000"; "10000"; "01110"; "00001"; "00001"; "11110"};
p.T = {"11111"; "00100"; "00100"; "00100"; "00100"; "00100"; "00100"};
p.U = {"10001"; "10001"; "10001"; "10001"; "10001"; "10001"; "01110"};
p.V = {"10001"; "10001"; "10001"; "10001"; "10001"; "01010"; "00100"};
p.W = {"10001"; "10001"; "10001"; "10101"; "10101"; "10101"; "01010"};
p.Y = {"10001"; "10001"; "01010"; "00100"; "00100"; "00100"; "00100"};
p.Z = {"11111"; "00001"; "00010"; "00100"; "01000"; "10000"; "11111"};
p.exclam = {"00100"; "00100"; "00100"; "00100"; "00100"; "00000"; "00100"};
p.dash = {"00000"; "00000"; "00000"; "11111"; "00000"; "00000"; "00000"};
p.percent = {"11001"; "11010"; "00010"; "00100"; "01000"; "01011"; "10011"};
p.zero = {"01110"; "10001"; "10011"; "10101"; "11001"; "10001"; "01110"};
p.one = {"00100"; "01100"; "00100"; "00100"; "00100"; "00100"; "01110"};
p.two = {"01110"; "10001"; "00001"; "00010"; "00100"; "01000"; "11111"};
p.three = {"11110"; "00001"; "00001"; "01110"; "00001"; "00001"; "11110"};
p.four = {"00010"; "00110"; "01010"; "10010"; "11111"; "00010"; "00010"};
p.five = {"11111"; "10000"; "10000"; "11110"; "00001"; "00001"; "11110"};
p.six = {"01111"; "10000"; "10000"; "11110"; "10001"; "10001"; "01110"};
p.seven = {"11111"; "00001"; "00010"; "00100"; "01000"; "01000"; "01000"};
p.eight = {"01110"; "10001"; "10001"; "01110"; "10001"; "10001"; "01110"};
p.nine = {"01110"; "10001"; "10001"; "01111"; "00001"; "00001"; "11110"};

names = fieldnames(p);
letters = struct();
for i = 1:numel(names)
    name = names{i};
    switch name
        case 'exclam'
            key = sprintf("x%d", double('!'));
        case 'dash'
            key = sprintf("x%d", double('-'));
        case 'percent'
            key = sprintf("x%d", double('%'));
        case 'zero'
            key = sprintf("x%d", double('0'));
        case 'one'
            key = sprintf("x%d", double('1'));
        case 'two'
            key = sprintf("x%d", double('2'));
        case 'three'
            key = sprintf("x%d", double('3'));
        case 'four'
            key = sprintf("x%d", double('4'));
        case 'five'
            key = sprintf("x%d", double('5'));
        case 'six'
            key = sprintf("x%d", double('6'));
        case 'seven'
            key = sprintf("x%d", double('7'));
        case 'eight'
            key = sprintf("x%d", double('8'));
        case 'nine'
            key = sprintf("x%d", double('9'));
        otherwise
            key = sprintf("x%d", double(name));
    end
    letters.(key) = p.(name);
end
end
