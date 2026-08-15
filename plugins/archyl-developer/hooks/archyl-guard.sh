#!/usr/bin/env bash
# Archyl Guard — PreToolUse hook.
#
# Before the agent writes a file, run the project's Archyl conformance rules
# against the content it is about to write. Critical violations block the edit
# with an explanation; high-severity ones let it through with a warning the
# agent sees. Everything is fail-open: no config, no network, no jq → the edit
# proceeds untouched.
#
# Configuration (environment, or .archyl.json at the git root):
#   ARCHYL_API_KEY       required to activate the guard
#   ARCHYL_PROJECT_ID    required to activate the guard
#   ARCHYL_API_URL       default https://api.archyl.com
#   ARCHYL_GUARD_BLOCK   critical (default) | high | off
#
# .archyl.json example: {"apiUrl": "...", "projectId": "...", "apiKey": "..."}
# (prefer the env var for the key; the file is for URL/project.)

set -u

command -v jq >/dev/null 2>&1 || exit 0
command -v curl >/dev/null 2>&1 || exit 0

INPUT=$(cat)

FILE_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty')
[ -n "$FILE_PATH" ] || exit 0

# --- Resolve configuration ---
API_URL="${ARCHYL_API_URL:-}"
API_KEY="${ARCHYL_API_KEY:-}"
PROJECT_ID="${ARCHYL_PROJECT_ID:-}"
BLOCK_LEVEL="${ARCHYL_GUARD_BLOCK:-critical}"

if [ -z "$API_KEY" ] || [ -z "$PROJECT_ID" ]; then
  ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
  if [ -f "$ROOT/.archyl.json" ]; then
    API_URL="${API_URL:-$(jq -r '.apiUrl // empty' "$ROOT/.archyl.json")}"
    API_KEY="${API_KEY:-$(jq -r '.apiKey // empty' "$ROOT/.archyl.json")}"
    PROJECT_ID="${PROJECT_ID:-$(jq -r '.projectId // empty' "$ROOT/.archyl.json")}"
  fi
fi

[ "$BLOCK_LEVEL" = "off" ] && exit 0
[ -n "$API_KEY" ] && [ -n "$PROJECT_ID" ] || exit 0
API_URL="${API_URL:-https://api.archyl.com}"
API_URL="${API_URL%/}"

# --- Build the content the agent is about to write ---
TOOL_NAME=$(printf '%s' "$INPUT" | jq -r '.tool_name // empty')

CONTENT=""
case "$TOOL_NAME" in
  Write)
    CONTENT=$(printf '%s' "$INPUT" | jq -r '.tool_input.content // empty')
    ;;
  Edit|MultiEdit)
    # Apply the proposed replacement(s) to the current file content so the
    # rules see the file as it would be after the edit.
    command -v python3 >/dev/null 2>&1 || exit 0
    [ -f "$FILE_PATH" ] || exit 0
    CONTENT=$(printf '%s' "$INPUT" | python3 -c '
import json, sys

hook = json.load(sys.stdin)
tool_input = hook.get("tool_input", {})
path = tool_input.get("file_path", "")
try:
    with open(path, encoding="utf-8", errors="replace") as f:
        content = f.read()
except OSError:
    sys.exit(0)

edits = tool_input.get("edits") or [tool_input]
for edit in edits:
    old = edit.get("old_string", "")
    new = edit.get("new_string", "")
    if old:
        content = content.replace(old, new, -1 if edit.get("replace_all") else 1)
print(content, end="")
' 2>/dev/null)
    ;;
  *)
    exit 0
    ;;
esac
[ -n "$CONTENT" ] || exit 0

# Path relative to the repo root, matching what conformance rules expect.
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
REL_PATH="${FILE_PATH#"$ROOT"/}"

PAYLOAD=$(jq -n \
  --arg path "$REL_PATH" \
  --arg content "$CONTENT" \
  '{
    branch: "archyl-guard",
    changedFiles: [{path: $path, status: "modified"}],
    fileContents: {($path): $content}
  }')

RESPONSE=$(curl -sS -m 15 -X POST \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $API_KEY" \
  -d "$PAYLOAD" \
  "$API_URL/api/v1/projects/$PROJECT_ID/conformance/check" 2>/dev/null) || exit 0

CRITICAL=$(printf '%s' "$RESPONSE" | jq -r '.summary.critical // 0' 2>/dev/null) || exit 0
HIGH=$(printf '%s' "$RESPONSE" | jq -r '.summary.high // 0' 2>/dev/null) || exit 0
case "$CRITICAL$HIGH" in *[!0-9]*) exit 0 ;; esac

DETAILS=$(printf '%s' "$RESPONSE" | jq -r '
  [.violations[]? | select(.severity == "critical" or .severity == "high")][:5][] |
  "- [\(.severity)] \(.title)\(if .suggestion != "" then " — " + .suggestion else "" end)"' 2>/dev/null)

BLOCKING=$CRITICAL
[ "$BLOCK_LEVEL" = "high" ] && BLOCKING=$((CRITICAL + HIGH))

if [ "$BLOCKING" -gt 0 ]; then
  jq -n --arg reason "Archyl Guard: this change violates the project's architecture rules for $REL_PATH:
$DETAILS

Adjust the change to respect these rules, or ask the user whether to override them." \
    '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny", permissionDecisionReason: $reason}}'
  exit 0
fi

if [ "$((CRITICAL + HIGH))" -gt 0 ]; then
  jq -n --arg msg "Archyl Guard: $((CRITICAL + HIGH)) high-severity architecture warning(s) on $REL_PATH:
$DETAILS" \
    '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "allow"}, systemMessage: $msg}'
  exit 0
fi

exit 0
