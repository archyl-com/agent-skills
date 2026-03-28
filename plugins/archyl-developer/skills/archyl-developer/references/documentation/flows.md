# Flows (User & System Flows)

## Overview

Flows in Archyl model step-by-step sequences — either user journeys through the system or data/event flows between components. They provide a dynamic view of the architecture that complements the static C4 model.

## Creating a Flow

**Tool**: `create_flow`

```
Parameters:
- projectId (required): UUID
- name (required): Flow name (e.g., "User Registration", "Order Processing Pipeline")
- description: What this flow represents
- steps: Array of flow steps, each with:
  - name: Step name
  - description: What happens in this step
  - elementId: (optional) UUID of the C4 element involved
  - elementType: (optional) C4 level of the element
```

## Flow Patterns

### User Journey Flow
```
Flow: "User Places an Order"
Steps:
1. User submits order → Frontend (container)
2. Validate payment → PaymentService (component)
3. Process order → OrderService (component)
4. Store order → OrderDatabase (container)
5. Send confirmation → NotificationService (component)
6. User receives email → EmailProvider (external system)
```

### System Integration Flow
```
Flow: "Nightly Data Sync"
Steps:
1. Scheduler triggers → CronService (container)
2. Fetch data → ExternalApi (system)
3. Transform records → DataPipeline (component)
4. Write to warehouse → DataWarehouse (container)
5. Notify stakeholders → SlackWebhook (container)
```

## Operations

- `list_flows(projectId)` — List all flows
- `get_flow(flowId)` — Get flow with all steps
- `update_flow` — Modify flow steps
- `delete_flow` — Remove a flow

## Best Practices

1. **Link steps to C4 elements**: Connect each step to the system/container/component responsible
2. **Model the happy path first**: Then add error/edge-case flows separately
3. **Keep flows focused**: One flow per user story or business process
4. **Use for onboarding**: Flows are excellent for helping new team members understand how data moves through the system
