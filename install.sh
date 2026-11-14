#!/usr/bin/env bash
# Local install: register this repo as a marketplace and install the 'actors' plugin.
# Uses the local path so it works without GitHub auth. Re-run safe.
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

claude plugin marketplace add "$DIR" || claude plugin marketplace update claude-actors
claude plugin install actors@claude-actors || claude plugin enable actors@claude-actors

echo "Done. Restart Claude Code, then check: /agents"
