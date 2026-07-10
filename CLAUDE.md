# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project status

This is a freshly generated Rails 8.1 application (`rails new` skeleton) — no domain models, controllers, or routes have been added yet. `config/routes.rb` only has the default health check route, `db/schema.rb` is empty, and `app/models`/`app/controllers` only contain the base classes. Treat architectural conventions here as "what Rails 8 defaults give you," not as established project patterns — there isn't yet a codebase-specific pattern to infer.

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
