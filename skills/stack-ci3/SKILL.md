---
name: stack-ci3
description: Use when the project is CodeIgniter 3 (`system/` and `application/` directories, e.g. ~/Herd/smap). Covers layout, migrations, tests, loader and session patterns, escaping and CSRF.
---

# Stack: CodeIgniter 3

Generic defaults. Project CLAUDE.md and `.claude/skills` win on any conflict.

## Layout

`application/{controllers,models,libraries,helpers,views,migrations,config}`; entry `index.php`.

## Commands

| Need | Command |
| --- | --- |
| Migrate | `php index.php migrate` (confirm with user before running on a dev/prod DB) |
| Tests | `vendor-test/bin/phpunit` (check the repo's phpunit config for the path) |
| PHP | `herd php` if a Herd project and plain php mismatches |

## Patterns

- Load deps with `$this->load->model('x_model')`, `->library()`, `->helper()`; then call `$this->x_model->...`.
- Keep controllers thin; heavy logic goes in models or libraries.
- Migrations: sequential/timestamp class in `application/migrations`, with a working `down()`; check `config/migration.php` for the type and version.
- Query Builder with bound params (`$this->db->where()`, `query($sql, [$binds])`); never concatenate user input into SQL.
- Wrap multi-write operations in `$this->db->trans_start()` / `trans_complete()` and check `trans_status()`.

## PHP 8.2+

- Dynamic property creation is deprecated. Declare properties on classes you write (`#[AllowDynamicProperties]` only where unavoidable); CI3 core `$this->load`/`$this->db` usage in controllers needs the property declared or the attribute.
- Watch for passing null to string functions and other 8.x deprecation notices in logs.

## Security

- Output: `html_escape()` in views; do not echo raw user input.
- Input: `$this->input->post('x', TRUE)` for XSS filtering is not a substitute for output escaping.
- CSRF: keep `csrf_protection` on; forms send the token; AJAX sends it in the header or body.
- Sessions: `$this->session->userdata()` / `set_userdata()`; store ids, not large blobs; regenerate on login.
- Do not log or put personal data in URLs.
