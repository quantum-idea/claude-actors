---
name: stack-ci4
description: Use when the project is CodeIgniter 4 (`spark` file or `app/Config`, e.g. ~/Herd/cts). Covers spark, Shield auth, Config classes, migrations, transactions, and test DB traps.
---

# Stack: CodeIgniter 4

Generic defaults. Project CLAUDE.md and `.claude/skills` win on any conflict.

## Commands

| Need | Command |
| --- | --- |
| Run spark | `php spark <cmd>` (Herd project: `herd php spark ...`) |
| Routes | `php spark routes` |
| Tests | `vendor/bin/phpunit [path]` (Herd: `herd php vendor/bin/phpunit`) |
| Composer | `herd composer ...` in a Herd project |

- In a Herd project always use `herd php` / `herd composer`; plain php may be a different version and fail the platform check.
- No `flock`/`timeout` on macOS; use `perl -e 'alarm N; exec @ARGV' -- <cmd>`.

## Rules

- ONE phpunit run at a time; the test DB is shared. Parallel agents never run it.
- Never run `spark migrate`, `migrate:refresh`, `migrate:rollback`, or `db:seed` against the dev DB unless asked. Rollback/refresh ignore the test group.
- Migrations live in `app/Database/Migrations/YYYY-MM-DD-NNNNNN_Name.php`; `down()` must work (round-trip test).
- Config lives in `app/Config/*` classes; read env overrides via `.env`, never commit `.env`.
- Routes in `app/Config/Routes.php`; apply filters (auth, CSRF, API key) per group; add new routes to any route-policy test.

## Patterns

- Shield: auth via `auth()`, groups/permissions in `app/Config/AuthGroups.php`; enforce server-side, UI hiding is cosmetic.
- Thin controllers; business logic in `app/Libraries` or services.
- Transactions: `$db->transException(true)` + try/catch, `transRollback()` on failure.
- Out-of-scope resources return 404, not 403.

## Test traps

- MySQL `TRUNCATE` causes an implicit commit and breaks transaction-rollback tests; use `emptyTable()`.
- Seeders running in a transaction can roll back silently; check row counts after seeding.
- Do not assume SQLite works for MySQL-specific migrations.
