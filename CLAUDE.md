# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project status

This is a Rails 8.1 app: a personal workout tracker. See `README.md` for what the app does from a user's perspective. Authentication (`User`/`Session`, Rails' generated auth) gates everything behind login — there is no public signup flow, only `sessions`/`passwords` controllers.

Domain models, in dependency order:
- `Exercise` — the catalog of exercises (e.g. "Bench Press"). Has `default_selected` (pre-add this exercise to every new workout) and `uses_barbell` (start weight at `Exercise::BARBELL_WEIGHT`, 20kg, instead of 0). Ordered by a manually maintained `position` column, reordered via drag-and-drop (`PATCH /exercises/reorder`).
- `WorkoutSession` — one logged workout, `belongs_to :user`. Created via `WorkoutSessionsController#create`, which auto-populates it with every `Exercise.default_selected`.
- `WorkoutExercise` — join model between a `WorkoutSession` and an `Exercise` (unique per session), also positioned/orderable. `#default_next_weight` picks the pre-filled weight for the next set: last set logged this session, else the last set logged for that exercise in the user's most recent prior session, else the exercise's starting weight.
- `SetEntry` — one logged set (`weight` + `reps`) on a `WorkoutExercise`, auto-numbered via `set_number`.

Frontend notes specific to this app:
- `app/javascript/controllers/plate_calculator_controller.js` — lets a user tap barbell-plate buttons to build up the weight field instead of typing, on the set-logging form.
- `app/javascript/controllers/sortable_controller.js` — native HTML5 drag-and-drop reordering, used for the exercise list; deliberately touch-first (iOS Safari), not cross-platform.
- Set logging (`set_entries`) is Turbo Stream-driven (`create`/`update`/`destroy.turbo_stream.erb`) for inline add/edit/remove without full page reloads.

## Commands

Bundle install and full local setup (bundle install, db:prepare, clear logs, then boots the dev server):
```
bin/setup
```
Use `bin/setup --skip-server` to set up without starting the server, or `--reset` to also `db:reset`.

Run the dev server:
```
bin/dev
```
(currently just runs `bin/rails server`)

Run the full test suite (mirrors CI's `test` job):
```
bin/rails db:test:prepare test
```

Run a single test file:
```
bin/rails test test/models/some_model_test.rb
```

Run a single test by line number:
```
bin/rails test test/models/some_model_test.rb:12
```

Run system tests (mirrors CI's `system-test` job; requires libvips installed locally):
```
bin/rails db:test:prepare test:system
```

Lint (Omakase Rubocop config, mirrors CI):
```
bin/rubocop
```

Security scans (mirrors CI's `scan_ruby`/`scan_js` jobs):
```
bin/brakeman --no-pager
bin/bundler-audit
bin/importmap audit
```

Rails console / generators / migrations — use `bin/rails` as the entry point (`bin/rails console`, `bin/rails generate ...`, `bin/rails db:migrate`), not a bare `rails` or `rake`.

## Architecture

- **Database**: SQLite via the `sqlite3` gem, one database per Rails 8 "Solid" component: `storage/development.sqlite3` (primary) plus separate databases for `solid_cache`, `solid_queue`, and `solid_cable` in production (see `config/database.yml`). Each has its own migration path (`db/cache_migrate`, `db/queue_migrate`, `db/cable_migrate`) — migrations for these live outside the main `db/migrate`.
- **Background jobs**: `solid_queue` (DB-backed, no Redis dependency). Job classes go in `app/jobs`, inheriting from `ApplicationJob`.
- **Caching / Action Cable**: also DB-backed via `solid_cache` / `solid_cable` — no Redis/Memcached required for a base install.
- **Frontend**: Hotwire stack — `turbo-rails` + `stimulus-rails` with `importmap-rails` for JS (no Node/webpack build step; JS controllers live in `app/javascript/controllers`). Assets are served through `propshaft`, not Sprockets.
- **Views**: standard ERB in `app/views`; `jbuilder` is available for JSON API responses.
- **Deployment**: Dockerized via the generated `Dockerfile`, deployed with `kamal` (config in `.kamal/`, `config/deploy.yml` when added). `thruster` sits in front of Puma in production for HTTP asset caching/compression.
- **CI** (`.github/workflows/ci.yml`) runs four independent jobs on every PR/push to `main`: `scan_ruby` (brakeman + bundler-audit), `scan_js` (importmap audit), `lint` (rubocop), `test`, and `system-test`. Match these when validating changes locally before pushing.
