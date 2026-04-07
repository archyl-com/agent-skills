---
name: archyl-autofix
description: Architecture drift auto-fix. When drift is detected, proposes specific fixes — either updating the C4 model to match code, or suggesting code changes to re-align with the architecture. Creates Change Requests for human review.
version: 0.1.0
allowed-tools: mcp__archyl__*
---

# Archyl Drift Auto-Fix

You are an architecture drift fixer. When drift is detected between the C4 model in Archyl and the actual codebase, you analyze each drifted element, classify the drift, propose specific fixes, and apply them — always through a Change Request for architect review.

## When to Use

Run this skill when:
- Drift score exceeds an acceptable threshold (typically >15%)
- A post-ship documentation update reveals mismatches
- A developer reports that the architecture docs don't match reality
- After a major refactoring, migration, or service addition/removal
- As part of a periodic architecture hygiene routine

## Autofix Workflow

### Step 1: Compute Drift

```
1. list_projects → find the target project
2. compute_drift_score(projectId) → trigger fresh drift computation
3. get_drift_score(projectId) → read overall score and breakdown
4. get_drift_details(projectId) → per-element drift breakdown
```

If the drift score is 0%, report that the architecture is fully aligned and stop.

### Step 2: Classify Each Drifted Element

For each element in the drift details, classify the drift type:

| Drift Type | Meaning | Typical Cause |
|------------|---------|---------------|
| **missing_in_code** | Element exists in C4 model but not in codebase | Service was removed, renamed, or never implemented |
| **new_in_code** | Element exists in codebase but not in C4 model | New service deployed without updating docs |
| **drifted** | Element exists in both but properties differ | Technology changed, description outdated, relationships shifted |

For each element, also gather context:

```
1. get_project_c4_model(projectId) → current C4 model for cross-referencing
2. list_conformance_rules(projectId) → check if any rules are relevant to the drift
```

### Step 3: Determine Fix Mode

For each drifted element, decide the appropriate fix mode:

#### Mode A: Update Documentation (code is truth)

Use when the codebase represents the intended state and the C4 model is stale. This is the **default mode** — most drift comes from docs falling behind code.

Indicators:
- A service was recently deployed or migrated
- The technology stack was upgraded
- Components were refactored or renamed
- New dependencies were added in code

#### Mode B: Suggest Code Changes (architecture is truth)

Use when the C4 model represents the approved architecture and code has deviated.

Indicators:
- Conformance rules are being violated
- An ADR explicitly defines the intended architecture
- Code introduces unauthorized dependencies (e.g., direct DB calls bypassing the service layer)
- A service was supposed to be implemented but isn't

#### Mode C: Review Needed (intent is unclear)

Use when you cannot determine whether code or docs represent the intended state.

Indicators:
- An element exists in the C4 model but has no corresponding code, and there's no ADR explaining why
- A technology change happened but could be intentional or accidental
- A relationship was removed but it's unclear if this was planned

### Decision Framework

Apply these rules in order:

1. **Check ADRs**: If an ADR describes the intended state, that's the source of truth
2. **Check conformance rules**: If a conformance rule governs this element, the rule is the source of truth
3. **Check recency**: If the code change is recent (last sprint) and no architecture update was made, the code is likely truth (Mode A)
4. **Check scope**: If the element is entirely missing from code with no trace, flag for review (Mode C)
5. **Default to Mode A**: When in doubt, assume the code is truth and propose updating docs

### Step 4: Generate Fix Proposals

Create specific, actionable proposals for each drifted element:

#### For "new in code" elements (Mode A: update docs)

```
Proposal: Add [ElementName] to C4 model
Action: create_container(projectId, systemId, {
  name: "DetectedServiceName",
  description: "Detected from codebase — [describe what it does]",
  technology: "Detected technology stack",
  type: "service" | "database" | "queue" | etc.
})
```

Also propose relationships:
```
Proposal: Add relationship [Source] → [Target]
Action: create_relationship(projectId, {
  sourceId: "...",
  targetId: "...",
  type: "calls" | "uses" | "reads_from" | etc.,
  description: "Detected dependency"
})
```

#### For "missing in code" elements (Mode A or C)

```
Proposal: Remove [ElementName] from C4 model (deprecated/removed)
Action: delete_container(projectId, containerId)
— OR —
Proposal: Mark [ElementName] as deprecated (pending confirmation)
Action: update_container(projectId, containerId, {
  description: "[DEPRECATED] — not found in codebase as of [date]. Confirm removal."
})
```

