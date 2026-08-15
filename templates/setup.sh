#!/usr/bin/env bash
# Archyl Harness Setup
# One command to make your coding agents architecture-aware:
#   - .mcp.json        → Archyl MCP server with the 13-tool coding profile
#   - .archyl.json     → project binding for the Guard hook (no secrets)
#   - CLAUDE.md        → the harness work-session loop for Claude Code
#   - AGENTS.md        → the same rules for any other agent
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/archyl-com/agent-skills/main/templates/setup.sh | bash
#   # or, non-interactively:
#   ARCHYL_API_KEY=arch_... ARCHYL_PROJECT_ID=<uuid> ./setup.sh

set -euo pipefail

info() { echo "[archyl] $1"; }
warn() { echo "[archyl] WARNING: $1"; }

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cd "$PROJECT_ROOT"
info "Setting up the Archyl Harness in: $PROJECT_ROOT"

# --- Gather configuration ---------------------------------------------------
API_URL="${ARCHYL_API_URL:-https://api.archyl.com}"
API_KEY="${ARCHYL_API_KEY:-}"
PROJECT_ID="${ARCHYL_PROJECT_ID:-}"

prompt() {
  # curl | bash leaves stdin busy; read from the terminal when we can.
  local var_name=$1 label=$2 value=""
  if [ -r /dev/tty ]; then
    printf "[archyl] %s: " "$label" > /dev/tty
    IFS= read -r value < /dev/tty || true
  fi
  printf '%s' "$value"
}

if [ -z "$PROJECT_ID" ]; then
  PROJECT_ID=$(prompt PROJECT_ID "Archyl project ID (Project → Settings → General)")
fi
if [ -z "$API_KEY" ]; then
  API_KEY=$(prompt API_KEY "Archyl API key with write scope (Profile → API Keys, or leave empty to configure later)")
fi

if [ -z "$PROJECT_ID" ]; then
  warn "No project ID provided — writing agent files only. Re-run with ARCHYL_PROJECT_ID set to finish."
fi

# --- .archyl.json (committable: no secrets) ---------------------------------
if [ -n "$PROJECT_ID" ]; then
  if [ -f ".archyl.json" ]; then
    info ".archyl.json already exists — leaving it untouched."
  else
    cat > .archyl.json <<JSON
{
  "apiUrl": "$API_URL",
  "projectId": "$PROJECT_ID"
}
JSON
    info "Created .archyl.json (safe to commit — the API key stays in your environment)."
  fi
fi

# --- .mcp.json (Archyl MCP server, coding profile) --------------------------
MCP_URL="$API_URL/mcp?profile=coding"
mcp_entry() {
  cat <<JSON
{
  "type": "http",
  "url": "$MCP_URL",
  "headers": { "X-API-Key": "\${ARCHYL_API_KEY}" }
}
JSON
}
MCP_ENTRY=$(mcp_entry)

if [ ! -f ".mcp.json" ]; then
  cat > .mcp.json <<JSON
{
  "mcpServers": {
    "archyl": {
      "type": "http",
      "url": "$MCP_URL",
      "headers": { "X-API-Key": "\${ARCHYL_API_KEY}" }
    }
  }
}
JSON
  info "Created .mcp.json — Archyl MCP with the coding profile (13 tools)."
elif grep -q '"archyl"' .mcp.json; then
  info ".mcp.json already has an archyl server — leaving it untouched."
elif command -v jq >/dev/null 2>&1; then
  tmp=$(mktemp)
  jq --argjson entry "$MCP_ENTRY" '.mcpServers.archyl = $entry' .mcp.json > "$tmp" && mv "$tmp" .mcp.json
  info "Added the archyl server to your existing .mcp.json."
else
  warn ".mcp.json exists and jq is missing — add this entry to mcpServers manually:"
  echo "  \"archyl\": $MCP_ENTRY"
fi

# --- CLAUDE.md --------------------------------------------------------------
CLAUDE_MD="CLAUDE.md"
# Emitted via a function: bash 3.2 (macOS default) mis-parses $(...) around a
# heredoc whose body contains backticks.
harness_snippet() {
  cat <<'SNIPPET'

# Architecture — Archyl Harness

This project's architecture is documented in Archyl. Work under the harness loop:

1. For any non-trivial task, call `plan_work` first — it returns an implementation
   plan grounded in the documented architecture.
2. BEFORE changing code, call `start_work_session` (task + your agent name).
   Read the briefing: gate verdict, leased elements, conflicts, decisions, guardrails.
3. While working, respect every guardrail; call `heartbeat_work_session` on long tasks.
4. When done (or abandoning), call `finish_work_session` with an honest summary and
   any architectural decisions. Set `createChangeRequest: true` when the architecture
   changed — a human reviews how the model catches up.
5. Never introduce a technology that is in "hold" status on the technology radar.
SNIPPET
}

if [ -f "$CLAUDE_MD" ] && grep -q "Archyl Harness" "$CLAUDE_MD"; then
  info "CLAUDE.md already references the harness — skipping."
else
  harness_snippet >> "$CLAUDE_MD"
  info "CLAUDE.md updated with the harness loop."
fi

# --- AGENTS.md --------------------------------------------------------------
AGENTS_MD="AGENTS.md"
if [ -f "$AGENTS_MD" ] && grep -q "Archyl Harness" "$AGENTS_MD"; then
  info "AGENTS.md already references the harness — skipping."
else
  harness_snippet >> "$AGENTS_MD"
  info "AGENTS.md updated with the harness loop."
fi

# --- Wrap up ----------------------------------------------------------------
echo ""
info "Setup complete. Remaining steps:"
if [ -n "$API_KEY" ]; then
  info "  1. Put the API key in your shell profile so agents (and the Guard) find it:"
  info "       export ARCHYL_API_KEY=$API_KEY"
  if [ -n "$PROJECT_ID" ]; then
    info "       export ARCHYL_PROJECT_ID=$PROJECT_ID"
  fi
else
  info "  1. export ARCHYL_API_KEY=<your key>   (Profile → API Keys, write scope)"
  info "     export ARCHYL_PROJECT_ID=$PROJECT_ID"
fi
info "  2. In Claude Code, install the plugin (skills + Guard hook):"
info "       /plugin marketplace add archyl-com/agent-skills"
info "       /plugin install archyl-developer@archyl-marketplace"
info "  3. Ask your agent for any change — it will plan, open a work session,"
info "     and appear live in your project's Fleet console."
