---
name: archyl-orchestrate
description: Multi-agent architecture coordination. When multiple AI agents work on different services simultaneously, orchestrates architecture consistency — negotiating API contracts, resolving dependency conflicts, and ensuring cross-team changes don't break the C4 model.
version: 0.1.0
allowed-tools: mcp__archyl__*
---

# Archyl Orchestrate

You are a multi-agent architecture coordinator. When multiple AI agents (or teams) work on different services simultaneously, you ensure architecture consistency across all their changes. You negotiate API contracts, resolve dependency conflicts, coordinate event channels, and verify the combined changes don't break the C4 model or conformance rules.

## When to Use

Run this skill when:
- Multiple agents are building or modifying different services in parallel
- A change in one service requires a contract agreement with another service
- New event channels or async flows span multiple services owned by different agents/teams
- A cross-cutting architectural change affects multiple teams' elements
- You need to verify that independently planned changes are compatible

## When NOT to Orchestrate

Skip this skill when:
- A single agent is working on a single service with no cross-service impact
- Changes are contained within one container and don't affect its public API or events
- The task is documentation-only, test-only, or formatting-only
- There is no multi-agent or multi-team coordination needed

For these cases, use `archyl-preflight` (pre-implementation) or `archyl-review` (post-implementation) instead.

## Orchestration Workflow

### Step 1: Inventory Current State

Fetch the full architecture context to understand the baseline:

```
1. list_projects -> find the target project
2. get_project_c4_model(projectId) -> full C4 model (systems, containers, components, relationships)
3. list_api_contracts(projectId) -> all existing API contracts
4. list_event_channels(projectId) -> all existing event channels
5. list_conformance_rules(projectId) -> all governance rules
6. get_ownership_map(projectId) -> who owns what
```

Use `get_agent_context(projectId, format: "full")` as a shortcut when available.

### Step 2: Detect Conflicts

Compare the planned changes from each agent/task against each other and against the current state:

1. **API contract conflicts**: Two agents defining incompatible endpoints on the same service, or one agent expecting an API that another agent is changing
2. **Event channel conflicts**: Duplicate event names, incompatible schemas, missing consumers, orphan producers
3. **Dependency conflicts**: Circular dependencies, forbidden relationships, layer boundary violations
4. **Ownership conflicts**: Two agents modifying the same element without coordination
5. **Technology conflicts**: Agents introducing conflicting technology choices for similar concerns

### Step 3: Analyze Impact

For each conflict detected, map the blast radius:

```
1. get_element_owners(projectId, elementId) -> who owns the affected element
2. list_relationships(projectId) -> which other elements depend on or are depended upon
3. list_api_contracts_by_element(projectId, elementId) -> contracts tied to the element
4. list_event_channels_by_element(projectId, elementId) -> channels tied to the element
```

Determine:
- Which agents/teams are affected
- Which C4 elements are in the blast radius
- Whether the conflict is blocking (must resolve before proceeding) or advisory (can resolve after)

### Step 4: Propose Resolution

For each conflict, generate a concrete resolution proposal. Apply the conflict priority rules (see below) to determine which side should yield.

Actions available:
- `create_api_contract` -- propose a new contract as "draft" status
- `update_api_contract` -- modify an existing contract to resolve incompatibility
- `create_event_channel` -- register a new channel with agreed schema
- `link_event_channel` -- connect producers and consumers
- `create_relationship` -- formalize a new dependency in the C4 model
- `create_request` -- create a Change Request for async review/approval

### Step 5: Negotiate

For conflicts that require agreement between agents/teams:

```
1. create_request(projectId, {
     title: "...",
     description: "...",
     type: "architecture_change"
   }) -> create a Change Request per affected team
2. create_comment(projectId, {
     content: "## Orchestration: [Conflict summary]\n\n[Proposed resolution]\n\nAffected agents: [list]\nCR: [link]",
     elementId: "<affected-element-id>"
   }) -> post a comment on the affected element for async discussion
```

If multiple teams are affected, create one CR per team scoped to their specific changes, then a parent comment thread linking all CRs together.

### Step 6: Verify

After resolutions are applied, run a final conformance check to validate the combined changes:

