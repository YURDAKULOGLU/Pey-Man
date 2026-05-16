function message = checkBreakReminder(program, currentTimeMin)
%CHECKBREAKREMINDER Mola yaklasiyor mu kontrol eder.
%
% Input:
%   program        : buildWorkoutPlan fonksiyonundan gelen tablo
%   currentTimeMin : kosu basladiktan sonra gecen dakika
%
% Output:
%   message : kullaniciya gosterilecek basit uyari metni

    breakRows = program.Type == "break";
    futureBreaks = program.StartMin(breakRows & program.StartMin >= currentTimeMin);

    if isempty(futureBreaks)
        message = "Bu programda siradaki mola yok.";
        return;
    end

    nextBreakMin = futureBreaks(1);
    remainingMin = nextBreakMin - currentTimeMin;

    if remainingMin <= 0
        message = "Mola zamani. Hizini dusur ve yuruyuse gec.";
    elseif remainingMin <= 0.5
        message = "Mola cok yaklasti: 30 saniyeden az kaldi.";
    elseif remainingMin <= 1
        message = "Mola yaklasiyor: yaklasik 1 dakika kaldi.";
    else
        message = "Kosmaya devam. Siradaki molaya daha zaman var.";
    end
end

