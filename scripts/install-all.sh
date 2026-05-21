#!/usr/bin/env bash
# install-all.sh — register this repo as a Claude Code marketplace and install
# every plugin listed in .claude-plugin/marketplace.json.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MARKETPLACE_NAME="anskills"
MANIFEST="$REPO_ROOT/.claude-plugin/marketplace.json"

if ! command -v claude >/dev/null 2>&1; then
  echo "Error: 'claude' CLI not found on PATH. Install Claude Code first: https://docs.claude.com/claude-code" >&2
  exit 1
fi

if [[ ! -f "$MANIFEST" ]]; then
  echo "Error: $MANIFEST not found. Run this from inside the anskills repo." >&2
  exit 1
fi

# Prefer jq; fall back to python if it's missing.
if command -v jq >/dev/null 2>&1; then
  PLUGINS=$(jq -r '.plugins[].name' "$MANIFEST")
elif command -v python3 >/dev/null 2>&1; then
  PLUGINS=$(python3 -c "import json,sys; print('\n'.join(p['name'] for p in json.load(open('$MANIFEST'))['plugins']))")
else
  echo "Error: need 'jq' or 'python3' to parse the marketplace manifest." >&2
  exit 1
fi

echo "==> Adding marketplace from $REPO_ROOT"
claude plugin marketplace add "$REPO_ROOT" || echo "Note: marketplace may already be registered — continuing."

while IFS= read -r PLUGIN; do
  [[ -z "$PLUGIN" ]] && continue
  echo "==> Installing ${PLUGIN}@${MARKETPLACE_NAME}"
  claude plugin install "${PLUGIN}@${MARKETPLACE_NAME}" || echo "  (skipped ${PLUGIN} — may already be installed)"
done <<< "$PLUGINS"

echo
echo "Done. Verify with:  claude plugin list"
