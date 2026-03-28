# Architecture Patterns with Archyl

## Pattern 1: Modeling a Microservices Architecture

**Systems**: One system per bounded context or product line.

```
1. create_system: "EcommercePlatform" (internal)
2. create_system: "StripeApi" (external)
3. create_system: "SendGridApi" (external)
```

**Containers**: Each microservice, database, and queue is a container.

```
4. create_container: "OrderService" (type: service, tech: "Go + gRPC")
5. create_container: "OrderDatabase" (type: database, tech: "PostgreSQL 15")
6. create_container: "EventBus" (type: queue, tech: "Apache Kafka")
7. create_container: "ApiGateway" (type: api-gateway, tech: "Kong")
```

**Relationships**: Use typed relationships for precision.

```
8. create_relationship: OrderService → OrderDatabase (type: "reads_from")
9. create_relationship: OrderService → OrderDatabase (type: "writes_to")
10. create_relationship: OrderService → EventBus (type: "sends_to", desc: "Order events")
11. create_relationship: OrderService → StripeApi (type: "calls", desc: "Payment processing")
```

## Pattern 2: Modeling a Monolith

Even monoliths benefit from C4 modeling. Model the internal structure with components.

```
1. create_system: "LegacyMonolith" (internal)
2. create_container: "RailsApp" (type: service, tech: "Ruby on Rails 7")
3. create_container: "MySqlDatabase" (type: database, tech: "MySQL 8")
4. create_component: "AuthModule" (in RailsApp)
5. create_component: "BillingModule" (in RailsApp)
6. create_component: "NotificationModule" (in RailsApp)
7. create_relationship: BillingModule → AuthModule (type: "depends_on")
```

## Pattern 3: Event-Driven Architecture

Model event flows using `sends_to` / `consumes_from` and event channels.

```
1. create_event_channel: "OrderCreated" (protocol: "kafka", topic: "orders.created")
2. create_event_channel: "PaymentProcessed" (protocol: "kafka", topic: "payments.processed")
3. link_event_channel: OrderService → "OrderCreated" (role: "producer")
4. link_event_channel: PaymentService → "OrderCreated" (role: "consumer")
5. link_event_channel: PaymentService → "PaymentProcessed" (role: "producer")
```

## Pattern 4: API-First Design

Document API contracts alongside the architecture.

```
1. create_api_contract: "Order API" (format: "openapi", version: "3.1")
2. link_api_contract: → OrderService (the container that implements it)
3. create_api_contract: "Payment Events Schema" (format: "asyncapi")
4. link_api_contract: → EventBus
```

## Pattern 5: Multi-Environment Deployment

Track where things are deployed using environments and releases.

```
1. create_environment: "Development" (order: 1)
2. create_environment: "Staging" (order: 2)
3. create_environment: "Production" (order: 3)
4. create_release: version "2.1.0" → deployed to "Staging"
5. create_release: version "2.0.5" → deployed to "Production"
```

## Pattern 6: Technology Governance

Use the technology radar to track and govern tech choices.

```
1. create_technology: "Go" (category: "language", status: "adopt")
2. create_technology: "Node.js" (category: "language", status: "hold")
3. create_technology: "PostgreSQL" (category: "database", status: "adopt")
4. create_technology: "MongoDB" (category: "database", status: "trial")
5. set_element_technologies: OrderService → ["Go", "gRPC"]
6. get_technology_radar → see full radar with adoption counts
```

## Pattern 7: Documenting a Migration

When migrating from one architecture to another:

1. **Model current state** — Create the existing architecture
2. **Create ADR** — Document why you're migrating (`create_adr`, status: "proposed")
3. **Model target state** — Use a separate project or overlay the changes
4. **Link ADR to affected elements** — `link_adr_to_element` for each impacted system/container
5. **Track conformance** — Create rules for the target architecture
6. **Monitor drift** — Use `compute_drift_score` as you migrate
