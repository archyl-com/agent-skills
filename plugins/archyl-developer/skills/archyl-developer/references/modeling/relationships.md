# Relationships & Dependencies

## Overview

Relationships are the connections between C4 elements. They model how systems communicate, how containers exchange data, how components depend on each other, and how code elements relate. Without relationships, your architecture diagram is just a collection of boxes.

## Relationship Types Decision Guide

Choose the most specific type that fits:

### Between Systems (Level 1)
| Scenario | Type | Example |
|----------|------|---------|
| System A uses functionality from System B | `uses` | "EcommercePlatform uses PaymentGateway" |
| System A requires System B to function | `depends_on` | "Mobile App depends on Backend API" |

### Between Containers (Level 2)
| Scenario | Type | Example |
|----------|------|---------|
| Synchronous API call | `calls` | "ApiServer calls AuthService via REST" |
| Reading from a database | `reads_from` | "ReportService reads from AnalyticsDB" |
| Writing to a database | `writes_to` | "OrderService writes to OrderDB" |
| Publishing to a queue/topic | `sends_to` | "OrderService sends to Kafka 'order.created'" |
| Subscribing to a queue/topic | `consumes_from` | "NotificationWorker consumes from 'order.created'" |
| General dependency | `depends_on` | "Service depends on shared config" |

### Between Components (Level 3)
| Scenario | Type | Example |
|----------|------|---------|
| Component calls another | `calls` | "OrderHandler calls OrderService" |
| Component depends on another | `depends_on` | "PaymentService depends on CurrencyConverter" |
| General usage | `uses` | "Controller uses Validator" |

### Between Code Elements (Level 4)
| Scenario | Type | Example |
|----------|------|---------|
| Implements an interface | `implements` | "StripeGateway implements PaymentProvider" |
| Extends a base class | `extends` | "AdminUser extends BaseUser" |
| Calls a function | `calls` | "processOrder() calls validatePayment()" |

## Cross-Level Relationships

Relationships can span C4 levels. Common patterns:

- **System → Container**: "External API is accessed by our ApiServer"
- **Container → Component**: "Database is accessed by Repository component"
- **Component → Code**: "Service delegates to specific handler function"

When creating cross-level relationships, set `sourceType` and `targetType` to the correct C4 level for each end.

## Creating Relationships

**Tool**: `create_relationship`

```
Parameters:
- projectId (required): UUID
- sourceId (required): UUID of source element
- sourceType (required): C4 level (1-4)
- targetId (required): UUID of target element
- targetType (required): C4 level (1-4)
- type: Relationship type
- description: Human-readable description of what flows or why
```

**The description matters.** Don't just say "uses" — say *what* is being communicated:
- "Sends order events via Kafka"
- "Fetches user profile via REST API"
- "Reads transaction history for reconciliation"
- "Implements the PaymentProvider interface for Stripe"

## Querying Relationships

- `list_relationships(projectId)` — All relationships in a project
- `get_project_c4_model(projectId)` — Includes all relationships with the full model

## Best Practices

1. **Be specific with types**: `calls` is better than `uses` when you know it's a synchronous call
2. **Always add descriptions**: They appear on diagram edges and make the architecture self-documenting
3. **Model both directions for databases**: Use `reads_from` AND `writes_to` separately
4. **Use technology tags**: Tag relationships with `set_relationship_technologies` to show the protocol (REST, gRPC, Kafka)
5. **Don't over-connect**: Not every possible dependency needs modeling — focus on significant architectural boundaries
