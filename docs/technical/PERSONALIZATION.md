# Personalization

## Starter Scope

Personalization should be lightweight and MATLAB-only for the hackathon starter. It should not require accounts, cloud APIs, or private profile storage.

## User Profile Inputs

The demo can expose these as editable constants in `main.m`:

- body mass in kg,
- stride length in meters,
- baseline duration in seconds,
- daily goal target,
- preferred activity mode.

## Personal Baseline

The first 60 seconds, or the first 20 percent of a short session, becomes the session baseline:

- baseline RMS dynamic acceleration,
- baseline activity ratio,
- baseline cadence frequency,
- baseline intensity.

Fatigue is then scored relative to that person/session, not as a global one-size-fits-all threshold.

## Confidence Index

Sensor outputs are estimates, so Pey-Man reports confidence:

- sample regularity,
- recording duration,
- classifier confidence,
- GPS availability.

Example: `90% confidence: about 1500 steps`.

## Pac-Man Goal UI

The Pac-Man idea is a presentation layer:

- daily goals are pellets,
- completed goals are eaten pellets,
- end-of-day progress makes tomorrow's pellet larger,
- streaks can unlock a bigger pellet or color.

This is valuable for demo polish, but it stays behind the Fatigue Index timeline until the P0 pipeline is green.

## Stretch Sensors

- fall event candidate: acceleration spike plus orientation change plus inactivity window,
- inactivity detection: long low-motion window,
- consistency meter: variance of active windows over time,
- fatigue trend: late-session deviation from baseline.

Fall detection must be presented as a sensor demo, not as a medical or emergency system.

