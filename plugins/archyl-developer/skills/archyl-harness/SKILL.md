---
name: archyl-harness
description: Work-session protocol for coding under architecture governance. Wraps any coding task in a governed loop — declare the work before starting (get focused context, advisory leases, and a preflight gate), heartbeat while working, and finish with an outcome that can open an Architecture Change Request. Use whenever you are about to CHANGE code in a project documented in Archyl, especially when other agents or teammates may be working in parallel.
version: 0.1.0
allowed-tools: mcp__archyl__*
---

# Archyl Harness — Work Session Protocol

You are working under the Archyl Harness: every unit of work is declared,
visible to other agents, and closed with an outcome. This is what stops two
agents from silently rewriting the same service, and what keeps the
architecture model in sync with what was actually built.

## The loop

```
plan_work → start_work_session → work → (heartbeat) → finish_work_session
```

### 0. Plan — for non-trivial tasks

```
plan_work(projectId: <uuid>, task: "<the feature or change>")
```

Returns an implementation plan grounded in the documented architecture:
ordered steps referencing real C4 elements, the constraints (guardrails and
ADRs) that bind them, and risks from work in progress. Follow it, or explain
in your finish summary why you deviated. Skip this step for trivial edits.

### 1. Start — BEFORE touching any file

```
start_work_session(
  projectId: <uuid>,
  task: "<what you are about to do, one or two sentences>",
  agentName: "claude-code/<user or CI job>",
)
```

Returns a briefing you MUST read before coding:
- **Session ID** — keep it, every later call needs it.
- **Gate** — `allow`: proceed. `warn`: proceed, but address every listed
  reason (a guardrail that applies, or another agent on the same elements).
  If the start is rejected (`deny`, only with `exclusive: true`): do not
  work around it — report the conflict to the user.
- **Leased elements** — the C4 elements you are now the announced worker on.
- **Conflicts** — elements someone else is actively working on. Coordinate
  or avoid changing them.
- **Context** — the relevant elements, ADRs, guardrails, and owners for the
  task. Prefer this over re-deriving architecture from the repo.

Use `exclusive: true` when your change must not race with anyone (schema
migrations, contract changes).

### 2. While working

- Long task (> ~20 minutes)? Call `heartbeat_work_session(sessionId)` —
  sessions expire after 30 minutes without a heartbeat and lose their leases.
- Unsure of blast radius before an edit? `impact_of(projectId, element)`.
- Check who else is active: `list_work_sessions(projectId, activeOnly: true)`.

### 3. Finish — ALWAYS, even on failure or abandonment

```
finish_work_session(
  sessionId: <uuid>,
  summary: "<what actually happened>",
  decisions: ["<architectural decisions made, if any>"],
  followUps: ["<known leftover work>"],
  createChangeRequest: true,
)
```

- `summary` is not a formality: it is the memory the next agent (or human)
  reads. State what changed, where, and why.
- `decisions` should capture anything ADR-worthy: a new dependency, a
  technology choice, a pattern deviation.
- `createChangeRequest: true` opens a **draft Architecture Change Request**
  carrying your summary and decisions so a human reviews how the C4 model
  should catch up. Use it whenever your change affected the architecture
  (new components, dependencies, contracts, or removed elements). Skip it
  for pure refactors with no architectural footprint.
- If you abandoned the task, still finish with a summary saying so (or call
  the cancel endpoint) — never leave a session dangling on your name.

## Rules

1. One session per unit of work. Do not batch unrelated tasks in one session.
2. Never start work on an element listed in `conflicts` without telling the
   user who holds it.
3. Treat `warn` gate reasons as review comments: resolve them or explain in
   the finish summary why they do not apply.
4. The finish summary is written for a reader who did not watch you work.
