#!/usr/bin/env bash
# Archyl Agent Integration Setup
# Adds architecture context references to your agent configuration files.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/archyl-com/agent-skills/main/templates/setup.sh | bash
#   # or
#   ./setup.sh

set -euo pipefail

TEMPLATES_URL="https://raw.githubusercontent.com/archyl-com/agent-skills/main/templates"

info() { echo "[archyl] $1"; }
warn() { echo "[archyl] WARNING: $1"; }

# Detect project root (git root or current directory)
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cd "$PROJECT_ROOT"

info "Setting up Archyl agent integration in: $PROJECT_ROOT"

# --- CLAUDE.md ---
CLAUDE_MD="CLAUDE.md"
MARKER="@archyl.txt"

if [ -f "$CLAUDE_MD" ]; then
  if grep -q "$MARKER" "$CLAUDE_MD"; then
    info "CLAUDE.md already references archyl.txt — skipping."
  else
    info "Appending architecture section to CLAUDE.md..."
    echo "" >> "$CLAUDE_MD"
    cat <<'SNIPPET' >> "$CLAUDE_MD"

# Architecture

## Context
@archyl.txt

## Rules

- Before implementing any feature, run `/archyl-preflight` to validate your approach against the documented architecture.
- After shipping a feature, run `/archyl-postship` to update architecture documentation.
- Never introduce a technology that is in "hold" status on the technology radar.
SNIPPET
    info "Done — CLAUDE.md updated."
  fi
else
  info "Creating CLAUDE.md with architecture section..."
  cat <<'SNIPPET' > "$CLAUDE_MD"
# Architecture

## Context
@archyl.txt

## Rules

- Before implementing any feature, run `/archyl-preflight` to validate your approach against the documented architecture.
- After shipping a feature, run `/archyl-postship` to update architecture documentation.
- Never introduce a technology that is in "hold" status on the technology radar.
- All new services must have an API contract documented in Archyl.
- All async communication must go through documented event channels.
SNIPPET
  info "Done — CLAUDE.md created."
fi

# --- .cursorrules ---
CURSORRULES=".cursorrules"

if [ -f "$CURSORRULES" ]; then
  if grep -q "archyl.txt" "$CURSORRULES"; then
    info ".cursorrules already references archyl.txt — skipping."
  else
    info "Appending architecture section to .cursorrules..."
    echo "" >> "$CURSORRULES"
    cat <<'SNIPPET' >> "$CURSORRULES"

# Architecture Context

Read the file `archyl.txt` at the root of this project before implementing any feature.
It contains the C4 architecture model, conformance rules, approved technologies, and API contracts.
SNIPPET
    info "Done — .cursorrules updated."
  fi
else
  info "No .cursorrules found — skipping (create one manually if you use Cursor)."
fi

# --- AGENTS.md ---
AGENTS_MD="AGENTS.md"

if [ ! -f "$AGENTS_MD" ]; then
  info "Creating AGENTS.md..."
  cat <<'SNIPPET' > "$AGENTS_MD"
# Agent Instructions

## Architecture Context

This project's architecture is documented in Archyl and summarized in `archyl.txt`.
All agents MUST read `archyl.txt` before making implementation decisions.

## Pre-Implementation Checklist

Before writing code for any feature:

1. Read `archyl.txt` to understand the current architecture
2. Identify which C4 elements (systems, containers, components) are affected
3. Verify your planned approach respects conformance rules and approved technologies

## Post-Implementation Checklist

After completing a feature:

1. Document any new services, components, or relationships
2. Create an ADR if an architectural decision was made
3. Update API contracts if endpoints were added or changed
SNIPPET
  info "Done — AGENTS.md created."
else
  info "AGENTS.md already exists — skipping."
fi

# --- .gitignore check ---
if [ -f ".gitignore" ]; then
  if grep -q "archyl.txt" ".gitignore"; then
    warn "archyl.txt is in .gitignore — agents won't see it. Consider removing it."
  fi
fi

echo ""
info "Setup complete. Next steps:"
info "  1. Add the generate-context GitHub Action to generate archyl.txt automatically"
info "  2. Install the archyl-developer plugin: /plugin marketplace add archyl-com/agent-skills"
info "  3. Run /archyl-preflight before your next feature"
