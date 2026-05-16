function calories = computeCalories(features, options)
%COMPUTECALORIES Estimate calories from MET values by activity label.

bodyMassKg = getOption(options, "bodyMassKg", 70);
met = zeros(height(features), 1);
met(features.activityLabel == "sit") = 1.2;
met(features.activityLabel == "walk") = 3.5;
met(features.activityLabel == "run") = 8.0;
met(features.activityLabel == "unknown") = 2.0;

minutes = analysisDurationSeconds(features) / 60;
caloriesByWindow = met * 3.5 * bodyMassKg / 200 .* minutes;
calories = round(sum(caloriesByWindow, "omitnan"), 1);
end

function value = getOption(options, name, defaultValue)
if isfield(options, name)
    value = options.(name);
else
    value = defaultValue;
end
end

