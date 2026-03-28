# Event Channels

## Overview

Event channels model asynchronous communication paths — Kafka topics, RabbitMQ queues, SQS queues, SNS topics, NATS subjects, and other messaging infrastructure. They make the invisible async flows in your architecture visible and traceable.

## Creating an Event Channel

**Tool**: `create_event_channel`

```
Parameters:
- projectId (required): UUID
- name (required): Channel name (e.g., "order.created", "payment.processed")
- description: What events flow through this channel
- protocol: "kafka", "rabbitmq", "sqs", "sns", "nats", "redis-streams", "custom"
- config: Protocol-specific configuration (JSON)
```

## Linking to Architecture

**Tool**: `link_event_channel`

```
Parameters:
- channelId (required): UUID
- elementId (required): UUID of the C4 element
- elementType (required): C4 level
- role: "producer" or "consumer"
```

**Tool**: `unlink_event_channel`

## Querying Channels

- `list_event_channels(projectId)` — All channels
- `get_event_channel(channelId)` — Channel details with linked elements
- `list_event_channels_by_element(elementId, elementType)` — Channels for a specific element

## Example: Order Processing Pipeline

```
1. create_event_channel: "order.created" (protocol: "kafka")
2. create_event_channel: "payment.completed" (protocol: "kafka")
3. create_event_channel: "order.fulfilled" (protocol: "kafka")

4. link_event_channel: OrderService → "order.created" (producer)
5. link_event_channel: PaymentService → "order.created" (consumer)
6. link_event_channel: PaymentService → "payment.completed" (producer)
7. link_event_channel: FulfillmentService → "payment.completed" (consumer)
8. link_event_channel: FulfillmentService → "order.fulfilled" (producer)
```

## Best Practices

1. **Document every async boundary**: If two services communicate via messages, there should be an event channel
2. **Name channels by event, not service**: `order.created` not `order-service-output`
3. **Track both sides**: Always link producers AND consumers
4. **Use with conformance rules**: Create `event_channel_compliance` rules to enforce messaging standards
5. **Combine with API contracts**: Use AsyncAPI specs for event schema documentation
