---
name: actor-router
description: Use for any non-trivial task, planning request, "act as ..." request, "setup task", or multi-step work. Picks the right actor agents, model tier, and guardrails before work starts.
---

# Actor router

Plugin `actors`. Spawn one agent per task via the Agent tool with `subagent_type = <actor name>`.

## Roster

| Actor | Model | Use for |
| --- | --- | --- |
| business-analyst | sonnet | requirements, scope, acceptance criteria |
| solution-architect | opus | critical, cross-cutting design only |
| data-analyst | sonnet | reports, metrics, queries |
| ux-designer | sonnet | flows, layout, copy, states |
| backend-dev | sonnet | server code, migrations, services |
| frontend-dev | sonnet (haiku for tiny edits) | UI code |
| qa-tester | sonnet | writes tests only |
| devops | haiku | infra, cron, env, deploy |
| security-reviewer | sonnet | authz, privacy, injection review |
| locator | haiku | find code, files, usages |
| dba-perf | sonnet | indexes, N+1, query review |
| api-contract | sonnet | endpoint shape, errors, versioning |
| tech-writer | haiku | docs, changelog, SKILL.md updates |

## Task type -> combo

| Task | Combo |
| --- | --- |
| New feature | BA -> architect (only if cross-cutting) -> dev -> qa -> security / dba-perf |
| Bug fix | locator -> dev -> qa |
| Report / metrics | data-analyst + BA; gate with user before build |
| UI change | ux + frontend + qa |
| Integration between projects | api-contract + both devs |
| Docs | tech-writer |
| Infra / cron / env | devops |

## Model-tier rule

Cheapest tier that can do it.
- haiku: locate, mechanical work, small edits, docs.
- sonnet: default for dev, analysis, review.
- opus: only cross-cutting design, or when a sonnet result was wrong.

## Guardrails

- Parallel agents never run test suites, migrations, seeders, or DB commands. Main thread runs them serially.
- Give each agent a disjoint file set.
- Main thread assigns migration numbers.
- Agents report files changed.
- Main thread verifies before declaring done.

## Stack detection

| Signal | Load |
| --- | --- |
| `artisan` | stack-laravel |
| `system/` + `application/` (CodeIgniter 3) | stack-ci3 |
| `spark` or `app/Config` | stack-ci4 |
| no-build JS SPA | also stack-vanilla-js |

Project CLAUDE.md and `.claude/skills` override everything here.

## Critical-thinking checklist (every actor)

1. Who reads or uses this?
2. What is the simplest option?
3. What breaks: privacy, backward compatibility, existing data?
4. How will it be verified?

## Planning rule

When the user asks for a plan, enter plan mode first.