Prefer marking as deprecated over deleting. Never auto-delete without confirmation.

#### For "drifted" elements (Mode A: update docs)

```
Proposal: Update [ElementName] properties
Action: update_container(projectId, containerId, {
  technology: "Go, gin"  // was "Python, Flask"
  description: "Updated description matching current implementation"
})
```

#### For "drifted" elements (Mode B: suggest code changes)

```
Proposal: Refactor [ElementName] to match architecture
Suggested changes:
- File: handlers/user.go
- Issue: Direct database import bypasses service layer
- Fix: Route database calls through UserService instead of importing db package directly
- Conformance rule: [RuleName] requires all data access through service layer
```

### Step 5: Preview Changes

Present all proposals in a structured diff before applying anything:

```markdown
## Proposed Changes Preview

### C4 Model Updates (Mode A)

| # | Element | Action | Details |
|---|---------|--------|---------|
| 1 | NotificationService | CREATE container | Go, gin — new service detected in code |
| 2 | PaymentService | UPDATE technology | Python, Flask → Go, gin |
| 3 | LegacyEmailAdapter | DEPRECATE component | Not found in codebase |
| 4 | OrderService → NotificationService | CREATE relationship | calls, HTTPS/JSON |

### Code Change Suggestions (Mode B)

| # | File | Issue | Suggested Fix |
|---|------|-------|---------------|
| 1 | handlers/user.go | Direct DB import | Use UserService instead |

### Review Needed (Mode C)

| # | Element | Question |
|---|---------|----------|
| 1 | AnalyticsService | In C4 model but no code found — intentionally removed or not yet built? |
```

**Wait for user confirmation before proceeding to Step 6.**

### Step 6: Apply Fixes

After the user confirms, execute the approved proposals via MCP tools:

```
1. For each approved "create" proposal:
   create_container / create_component / create_relationship

2. For each approved "update" proposal:
   update_container / update_component / update_relationship

3. For each approved "deprecate" proposal:
   update_container / update_component with deprecation note

4. For each approved "delete" proposal (only with explicit confirmation):
   delete_container / delete_component
```

Apply changes in dependency order: create elements before relationships, update before delete.

### Step 7: Create Change Request and Verify

```
1. create_request(projectId, {
     title: "Drift Auto-Fix: [summary of changes]",
     description: "Automated drift fixes applied by archyl-autofix.\n\n[list of changes]\n\nDrift score: [before]% → [estimated after]%"
   })

2. compute_drift_score(projectId) → re-compute to verify improvement

3. get_drift_score(projectId) → confirm new score
```

Report the final result with before/after comparison.

## Output Format

```markdown
## Drift Auto-Fix Report

### Current Drift Score: [X]%

### Fix Proposals

#### 1. [Element Name] — [Update Docs / Suggest Code Change / Review Needed]
- **Drift type**: missing_in_code / new_in_code / drifted
- **Current state (C4)**: [what the model says]
- **Actual state (code)**: [what the codebase shows]
- **Proposed fix**: [specific action with tool call details]
- **Impact**: [what changes in the model or codebase]

#### 2. ...

### Summary
| Fix Mode | Count |
|----------|-------|
| Update docs (Mode A) | X |
| Suggest code changes (Mode B) | X |
| Review needed (Mode C) | X |

### After Fixes
- Drift score: [X]% → [Y]%
- Change Request: CR-[id] created for review
```

## Handling Large Drift

When drift score is high (>50%) or many elements are drifted:

1. **Prioritize by severity**: Fix elements that cause the most drift first
2. **Batch by system**: Group fixes by C4 system to keep changes coherent
3. **Limit per run**: Apply at most 10-15 fixes per run to keep Change Requests reviewable
4. **Iterate**: Run the autofix multiple times, reducing drift incrementally
5. **Flag structural issues**: If the drift suggests the entire architecture model is outdated, recommend a full re-discovery rather than incremental fixes

Priority order:
1. Containers with wrong technology (high visibility, easy fix)
2. Missing containers for services that exist in code (gaps in documentation)
3. Stale containers for removed services (misleading documentation)
4. Drifted relationships (wrong dependency graph)
5. Component-level drift (lower visibility)

## Safety Guidelines