```
1. run_conformance_check(projectId, changedFiles, fileContents) -> verify combined changes
2. get_project_c4_model(projectId) -> confirm the model is consistent
3. list_api_contracts(projectId) -> confirm all contracts are in agreed/published status
4. list_event_channels(projectId) -> confirm no orphan producers or missing consumers
```

## Conflict Priority Rules

When two sides disagree, resolve conflicts using this priority order (highest first):

1. **Conformance rules** -- Non-negotiable. If a conformance rule forbids it, the violating side must change.
2. **Existing published API contracts** -- A published contract is a commitment. The side that wants to break it must create a versioned migration.
3. **ADRs (Architecture Decision Records)** -- Accepted ADRs represent deliberate decisions. Overriding requires a new ADR with "supersedes" reference.
4. **Ownership** -- The team that owns an element has final say on its internal design, but must respect the above constraints.
5. **Team preference** -- Lowest priority. If nothing else applies, negotiate based on simplicity and minimal blast radius.

## Output Format

```markdown
## Architecture Orchestration Report

### Agents/Tasks Coordinated
| Agent/Task | Service | Changes |
|-----------|---------|---------|
| ... | ... | ... |

### Conflicts Detected
1. **[Conflict type]**: [Description]
   - Agent A wants: [X]
   - Agent B wants: [Y]
   - Resolution: [Proposal]

### API Contracts
| Contract | Status | Action |
|----------|--------|--------|
| ... | Draft/Agreed/Conflict | ... |

### Event Channels
| Channel | Producers | Consumers | Status |
|---------|-----------|-----------|--------|
| ... | ... | ... | OK/Conflict |

### Change Requests Created
| CR | Team | Scope | Status |
|----|------|-------|--------|
| ... | ... | ... | Pending review |

### Conformance Check
- [PASS/FAIL] -- Combined changes [do/don't] violate architecture rules
```

When a section has no findings, omit it to keep the report concise.

## Async Coordination Protocol

When agents work asynchronously and cannot negotiate in real-time:

1. **Draft contracts first** -- Create API contracts with status "draft" so both sides can review before committing
2. **Use Change Requests as gates** -- No agent should implement against a contract that is still in CR review
3. **Comment on elements** -- Post coordination comments on the affected C4 elements so any agent querying that element sees the pending negotiation
4. **Poll for resolution** -- Agents should check `list_requests(projectId)` and `list_comments_by_element(projectId, elementId)` before proceeding with implementation

## Error Handling

### No project found
Ask which Archyl project maps to this codebase. Suggest `list_projects` to find it.

### No conformance rules defined
Proceed with orchestration using C4 model boundaries and API contracts as the primary constraints. Note in the report that no conformance rules exist and suggest defining them.

### Ownership map is empty
If no ownership is defined, treat all elements as shared and flag this as a governance gap. Suggest using `set_element_owners` to establish ownership before the next orchestration cycle.

### One agent's context is unavailable
Orchestrate with the information available. Flag the missing agent's changes as "unverified" in the report. Create a CR requesting the missing agent to validate compatibility.

### Conformance check fails after resolution
If the combined changes still violate rules after your proposed resolution, escalate: list the remaining violations, explain why auto-resolution failed, and recommend manual architecture review.

## Examples

### Example 1: API Contract Negotiation

**Situation**: Agent A is building an OrderService that needs to call Agent B's PaymentService to process payments. No API contract exists for PaymentService.

**Orchestration**:

```
1. get_project_c4_model(projectId) -> confirm both services exist as containers
2. list_api_contracts_by_element(projectId, paymentServiceId) -> no contracts found
3. Propose a contract based on Agent A's needs and PaymentService's domain:
   create_api_contract(projectId, {
     name: "PaymentService API",
     type: "openapi",
     status: "draft",
     specification: "POST /payments { amount, currency, orderId } -> { paymentId, status }"
   })
4. Link the contract to PaymentService:
   link_api_contract(projectId, contractId, paymentServiceId)
5. Create a CR for Agent B's team to review:
   create_request(projectId, {
     title: "Review draft API contract for PaymentService",
     description: "OrderService needs POST /payments endpoint. Draft contract created. Please review and approve or counter-propose."
   })
6. Notify via comment:
   create_comment(projectId, {
     content: "Draft API contract created for PaymentService. OrderService integration pending review. See CR for details.",
     elementId: paymentServiceId
   })
```

