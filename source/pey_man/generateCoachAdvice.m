function advice = generateCoachAdvice(summary, options)
%GENERATECOACHADVICE Create short English coaching feedback.

if ~getOption(options, "enableCoachApi", false)
    advice = fallbackAdvice(summary, "template_fallback");
    return;
end

apiKey = getenv("OPENAI_API_KEY");
if strlength(string(apiKey)) == 0
    advice = fallbackAdvice(summary, "template_fallback_no_api_key");
    return;
end

modelName = getOption(options, "coachModel", "gpt-4o-mini");
prompt = composePrompt(summary);

try
    messages(1) = struct( ...
        "role", "system", ...
        "content", "You are a concise fitness coach for a MATLAB hackathon demo. Give safe, non-medical, practical coaching in 2 short bullet points.");
    messages(2) = struct("role", "user", "content", prompt);

    body = struct();
    body.model = modelName;
    body.messages = messages;
    body.temperature = 0.35;
    body.max_tokens = 140;

    opts = weboptions( ...
        "MediaType", "application/json", ...
        "RequestMethod", "post", ...
        "Timeout", 12, ...
        "HeaderFields", ["Authorization", "Bearer " + string(apiKey)]);

    response = webwrite("https://api.openai.com/v1/chat/completions", body, opts);
    text = string(response.choices(1).message.content);
    advice = struct("text", text, "source", "openai_chat_completions");
catch
    advice = fallbackAdvice(summary, "template_fallback_api_error");
end
end

function prompt = composePrompt(summary)
prompt = sprintf([ ...
    "Workout metrics:\n" ...
    "- quality score: %.1f/100\n" ...
    "- fatigue index: %.1f/100\n" ...
    "- confidence index: %.1f/100\n" ...
    "- active minutes: %.1f\n" ...
    "- steps: %d\n" ...
    "- distance: %.3f km (%s)\n" ...
    "- cadence: %.1f steps/min\n" ...
    "- calories: %.1f estimated\n" ...
    "Write coaching that matches these numbers and does not claim medical diagnosis."], ...
    summary.WorkoutQualityScore, summary.FatigueIndex, summary.ConfidenceIndex, ...
    summary.ActiveMinutes, summary.StepCount, summary.DistanceKm, summary.DistanceSource, ...
    summary.CadenceSpm, summary.EstimatedCalories);
end

function advice = fallbackAdvice(summary, source)
if summary.FatigueIndex >= 70
    text = "High fatigue signal. Reduce intensity next session and prioritize recovery before another hard effort.";
elseif summary.FatigueIndex >= 35
    text = "Moderate fatigue signal. Keep the next session steady and watch cadence drop near the end.";
elseif summary.WorkoutQualityScore >= 75
    text = "Strong session. Keep the same rhythm and add a small distance or time target next time.";
else
    text = "Useful baseline session. Aim for a slightly longer active block and steadier cadence next time.";
end
advice = struct("text", string(text), "source", string(source));
end

function value = getOption(options, name, defaultValue)
if isfield(options, name)
    value = options.(name);
else
    value = defaultValue;
end
end

