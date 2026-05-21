#!/usr/bin/env bash
# install.sh — register this repo as a Claude Code marketplace and install
# the business-plan-research plugin from it.
#
# Usage:
#   ./scripts/install.sh                  # install business-plan-research (default)
#   ./scripts/install.sh <plugin-name>    # install a specific plugin from this marketplace

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MARKETPLACE_NAME="anskills"
DEFAULT_PLUGIN="business-plan-research"
PLUGIN="${1:-$DEFAULT_PLUGIN}"

if ! command -v claude >/dev/null 2>&1; then
  cat <<EOF >&2
Error: 'claude' CLI not found on PATH.

Install Claude Code first:  https://docs.claude.com/claude-code

Then re-run this script.
EOF
  exit 1
fi

if [[ ! -f "$REPO_ROOT/.claude-plugin/marketplace.json" ]]; then
  echo "Error: $REPO_ROOT/.claude-plugin/marketplace.json not found. Run this script from inside the anskills repo." >&2
  exit 1
fi

echo "==> Adding marketplace from $REPO_ROOT"
claude plugin marketplace add "$REPO_ROOT" || {
  echo "Note: marketplace may already be registered — continuing."
}

echo "==> Installing plugin: ${PLUGIN}@${MARKETPLACE_NAME}"
claude plugin install "${PLUGIN}@${MARKETPLACE_NAME}"

echo
echo "Done. Verify with:  claude plugin list"
echo "Open a new Claude Code session and the skill will be available."
