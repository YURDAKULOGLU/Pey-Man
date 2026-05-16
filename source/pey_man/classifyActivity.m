function features = classifyActivity(features, model)
%CLASSIFYACTIVITY Assign sit/walk/run labels with ML if available.

X = featurePredictorTable(features, model.predictorNames);

if model.type == "fitctree"
    [label, score] = predict(model.trainedModel, X);
    features.activityLabel = categorical(label);
    features.modelConfidence = max(score, [], 2);
    return;
end

label = repmat("sit", height(features), 1);
active = features.rmsDynAcc > 0.12 | features.activeRatio > 0.15 | features.dominantHz > 0.6;
running = features.rmsDynAcc > 0.55 | features.dominantHz > 2.15 | features.peakCount >= 8;
label(active) = "walk";
label(running) = "run";

features.activityLabel = categorical(label);
margin = abs(features.rmsDynAcc - median(features.rmsDynAcc, "omitnan"));
features.modelConfidence = clampValue(0.60 + 0.40 * normalize01(margin), 0.55, 0.95);
end

function y = normalize01(x)
lo = min(x, [], "omitnan");
hi = max(x, [], "omitnan");
if ~isfinite(lo) || ~isfinite(hi) || abs(hi - lo) < eps
    y = zeros(size(x));
else
    y = (x - lo) ./ (hi - lo);
end
end

