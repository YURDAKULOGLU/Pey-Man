# Optional Coaching API

The core project remains MATLAB-only. Optional GPT coaching is also called from MATLAB with `webwrite`; no Python or web app is introduced.

## Secret Handling

Never commit API keys.

Set the key in the local shell before launching MATLAB:

```powershell
$env:OPENAI_API_KEY = "sk-..."
matlab
```

The app reads the key with:

```matlab
getenv("OPENAI_API_KEY")
```

## Behavior

- Default: API disabled, template coach advice is used.
- API enabled: `generateCoachAdvice.m` calls OpenAI Chat Completions from MATLAB.
- Missing key or API error: falls back to deterministic coach advice.
- The model output is non-medical, practical, and short.

## MATLAB Usage

```matlab
opts = struct();
opts.enableCoachApi = true;
opts.coachModel = "gpt-4o-mini";
result = runPeyManPipeline(opts);
disp(result.summary.CoachAdvice.text)
```

## Demo Rule

Do not make the final demo depend on API availability. Coaching is a bonus line in the dashboard or report, not the core scoring path.