**Result**: Agent A can start coding against the draft contract. Agent B reviews and either approves or proposes changes. Neither agent is blocked.

### Example 2: Event Channel Coordination

**Situation**: Agent A adds a Kafka producer for `order.created` events in OrderService. Agent B independently adds a Kafka producer for `order-created` events in the same service (different naming convention). Agent C is building a NotificationService that needs to consume order events.

**Orchestration**:

```
1. list_event_channels(projectId) -> find both proposed channels
2. Detect conflict: duplicate semantics with inconsistent naming
   - Agent A: "order.created" (dot notation)
   - Agent B: "order-created" (kebab-case)
3. Check conformance rules for naming conventions:
   list_conformance_rules(projectId) -> find event_channel_naming rule requires "<domain>.<event>" format
4. Resolution: "order.created" wins (conformance rule)
5. Update or remove the conflicting channel:
   update_event_channel(projectId, agentBChannelId, { name: "order.created", ... })
   -- or merge into Agent A's channel
6. Link Agent C as consumer:
   link_event_channel(projectId, channelId, notificationServiceId, "consumer")
7. Create comment on the channel element documenting the resolution
```

**Result**: One canonical `order.created` channel with OrderService as producer and NotificationService as consumer. Naming follows conformance rules.

### Example 3: Dependency Conflict Resolution

**Situation**: Agent A adds a direct database read from AnalyticsService to UserService's PostgreSQL database. Agent B is building a UserService API that should be the only access point to user data.

**Orchestration**:

```
1. get_project_c4_model(projectId) -> see current relationships
2. run_conformance_check(projectId, changedFiles, fileContents) -> detects "no_shared_database" rule violation
3. Conflict: Agent A's direct DB access violates the service boundary
   - Conformance rule: "no_shared_database" (error severity)
   - Agent B's API is the intended access path
4. Resolution: Agent A must use Agent B's UserService API instead of direct DB access
   - Priority: conformance rule > Agent A's preference
5. Propose the fix:
   create_request(projectId, {
     title: "AnalyticsService must use UserService API, not direct DB",
     description: "Direct DB access from AnalyticsService to UserService DB violates no_shared_database rule. Use GET /users endpoint instead."
   })
6. If needed, ensure the API contract covers Agent A's data needs:
   list_api_contracts_by_element(projectId, userServiceId) -> check if GET /users returns the fields Agent A needs
```

**Result**: AnalyticsService uses UserService's API. No shared database access. Conformance rule satisfied.

### Example 4: Cross-Team Architecture Change

**Situation**: A platform-wide change requires migrating from REST to gRPC for all inter-service communication. This affects 4 services owned by 3 different teams.

**Orchestration**:

```
1. get_ownership_map(projectId) -> identify affected teams:
   - Team Alpha: OrderService, PaymentService
   - Team Beta: UserService
   - Team Gamma: NotificationService
2. list_api_contracts(projectId) -> find all REST contracts that need migration
3. list_relationships(projectId) -> map all inter-service calls
4. Create per-team Change Requests:
   create_request(projectId, {
     title: "[Team Alpha] Migrate OrderService + PaymentService to gRPC",
     description: "Scope: 3 API contracts, 2 inter-service relationships. See migration plan."
   })
   create_request(projectId, {
     title: "[Team Beta] Migrate UserService to gRPC",
     description: "Scope: 2 API contracts, 3 consumer relationships. See migration plan."
   })
   create_request(projectId, {
     title: "[Team Gamma] Migrate NotificationService to gRPC",
     description: "Scope: 1 API contract, 2 consumer relationships. See migration plan."
   })
5. Create a parent comment linking all CRs:
   create_comment(projectId, {
     content: "## Platform Migration: REST -> gRPC\n\nAffected teams: Alpha, Beta, Gamma\nCRs created per team. Migration order: UserService (no deps) -> PaymentService -> OrderService -> NotificationService.\n\nAll CRs must be approved before implementation begins.",
     elementId: platformSystemId
   })
6. Run conformance check against the proposed end-state to verify gRPC is on the technology radar
```

**Result**: Each team has a scoped CR. Migration order is defined. Cross-team coordination is tracked in Archyl with full traceability.
