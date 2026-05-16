function program = buildWorkoutPlan(features)
%BUILDWORKOUTPLAN Kullanici ozelliklerine gore kosu/mola programi uretir.
%
% Mantik:
% - Kullanici cabuk yoruluyorsa kosu bloklari kisa tutulur.
% - Kullanici daha stabil kosuyorsa kosu bloklari uzatilir.
% - Hedef hiz gecmis ortalama hiza yakin secilir.

    targetSpeed = max(4.5, round(features.AvgSpeedKmh, 1));

    if features.FitnessScore < 9
        % Baslangic seviyesi: daha sik mola
        runBlockMin = 4;
        breakMin = 1.5;
        repeatCount = 3;
    elseif features.FitnessScore < 13
        % Orta seviye
        runBlockMin = 6;
        breakMin = 1;
        repeatCount = 3;
    else
        % Daha iyi kondisyon: daha uzun kosu bloklari
        runBlockMin = 8;
        breakMin = 1;
        repeatCount = 3;
    end

    warmupMin = 3;
    cooldownMin = 3;
    warmupSpeed = min(max(3.5, targetSpeed - 3), 6);
    breakSpeed = min(max(3.2, targetSpeed - 3.5), 5.5);
    cooldownSpeed = min(max(3.2, targetSpeed - 3), 5.5);

    type = strings(0, 1);
    startMin = [];
    endMin = [];
    speedKmh = [];

    currentTime = 0;

    % Isinma
    [type, startMin, endMin, speedKmh, currentTime] = addBlock( ...
        type, startMin, endMin, speedKmh, currentTime, ...
        "warmup", warmupMin, warmupSpeed);

    % Kosu ve mola bloklari
    for i = 1:repeatCount
        [type, startMin, endMin, speedKmh, currentTime] = addBlock( ...
            type, startMin, endMin, speedKmh, currentTime, ...
            "run", runBlockMin, targetSpeed);

        % Son kosu blogundan sonra ekstra mola koymaya gerek yok.
        if i < repeatCount
            [type, startMin, endMin, speedKmh, currentTime] = addBlock( ...
                type, startMin, endMin, speedKmh, currentTime, ...
                "break", breakMin, breakSpeed);
        end
    end

    % Soguma
    [type, startMin, endMin, speedKmh, ~] = addBlock( ...
        type, startMin, endMin, speedKmh, currentTime, ...
        "cooldown", cooldownMin, cooldownSpeed);

    program = table(type, startMin, endMin, speedKmh, ...
        'VariableNames', {'Type', 'StartMin', 'EndMin', 'TargetSpeedKmh'});
end

function [type, startMin, endMin, speedKmh, currentTime] = addBlock( ...
    type, startMin, endMin, speedKmh, currentTime, blockType, durationMin, targetSpeed)
%ADDBLOCK Programa tek bir zaman blogu ekler.

    type(end + 1, 1) = blockType;
    startMin(end + 1, 1) = currentTime;
    endMin(end + 1, 1) = currentTime + durationMin;
    speedKmh(end + 1, 1) = targetSpeed;

    currentTime = currentTime + durationMin;
end
