function X = featurePredictorTable(features, predictorNames)
%FEATUREPREDICTORTABLE Return numeric predictors for activity ML.

if nargin < 2 || isempty(predictorNames)
    predictorNames = ["meanDynAcc", "stdDynAcc", "rmsDynAcc", "peakCount", ...
        "activeRatio", "dominantHz", "spectralPower", "speedMps"];
end

X = features(:, predictorNames);
for i = 1:numel(predictorNames)
    name = predictorNames(i);
    values = X.(name);
    if any(~isfinite(values))
        values(~isfinite(values)) = 0;
        X.(name) = values;
    end
end
end

