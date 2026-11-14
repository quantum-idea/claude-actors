---
name: stack-laravel
description: Use when the project has an `artisan` file (Laravel). Covers commands, formatting, tests, Eloquent, queues, migrations, and safe DB handling.
---

# Stack: Laravel

Generic defaults. Project CLAUDE.md and `.claude/skills` win on any conflict.

## Commands

| Need | Command |
| --- | --- |
| Run command | `php artisan <cmd>` (use `herd php` if a Herd project) |
| Routes | `php artisan route:list` |
| Format | `vendor/bin/pint --dirty` |
| Tests | `php artisan test` or `vendor/bin/pest` / `vendor/bin/phpunit` |
| Single test | `php artisan test --filter=Name` |

- If the laravel-boost MCP is available, use it for docs search, schema, and tinker instead of guessing.
- Run Pint on changed files before finishing.

## Rules

- Do not run `migrate`, `migrate:fresh`, `migrate:refresh`, `db:seed` against a dev or prod DB without an explicit ask. Tests use a separate test DB.
- Every migration needs a working `down()`.
- Validation goes in Form Requests, not controllers. Authorize in policies or the request.
- Controllers stay thin; logic in services/actions.
- Mass assignment: define `$fillable`; never `$request->all()` into `create()`.

## Eloquent / performance

- Avoid N+1: eager load with `with()`; check with `Model::preventLazyLoading()` in dev.
- Select only needed columns on large lists; paginate; add indexes for filtered/sorted columns.
- Wrap multi-write operations in `DB::transaction()`.

## Queues / scheduler

- Slow work (mail, exports, webhooks) goes to queued jobs; make jobs idempotent.
- Schedule in `routes/console.php` (or `app/Console/Kernel.php` on older versions).
- Use `Queue::fake()` / `Mail::fake()` in tests.

## Tests

- Feature tests for HTTP behavior, unit tests for pure logic.
- Use factories; `RefreshDatabase` only against the test DB.
- Run one suite at a time if the test DB is shared.
