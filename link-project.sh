#!/usr/bin/env bash
# Make actors available in project(s) for claude.ai/code (web) via committed .claude/settings.json.
# Usage: ./link-project.sh [--copy] <project-dir>...
#   default : merge extraKnownMarketplaces + enabledPlugins into <project>/.claude/settings.json
#   --copy  : fallback, copy agents/ and skills/ into <project>/.claude/ (no marketplace needed)
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="quantum-idea/claude-actors"
MODE="marketplace"

if [ "${1:-}" = "--copy" ]; then MODE="copy"; shift; fi
[ "$#" -ge 1 ] || { echo "usage: $0 [--copy] <project-dir>..." >&2; exit 1; }

for P in "$@"; do
  P="$(cd "$P" && pwd)"
  mkdir -p "$P/.claude"

  if [ "$MODE" = "copy" ]; then
    mkdir -p "$P/.claude/agents" "$P/.claude/skills"
    cp "$DIR"/agents/*.md "$P/.claude/agents/"
    cp -R "$DIR"/skills/. "$P/.claude/skills/"
    echo "copied actors into $P/.claude"
    continue
  fi

  python3 - "$P/.claude/settings.json" "$REPO" <<'PY'
import json, os, sys
path, repo = sys.argv[1], sys.argv[2]
data = {}
if os.path.exists(path):
    with open(path) as f:
        data = json.load(f)
data.setdefault("extraKnownMarketplaces", {})["claude-actors"] = {
    "source": {"source": "github", "repo": repo}
}
data.setdefault("enabledPlugins", {})["actors@claude-actors"] = True
with open(path, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY
  echo "linked $P/.claude/settings.json (commit it to sync web)"
done
