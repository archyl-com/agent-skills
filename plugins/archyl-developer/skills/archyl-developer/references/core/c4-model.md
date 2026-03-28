# C4 Model in Archyl

## What is the C4 Model?

The C4 model is a hierarchical approach to software architecture visualization created by Simon Brown. It uses four levels of abstraction to describe a software system, from the highest-level context down to individual code elements.

Archyl implements all four levels as first-class entities with full CRUD, relationships, and visual diagram support.

## Level 1: System Context

**Purpose**: Shows how your software system fits into the world around it.

**What to model**:
- Your primary software system(s)
- External systems it interacts with (third-party APIs, SaaS, legacy systems)
- Users/personas that interact with the system

**Tool**: `create_system`

```
Parameters:
- projectId (required): UUID of the project
- name (required): System name in PascalCase (e.g., "PaymentPlatform")
- description: What the system does and why it exists
- type: "internal" or "external"
```

**When to create a system**:
- Each independently deployable platform or product = 1 system
- Each external dependency (Stripe, SendGrid, AWS S3) = 1 external system
- Each legacy system being replaced = 1 system

## Level 2: Container Diagram

**Purpose**: Shows the high-level technology choices and how containers communicate.

**What to model**:
- Applications (web apps, mobile apps, desktop apps)
- Services (API servers, microservices)
- Data stores (databases, file systems, caches)
- Message brokers (queues, event streams)

**Tool**: `create_container`

```
Parameters:
- projectId (required): UUID of the project
- systemId (required): UUID of the parent system
- name (required): Container name in PascalCase (e.g., "ApiServer")
- description: What this container does
- technology: Primary technology (e.g., "Go + Fiber", "PostgreSQL 15", "React + Vite")
- type: One of:
    - "service" — Backend service, API, microservice
    - "database" — Relational/NoSQL database
    - "queue" — Message queue, event stream
    - "api-gateway" — API gateway, load balancer
    - "web-app" — Frontend web application
    - "mobile-app" — Mobile application
    - "file-storage" — Blob storage, CDN
    - "function" — Serverless function
```

## Level 3: Component Diagram

**Purpose**: Shows the internal structure of a container — its logical modules and how they interact.

**What to model**:
- Services (business logic modules)
- Repositories (data access layers)
- Controllers/Handlers (entry points)
- Domain modules (bounded contexts)

**Tool**: `create_component`

```
Parameters:
- projectId (required): UUID of the project
- containerId (required): UUID of the parent container
- name (required): Component name (e.g., "AuthService", "PaymentProcessor")
- description: What this component is responsible for
- technology: Implementation technology
```

## Level 4: Code Diagram

**Purpose**: Shows fine-grained code elements — classes, interfaces, functions.

**What to model**:
- Classes and structs
- Interfaces and protocols
- Key functions and methods
- Enums and constants

**Tool**: `create_code_element`

```
Parameters:
- projectId (required): UUID of the project
- componentId (required): UUID of the parent component
- name (required): Exact symbol name from source code
- description: What this code element does
- type: "class", "interface", "function", "struct", "enum", "constant"
- language: Programming language
```

## Relationships

Relationships model how C4 elements communicate, depend on, or extend each other.

**Tool**: `create_relationship`

```
Parameters:
- projectId (required): UUID
- sourceId (required): UUID of the source element
- sourceType (required): C4 level of source (1=system, 2=container, 3=component, 4=code)
- targetId (required): UUID of the target element
- targetType (required): C4 level of target
- type: Relationship type (see below)
- description: Human-readable description (e.g., "Sends payment events via Kafka")
```

**Relationship type guide**:

| Type | Use When | Example |
|------|----------|---------|
| `uses` | General dependency between systems | "Frontend uses API Server" |
| `depends_on` | Strong compile-time or runtime dependency | "Service depends on shared library" |
| `calls` | Synchronous HTTP/gRPC/RPC call | "API calls Payment Service" |
| `reads_from` | Reading data from a store | "Service reads from PostgreSQL" |
| `writes_to` | Writing data to a store | "Service writes to Redis cache" |
| `sends_to` | Publishing async messages | "Service sends to Kafka topic" |
| `consumes_from` | Consuming async messages | "Worker consumes from SQS queue" |
| `implements` | Interface implementation | "PaymentGateway implements PaymentProvider" |
| `extends` | Class/struct inheritance | "AdminUser extends User" |

## Overlays

Overlays are visual groupings that sit on top of the C4 model. They don't change the architecture — they add visual context.

**Tool**: `create_overlay`

Use overlays for:
- **Bounded contexts** (DDD): Group containers by domain boundary
- **Team ownership**: Show which team owns which containers
- **Deployment zones**: Group by cloud region or environment
- **Security zones**: Show trust boundaries

## Full Model Retrieval

For reading the complete architecture, use `get_project_c4_model` instead of calling `list_systems`, `list_containers`, etc. separately. It returns everything in one call:

```
Parameters:
- projectId (required): UUID
Returns:
- systems: All systems with their containers
- containers: All containers with their components
- components: All components with code elements
- relationships: All relationships
- overlays: All overlays
```

## Navigating the Hierarchy

Always work top-down:

1. `list_projects` → find your project
2. `get_project_c4_model` → see everything at once
3. Drill into specific elements as needed

Every element has a UUID. Store these as you work — you'll need them for creating relationships, linking ADRs, assigning ownership, etc.
