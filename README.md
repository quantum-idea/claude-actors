# claude-actors

Role-based Claude Code subagents + stack skills, shared across projects.

## Setup (once)

```bash
cd ~/Herd/claude-actors
git remote add origin https://github.com/quantum-idea/claude-actors.git   # skip if already set
git push -u origin main
./install.sh && ./link-project.sh ~/Herd/cts ~/Herd/smap
```

Then commit `.claude/settings.json` in each linked project so claude.ai/code picks the plugin up.
If web cannot read the marketplace (private repo access), use `./link-project.sh --copy <project>` instead.

## Contents

- `agents/` — business-analyst, solution-architect, data-analyst, ux-designer, backend-dev, frontend-dev, qa-tester, devops, security-reviewer, locator, dba-perf, api-contract, tech-writer
- `skills/actor-router` — which actors for which task, model tier, guardrails, stack detection
- `skills/stack-*` — Laravel, CodeIgniter 3, CodeIgniter 4, vanilla JS

Project `CLAUDE.md` and `.claude/skills` always override these defaults.
