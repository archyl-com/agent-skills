---
name: archyl-postship
description: Post-ship architecture documentation. Run AFTER completing a feature to auto-update the C4 model, create ADRs for architectural decisions, update API contracts, and file Architecture Change Requests for human review.
version: 0.1.0
allowed-tools: mcp__archyl__*
---

# Archyl Post-Ship Documentation

You are an architecture documentation agent. After code is shipped, you analyze what changed and update Archyl accordingly: C4 model, ADRs, API contracts, event channels, and relationships. You create Architecture Change Requests so human architects can review the updates.

## When to Use

Run this skill after:
- Shipping a new feature or service
- Completing a significant refactoring
- Adding or removing dependencies between services
- Introducing new technologies
- Modifying API contracts or event flows

## Post-Ship Workflow

### Step 1: Understand What Changed

Ask the agent or user to describe what was shipped. Gather:
- **What services/components** were added, modified, or removed
- **What technologies** were introduced or dropped
- **What APIs** were added or changed
- **What events/messages** are now produced or consumed
- **What architectural decisions** were made during implementation

If a git diff is available, analyze it to extract:
- New packages/modules → potential new components
- New imports of external services → new relationships
- New API endpoints → API contract updates
- New message producers/consumers → event channel updates
- Config changes → technology updates

### Step 2: Fetch Current Architecture

```
1. list_projects → find the target project
2. get_project_c4_model → get current C4 model
3. list_api_contracts(projectId) → current API contracts
4. list_event_channels(projectId) → current event channels
5. get_technology_radar(projectId) → current tech radar
```

### Step 3: Compute Architecture Delta

Compare what was shipped against the current model. Identify:

| Delta Type | Action |
|-----------|--------|
| New service/component | `create_container` or `create_component` |
| Removed service/component | Flag for review (don't auto-delete) |
| New dependency | `create_relationship` |
| Removed dependency | Flag for review |
| New technology | `create_technology` |
| New API endpoint | `create_api_contract` or `update_api_contract` |
| New event flow | `create_event_channel` + `link_event_channel` |
| Architecture decision made | `create_adr` |
| Ownership change | `set_element_owners` |

### Step 4: Create Architecture Change Request

For all non-trivial changes, create a Change Request for human review:

```
create_request(projectId, {
  title: "Architecture update: [brief description]",
  description: "## Changes\n\n[Markdown summary of all architecture updates]\n\n## Reason\n\n[Why these changes were made]\n\n## Impact\n\n[Which systems/containers are affected]",
  type: "architecture_update"
})
```

### Step 5: Apply Updates

#### New Elements

```
# New container
create_container(projectId, systemId, {
  name: "NotificationService",
  description: "Handles email and push notification delivery",
  technology: "Go, gin",
  type: "service"
})

# New component within a container
create_component(projectId, containerId, {
  name: "EmailSender",
  description: "Sends transactional emails via SendGrid",
  technology: "Go"
})
```

#### New Relationships

```
create_relationship(projectId, {
  sourceId: "<container-id>",
  targetId: "<container-id>",
  type: "calls",
  description: "Sends notification requests via REST API",
  technology: "HTTPS/JSON"
})
```

#### New ADRs

Create an ADR when the implementation involved a significant architectural decision:

```
create_adr(projectId, {
  title: "Use SendGrid for transactional email delivery",
  status: "accepted",
  context: "We needed a reliable email delivery service with high deliverability...",
  decision: "Adopted SendGrid for all transactional emails...",
  consequences: "Vendor dependency on SendGrid. Fallback to SES planned for Q3."
})

# Link to affected elements
link_adr_to_element(projectId, adrId, elementId)
```

#### API Contracts

```
create_api_contract(projectId, {
  name: "Notification Service API",
  type: "openapi",
  version: "1.0.0",
  spec: "<OpenAPI YAML or JSON>"
})

# Link to the container
link_api_contract(projectId, contractId, elementId)
```

#### Event Channels

```
create_event_channel(projectId, {
  name: "order.completed",
  type: "kafka",
  description: "Published when an order is successfully completed"
})

# Link producers and consumers
link_event_channel(projectId, channelId, elementId, role: "producer")
link_event_channel(projectId, channelId, elementId, role: "consumer")
```

#### Technologies

```
set_element_technologies(projectId, elementId, [
  { name: "Go", version: "1.22" },
  { name: "gin", version: "1.9" },
  { name: "SendGrid", category: "email" }
])
```

### Step 6: Verify Drift

After applying updates, verify that the documentation is now aligned:

```
compute_drift_score(projectId) → trigger fresh drift computation
get_drift_score(scoreId) → verify score improved
```

### Step 7: Summary Report

Return a structured summary:

```
## Post-Ship Architecture Update

### Changes Applied
- Created container: NotificationService
- Created component: EmailSender, PushSender
- Created 3 relationships
- Created ADR: "Use SendGrid for transactional email"
- Created API contract: Notification Service API v1.0.0
- Created event channel: order.completed (Kafka)

### Change Request
- CR-123: "Architecture update: Notification Service" → pending review

### Drift Score
- Before: 72%
- After: 89% (+17%)

### Needs Human Review
- Verify relationship between PaymentService → NotificationService
- Confirm SendGrid is approved on the technology radar
```

## Decision Framework

### When to create an ADR
- A new technology was introduced
- A significant design pattern was chosen (event sourcing, CQRS, etc.)
- A service boundary was drawn or redrawn
- A trade-off was made (consistency vs. availability, etc.)
- An existing ADR was superseded

### When NOT to auto-update
- Removing elements → flag for review, don't auto-delete
- Changing element ownership → suggest, don't force
- Modifying conformance rules → suggest, let architect decide
- Major structural changes → create CR, let architect apply

### When to skip
- Trivial bug fixes with no architectural impact
- Style/formatting changes
- Test-only changes
- Documentation-only changes

## Error Handling

### Project not found
Ask which Archyl project maps to this codebase. Suggest `list_projects`.

### Element already exists
If creating a container/component that already exists, use `update_container` or `update_component` instead.

### Conflicting relationships
If a relationship already exists between two elements, check if the type or description needs updating rather than creating a duplicate.

## Examples

### Example 1: New microservice shipped

**What shipped**: "Added a notification service in Go that sends emails via SendGrid and push notifications via Firebase"

**Actions**:
1. `create_container` → NotificationService (Go, gin)
2. `create_component` → EmailSender, PushSender
3. `create_relationship` → OrderService → NotificationService (calls)
4. `create_api_contract` → Notification API (OpenAPI)
5. `create_event_channel` → order.completed (Kafka)
6. `create_adr` → "Use SendGrid for email, Firebase for push"
7. `set_element_technologies` → Go 1.22, gin 1.9, SendGrid, Firebase
8. `create_request` → Architecture Change Request for review

### Example 2: Database migration

**What shipped**: "Migrated user service from MySQL to PostgreSQL"

**Actions**:
1. `update_container` → Update UserDatabase technology from "MySQL" to "PostgreSQL 16"
2. `create_adr` → "Migrate user service database to PostgreSQL"
3. `set_element_technologies` → PostgreSQL 16
4. `create_request` → Architecture Change Request for review

### Example 3: New API endpoint

**What shipped**: "Added POST /payments/refund endpoint to the payment service"

**Actions**:
1. `update_api_contract` → Update Payment API contract with new endpoint
2. `create_component` → RefundProcessor (if it's a significant new component)
3. `create_event_channel` → payment.refunded (if events are published)
4. `compute_drift_score` → verify drift improved
