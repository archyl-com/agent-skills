# Event-Driven Architecture Rule Pack

Enforce event-driven communication patterns, schema governance, and channel hygiene.

## When to Use

Use this pack when your system relies on asynchronous event-based communication between services. This pack ensures events are well-defined, properly documented, and follow consistent patterns that prevent the "event spaghetti" anti-pattern.

## Rules

| # | Rule | Type | Severity | Description |
|---|------|------|----------|-------------|
| 1 | Async Communication Via Event Channels | `event_channel_compliance` | critical | All async communication must use documented channels |
| 2 | Event Schema Required | `contract_compliance` | critical | Every channel must have a schema (AsyncAPI, Avro, etc.) |
| 3 | No Direct Calls For Async Operations | `dependency_rule` | high | Async operations must not use synchronous calls |
| 4 | Event Channel Must Have Producer and Consumer | `event_channel_compliance` | high | No orphaned channels -- each needs both sides |
| 5 | Dead Letter Queue Required | `required_pattern` | high | All consumers must have a DLQ for failed messages |
| 6 | Event Naming Convention | `naming_convention` | medium | Channel names must follow domain.action format |
| 7 | Event Channel Description Required | `event_channel_compliance` | medium | Every channel must have a description |
| 8 | No Bidirectional Event Channels | `event_channel_compliance` | high | Channels must be unidirectional between service pairs |

## How to Install

Using the `archyl-developer` skill in Claude Code:

```
Use the archyl-developer skill to install the event-driven conformance rule pack.
Read the rules from rule-packs/event-driven/rules.json and create each rule
in my project [PROJECT_ID].
```

Or install rules individually using the `create_conformance_rule` MCP tool. See the main [README](../README.md) for details.

## Customization

- **Schema types** -- Update `contract_types` in rule 2 to match your schema registry (e.g., add "cloudevents" if using CloudEvents spec).
- **Naming pattern** -- Adjust the regex in rule 6 to match your event naming convention (e.g., `PascalCase` events like `OrderCreated`).
- **DLQ enforcement** -- If your message broker handles DLQs automatically (e.g., AWS SQS), you may lower rule 5 severity to `medium`.
- **Bidirectional channels** -- If using request/reply patterns (e.g., RPC over messaging), scope rule 8 to exclude explicitly tagged request-reply channels.

## Pairs Well With

- **Microservices** pack for service boundary enforcement
- **API-First** pack for synchronous API governance alongside async events
- **Security Baseline** pack for securing event channels and data flows
