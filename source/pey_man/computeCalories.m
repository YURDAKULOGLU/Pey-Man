function [calories, caloriesByActivity, sportSummary] = computeCalories(features, options)
%COMPUTECALORIES Estimate calories from MET values by activity label.

bodyMassKg = getOption(options, "bodyMassKg", 70);
activityLabel = string(features.activityLabel);
met = 2.0 * ones(height(features), 1);
met(activityLabel == "sit") = 1.2;
met(activityLabel == "walk") = 3.5;
met(activityLabel == "run") = 8.0;
met(activityLabel == "unknown") = 2.0;

minutes = analysisDurationSeconds(features) / 60;
caloriesByWindow = met * 3.5 * bodyMassKg / 200 .* minutes;
calories = round(sum(caloriesByWindow, "omitnan"), 1);

caloriesByActivity = buildCaloriesByActivity(activityLabel, minutes, caloriesByWindow);
sportSummary = summarizeDetectedSport(caloriesByActivity, calories);
end

function value = getOption(options, name, defaultValue)
if isfield(options, name)
    value = options.(name);
else
    value = defaultValue;
end
end

function caloriesByActivity = buildCaloriesByActivity(activityLabel, minutes, caloriesByWindow)
activity = ["sit"; "walk"; "run"; "unknown"];
sport = ["Rest / Recovery"; "Walking"; "Running"; "Unknown"];
met = [1.2; 3.5; 8.0; 2.0];
activityMinutes = zeros(numel(activity), 1);
activityCalories = zeros(numel(activity), 1);
kcalPerMinute = zeros(numel(activity), 1);

for i = 1:numel(activity)
    mask = activityLabel == activity(i);
    activityMinutes(i) = sum(minutes(mask), "omitnan");
    activityCalories(i) = sum(caloriesByWindow(mask), "omitnan");
    if activityMinutes(i) > 0
        kcalPerMinute(i) = activityCalories(i) / activityMinutes(i);
    end
end

caloriesByActivity = table( ...
    activity, ...
    sport, ...
    round(activityMinutes, 2), ...
    round(activityCalories, 1), ...
    round(kcalPerMinute, 2), ...
    met, ...
    'VariableNames', ["activity", "sport", "minutes", "calories", "averageKcalPerMinute", "met"]);
end

function sportSummary = summarizeDetectedSport(caloriesByActivity, totalCalories)
activeMask = caloriesByActivity.activity ~= "sit" & caloriesByActivity.activity ~= "unknown";
activeRows = caloriesByActivity(activeMask, :);
activeMinutes = sum(activeRows.minutes, "omitnan");
totalMinutes = sum(caloriesByActivity.minutes, "omitnan");

if activeMinutes <= 0
    dominantActivity = "sit";
    detectedSport = "Rest / Recovery";
    dominantMinutes = sum(caloriesByActivity.minutes(caloriesByActivity.activity == "sit"), "omitnan");
    dominantCalories = sum(caloriesByActivity.calories(caloriesByActivity.activity == "sit"), "omitnan");
else
    [dominantMinutes, idx] = max(activeRows.minutes);
    dominantActivity = activeRows.activity(idx);
    dominantCalories = activeRows.calories(idx);

    walkMinutes = sum(activeRows.minutes(activeRows.activity == "walk"), "omitnan");
    runMinutes = sum(activeRows.minutes(activeRows.activity == "run"), "omitnan");

    if walkMinutes > 0.25 * activeMinutes && runMinutes > 0.25 * activeMinutes
        detectedSport = "Mixed Walk/Run Session";
    elseif dominantActivity == "run"
        detectedSport = "Running Session";
    else
        detectedSport = "Walking Session";
    end
end

if totalMinutes > 0
    averageCaloriesPerMinute = totalCalories / totalMinutes;
else
    averageCaloriesPerMinute = 0;
end

if activeMinutes > 0
    activeCalories = sum(activeRows.calories, "omitnan");
    activeCaloriesPerMinute = activeCalories / activeMinutes;
else
    activeCaloriesPerMinute = 0;
end

sportSummary = struct();
sportSummary.DetectedSport = detectedSport;
sportSummary.DominantActivity = dominantActivity;
sportSummary.DominantActivityMinutes = round(dominantMinutes, 2);
sportSummary.DominantActivityCalories = round(dominantCalories, 1);
sportSummary.AverageCaloriesPerMinute = round(averageCaloriesPerMinute, 2);
sportSummary.ActiveCaloriesPerMinute = round(activeCaloriesPerMinute, 2);
end
