function powerValue = bandPowerWelch(x, fs, bandHz)
%BANDPOWERWELCH Small spectral power helper with FFT fallback.

x = x(:);
x = x - mean(x, "omitnan");
if numel(x) < 4 || all(abs(x) < eps)
    powerValue = 0;
    return;
end

if exist("pwelch", "file") == 2
    [pxx, f] = pwelch(x, [], [], [], fs);
else
    y = fft(x);
    pxx = abs(y).^2 / numel(y);
    f = (0:numel(y)-1)' * fs / numel(y);
end

mask = f >= bandHz(1) & f <= bandHz(2);
if ~any(mask)
    powerValue = 0;
else
    powerValue = trapz(f(mask), pxx(mask));
end
end