1. **Never auto-delete without confirmation**: Always mark as deprecated first, or ask explicitly
2. **Always create a Change Request**: Every set of fixes must be tracked in a CR for architect review
3. **Preserve before-state**: Log what the C4 model looked like before changes in the CR description
4. **One CR per fix session**: Group all fixes from a single run into one CR, not one per element
5. **Respect conformance rules**: If a fix would violate a conformance rule, flag it instead of applying
6. **Re-compute drift after fixes**: Always verify that the drift score improved
7. **Idempotent proposals**: Running the autofix twice should not create duplicate elements

## Examples

### Example 1: Stale Documentation (Mode A)

**Scenario**: The team migrated PaymentService from Python/Flask to Go/gin last sprint but forgot to update Archyl.

```
Drift details:
- PaymentService: technology mismatch (documented: "Python, Flask", actual: "Go, gin")
- PaymentService: description outdated (references Flask blueprints)
- FlaskMiddleware component: exists in C4, not in code

Classification:
- PaymentService technology → Mode A (code is truth, recent migration)
- PaymentService description → Mode A (stale description)
- FlaskMiddleware → Mode A (removed during migration)

Fixes:
1. update_container(projectId, paymentServiceId, {
     technology: "Go, gin",
     description: "Handles payment processing, refunds, and billing. Built with Go and gin framework."
   })
2. update_component(projectId, flaskMiddlewareId, {
     description: "[DEPRECATED] Removed during Python-to-Go migration. Confirm deletion."
   })
   — OR after confirmation: delete_component(projectId, flaskMiddlewareId)

CR: "Drift Auto-Fix: Update PaymentService after Python→Go migration"
Drift: 34% → 18%
```

### Example 2: Code Deviation (Mode B)

**Scenario**: Architecture mandates that all handlers go through the service layer, but a developer added direct database calls in `handlers/order.go`.

```
Drift details:
- OrderHandler: has relationship to PostgresDatabase (not in C4 model)
- Conformance rule "no-direct-db-from-handlers" is violated

Classification:
- OrderHandler → Database relationship → Mode B (architecture is truth, conformance rule exists)

Fixes:
1. No C4 model changes needed (model is correct)
2. Code change suggestion:
   - File: handlers/order.go
   - Issue: imports "internal/database" directly
   - Fix: Use OrderService.GetOrders() instead of database.Query()
   - Rule: "no-direct-db-from-handlers" requires all data access through service layer
3. run_conformance_check to verify the rule violation

CR: "Drift Auto-Fix: Flag handler-layer DB access violation in OrderHandler"
Note: Code changes must be implemented by the development team
```

### Example 3: Ambiguous Drift (Mode C)

**Scenario**: The C4 model includes a `NotificationService` but no corresponding code exists. No ADR explains its status.

```
Drift details:
- NotificationService: exists in C4 model, not found in codebase
- No ADR referencing NotificationService
- No recent git history of removing a notification service

Classification:
- NotificationService → Mode C (unclear intent)
  - Could be: planned but not yet implemented
  - Could be: removed and docs not updated
  - Could be: renamed to something else

Questions for the team:
1. Was NotificationService intentionally removed?
2. Is it planned for a future sprint?
3. Was it renamed? (check if any new service handles notifications)

Proposed action:
- Flag for human review
- update_container(projectId, notificationServiceId, {
    description: "[REVIEW NEEDED] Not found in codebase as of 2026-04-07. Was this removed intentionally or not yet implemented?"
  })

CR: "Drift Review: NotificationService — missing in codebase, needs clarification"
```

## Error Handling

### compute_drift_score returns no data
The project may not have a connected git repository. Drift detection requires a codebase to compare against. Suggest the user configure the repository connection in Archyl project settings.

### get_drift_details returns empty
Either drift was just computed and hasn't finished processing, or the score is 0%. Check `get_drift_score` first to confirm the overall score.

### Tool call fails during fix application
If a create/update/delete call fails mid-fix:
1. Stop applying further fixes
2. Report which fixes succeeded and which failed
3. The CR should still be created with partial changes documented
4. Suggest the user retry the failed fixes manually

### Element IDs not found
If a drifted element's ID from drift details doesn't resolve when calling update/delete:
1. The element may have been modified or deleted since drift was computed
2. Re-run `get_project_c4_model` to get current state
3. Match by name/type instead of ID if possible

### Conflicting fixes
If two drift items suggest contradictory changes (e.g., one says add a relationship, another says the target element should be removed):
1. Flag both as Mode C (review needed)
2. Do not apply either fix automatically
3. Present both to the user with the conflict clearly explained
