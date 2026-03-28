# Architecture Decision Records (ADRs)

## What are ADRs?

Architecture Decision Records capture the key architectural decisions made during a project's lifecycle. Each ADR documents the context, the decision, and its consequences — creating an audit trail of *why* the architecture looks the way it does.

## ADR Lifecycle

```
proposed → accepted → (deprecated | superseded)
```

| Status | Meaning |
|--------|---------|
| `proposed` | Decision is under discussion, not yet finalized |
| `accepted` | Decision has been approved and is in effect |
| `deprecated` | Decision is no longer relevant (technology retired, etc.) |
| `superseded` | Decision has been replaced by a newer ADR |

## Creating an ADR

**Tool**: `create_adr`

```
Parameters:
- projectId (required): UUID of the project
- title (required): Short, descriptive title (e.g., "Use PostgreSQL for primary data store")
- status: One of "proposed", "accepted", "deprecated", "superseded" (default: "proposed")
- context: Why this decision needs to be made — the forces at play
- decision: What was decided
- consequences: Trade-offs, both positive and negative
```

### Writing Good ADR Content

**Context** — Describe the problem and constraints:
- What problem are we solving?
- What are the technical constraints?
- What are the business constraints?

**Decision** — State the decision clearly:
- What technology/pattern/approach was chosen?
- What alternatives were considered?
- Why was this option selected?

**Consequences** — Be honest about trade-offs:
- What are the benefits?
- What are the risks or downsides?
- What follow-up work is needed?

## Linking ADRs to Architecture

**Tool**: `link_adr_to_element`

Link ADRs to the C4 elements they affect. This creates traceability between decisions and the architecture they shape.

```
Parameters:
- adrId: UUID of the ADR
- elementId: UUID of the C4 element
- elementType: C4 level (1=system, 2=container, 3=component, 4=code)
```

**Examples**:
- "Use Kafka for event streaming" → link to the EventBus container
- "Adopt microservices architecture" → link to the main system
- "Use Repository pattern for data access" → link to affected components

## ADR Patterns

### Recording a New Decision
```
1. create_adr(title: "Use gRPC for inter-service communication", status: "proposed",
   context: "Services need efficient, typed communication...",
   decision: "Use gRPC with Protocol Buffers...",
   consequences: "Stronger contracts but more complex tooling...")
2. link_adr_to_element → ApiGateway container
3. link_adr_to_element → OrderService container
4. (After review) update_adr(status: "accepted")
```

### Superseding an Old Decision
```
1. create_adr(title: "Migrate from REST to gRPC", status: "proposed", ...)
2. update_adr(oldAdrId, status: "superseded")
3. link_adr_to_element → all affected containers
```

### Org-Level ADRs
For decisions that span multiple projects:
```
1. create_global_adr(title: "All services must use structured logging", ...)
```

## Querying ADRs

- `list_adrs(projectId)` — All ADRs for a project
- `get_adr(adrId)` — Full ADR with linked elements
- `list_global_adrs` — Org-wide ADRs
