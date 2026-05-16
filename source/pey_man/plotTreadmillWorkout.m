function plotTreadmillWorkout(program)
%PLOTTREADMILLWORKOUT Programi kosu bandi ekrani gibi cizer.
%
% X ekseni zaman, Y ekseni hedef hizdir. Renkler aktivite tipini gosterir:
% warmup/cooldown: mavi, run: yesil, break: sari.

    figure('Name', 'Treadmill Workout Plan', 'Color', 'w');
    hold on; grid on;

    for i = 1:height(program)
        x = [program.StartMin(i), program.EndMin(i)];
        y = [program.TargetSpeedKmh(i), program.TargetSpeedKmh(i)];

        blockColor = getBlockColor(program.Type(i));

        % Kalin yatay cizgi kosu bandindaki hedef hiz seviyesini temsil eder.
        plot(x, y, 'LineWidth', 8, 'Color', blockColor);

        % Her blogun baslangicinda dikey yardimci cizgi.
        xline(program.StartMin(i), ':', 'Color', [0.65 0.65 0.65]);

        % Blogun ortasina aktivite adini yaz.
        midPoint = mean(x);
        text(midPoint, program.TargetSpeedKmh(i) + 0.25, program.Type(i), ...
            'HorizontalAlignment', 'center', ...
            'FontWeight', 'bold');
    end

    xline(program.EndMin(end), ':', 'Color', [0.65 0.65 0.65]);

    xlabel('Time (min)');
    ylabel('Target speed (km/h)');
    title('Personalized Treadmill-Style Running Plan');
    ylim([0, max(program.TargetSpeedKmh) + 2]);
    xlim([0, program.EndMin(end)]);
end

function blockColor = getBlockColor(blockType)
%GETBLOCKCOLOR Aktivite tipine gore grafik rengi dondurur.

    switch string(blockType)
        case "run"
            blockColor = [0.10 0.60 0.25];  % green
        case "break"
            blockColor = [0.95 0.70 0.10];  % yellow/orange
        otherwise
            blockColor = [0.10 0.35 0.85];  % blue
    end
end

