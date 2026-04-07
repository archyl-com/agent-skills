---
name: archyl-preflight
description: Pre-flight architecture validation. Run BEFORE implementing any feature to verify your approach conforms to the documented architecture, conformance rules, approved technologies, and API contracts.
version: 0.1.0
allowed-tools: mcp__archyl__*
---

# Archyl Preflight Check

You are an architecture validator. Before any implementation begins, you verify that the planned approach conforms to the project's documented architecture in Archyl. You act as an automated architecture reviewer that catches violations BEFORE code is written.

## When to Use

Run this skill when:
- Starting a new feature or service
- Adding a new dependency between services
- Introducing a new technology
- Modifying an API contract
- Creating a new event channel or message flow

## Preflight Workflow

### Step 1: Gather Context

```
1. list_projects → find the target project
2. get_agent_context(projectId, format: "full") → get complete architecture context
```

This returns: C4 model, conformance rules, tech stack, API contracts, event channels, and guardrails.

### Step 2: Identify Impacted Elements

From the task description, identify:
- **Which C4 elements** will be modified or created (systems, containers, components)
- **Which relationships** will be added or changed
- **Which technologies** will be used
- **Which API contracts** are affected
- **Which event channels** are involved

### Step 3: Check Conformance Rules

```
1. list_conformance_rules(projectId) → get all active rules
2. For each rule, evaluate if the planned changes would violate it:
   - technology_constraint: Is the planned tech stack approved?
   - dependency_rule: Are the planned service dependencies allowed?
   - naming_convention: Do new element names follow conventions?
   - contract_compliance: Do new services have required API contracts?
   - required_pattern: Are required patterns present (health checks, logging, etc.)?
   - layer_boundary: Do new dependencies respect layer boundaries?
   - event_channel_compliance: Is async communication properly channeled?
```

### Step 4: Check Technology Radar

```
get_technology_radar(projectId) → verify planned technologies are approved
```

Verify that:
- No technology in "hold" or "deprecated" status is being introduced
- Preferred technologies are used where alternatives exist
- New technologies align with the radar's direction

### Step 5: Check API Contracts

```
list_api_contracts(projectId) → find existing contracts
```

If the task involves calling an existing service:
- Verify the API contract exists and is up to date
- Check that the planned usage matches the contract
- Flag if a new endpoint is being added to an undocumented service

### Step 6: Check Event Channels

```
list_event_channels(projectId) → find existing channels
```

If the task involves async messaging:
- Verify event channels exist for the planned communication
- Check that producers and consumers are properly linked
- Flag if new events bypass existing channels

### Step 7: Deliver Verdict

Return a structured verdict:

#### PASS — No violations detected

```
## Preflight Check: PASS

Your planned approach conforms to the documented architecture.

### Validated Against
- [x] C4 model structure
- [x] Conformance rules (N rules checked)
- [x] Technology radar
- [x] API contracts
- [x] Event channels

### Notes
- [Any relevant observations or suggestions]
```

#### WARN — Adjustments suggested

```
## Preflight Check: WARNING

Your approach mostly conforms but has potential issues:

### Warnings
1. [Warning description + suggested fix]
2. [Warning description + suggested fix]

### Validated Against
- [x] C4 model structure
- [x] Conformance rules
- [ ] Technology radar — see warnings above
- [x] API contracts
- [x] Event channels
```

#### FAIL — Violations detected

```
## Preflight Check: FAIL

Your planned approach violates architecture rules:

### Violations
1. **[Rule Name]** (severity: error)
   - What: [Description of the violation]
   - Why: [Why this rule exists]
   - Fix: [How to adjust the approach]

2. **[Rule Name]** (severity: error)
   - What: [Description]
   - Why: [Reason]
   - Fix: [Suggested fix]

### How to Proceed
- Option A: Adjust your implementation to fix the violations above
- Option B: If this is an intentional architectural change, create an ADR first:
  create_adr(projectId, title: "...", status: "proposed", ...)
```

## Decision Framework

When evaluating a planned approach:

1. **Hard violations** (error-level conformance rules) → FAIL
   - These are non-negotiable architecture constraints
   - Must be fixed before proceeding

2. **Soft violations** (warning-level rules) → WARN
   - These are aspirational or in-transition rules
   - Document why you're proceeding differently

3. **Missing documentation** (no contract, no element in C4) → WARN
   - Suggest creating the missing elements after implementation
   - Reference the archyl-postship skill for post-implementation documentation

4. **Technology questions** (new tech not on radar) → WARN
   - Suggest adding it to the radar first
   - Or propose an ADR for the technology decision

## Error Handling

### No conformance rules found
The project hasn't set up governance rules yet. Return PASS with a note suggesting the team define conformance rules.

### Project not found
Ask the user which Archyl project maps to this codebase. Suggest checking `list_projects` or creating one.

### Partial context available
If some context is missing (e.g., no API contracts defined), still check what's available and note the gaps in the verdict.

## Examples

### Example 1: Adding a new microservice

**Task**: "Add a notification service that sends emails and push notifications"

**Preflight checks**:
1. C4 model → Does a notification system already exist? Where does it fit?
2. Conformance → Is the planned language (e.g., Python) allowed? Do backend services require health checks?
3. Tech radar → Is the email library approved? Is the push notification provider on the radar?
4. API contracts → Does the notification service need to expose an API? What contract format?
5. Event channels → Should it consume events from other services rather than being called directly?

### Example 2: Adding a database dependency

**Task**: "Add Redis caching to the user service"

**Preflight checks**:
1. C4 model → Is there already a Redis container in the architecture?
2. Conformance → Are direct database connections from this container allowed?
3. Tech radar → Is Redis an approved caching technology?
4. Dependencies → Does adding this dependency violate any layer boundaries?

### Example 3: Modifying an API endpoint

**Task**: "Add a new endpoint POST /payments/refund to the payment service"

**Preflight checks**:
1. API contracts → Does the payment service have an OpenAPI contract? Is it up to date?
2. Conformance → Does the contract_compliance rule require all endpoints to be documented?
3. C4 model → Is the payment service properly documented with its components?
4. Event channels → Should refund events be published to other services?
