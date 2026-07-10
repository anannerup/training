# Training

A personal workout tracker: log workout sessions and how much weight you lifted on each set.

## What it does

- **Exercises** — maintain a reusable catalog of exercises (e.g. "Bench Press", "Squat"). Each exercise has two settings:
  - **Include by default** — automatically added to every new workout session.
  - **Uses a barbell** — the first set for that exercise starts pre-filled at the bar weight (20kg) instead of 0.

  Exercises are drag-and-drop reorderable, and that order controls both the exercise list and the order exercises appear in a workout.

- **Workout sessions** — start a workout and it's pre-populated with all exercises marked "include by default." From there you can add or remove exercises for that session.

- **Logging sets** — for each exercise in a session, log a set as weight + reps. The weight field is pre-filled with a sensible starting point: the last set you logged this session, or failing that the last set you logged for that exercise last time, or failing that the exercise's starting weight (bar weight or 0). A tap-to-add plate calculator lets you build up the weight by tapping plate buttons (1.25/2.5/5/10/20kg) instead of typing it.

- **History** — past workout sessions are listed with a summary of sets logged per exercise, and can be deleted.

Everything is scoped to the logged-in user — workouts and set entries are private per account.

## Getting started

See `CLAUDE.md` for setup, commands, and architecture notes.
