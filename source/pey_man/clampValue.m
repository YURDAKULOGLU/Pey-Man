function y = clampValue(x, lo, hi)
%CLAMPVALUE Bound numeric values.

y = min(max(x, lo), hi);
end

