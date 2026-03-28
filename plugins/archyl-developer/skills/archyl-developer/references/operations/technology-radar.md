# Technology Radar

## Overview

Archyl's technology radar tracks all technologies used across your organization, their adoption status, and which elements use them. It's inspired by the ThoughtWorks Technology Radar — a tool for managing technology choices at scale.

## Technology Lifecycle

| Status | Meaning |
|--------|---------|
| `adopt` | Proven, recommended for broad use |
| `trial` | Worth pursuing, used in select projects |
| `assess` | Exploring, not yet in production |
| `hold` | Stop adoption, migrate away from |

## Managing Technologies

### Create a Technology
**Tool**: `create_technology`

```
Parameters:
- name (required): Technology name (e.g., "Go", "PostgreSQL", "Kafka")
- category: "language", "framework", "database", "tool", "platform", "technique"
- status: "adopt", "trial", "assess", "hold"
- description: Why this technology is at this status
```

### Get the Full Radar
**Tool**: `get_technology_radar`

Returns all technologies with:
- Category grouping
- Adoption status
- Usage count (how many C4 elements use this technology)

### Tag Elements with Technologies
**Tool**: `set_element_technologies`

```
Parameters:
- elementId (required): UUID of the C4 element
- elementType (required): C4 level
- technologyIds (required): Array of technology UUIDs
```

### Query Element Technologies
**Tool**: `get_element_technologies`

```
Parameters:
- elementId (required): UUID
- elementType (required): C4 level
```

### Relationship Technologies
- `get_relationship_technologies` — What tech a relationship uses (e.g., gRPC, REST)
- `set_relationship_technologies` — Tag relationships with their protocol/technology

## Operations

- `list_technologies` — List with filters
- `get_technology` — Get details
- `update_technology` — Change status, description
- `delete_technology` — Remove technology

## Example: Setting Up a Radar

```
1. create_technology: "Go" (language, adopt)
2. create_technology: "Python" (language, adopt)
3. create_technology: "Node.js" (language, hold, "Migrating to Go for new services")
4. create_technology: "PostgreSQL" (database, adopt)
5. create_technology: "MongoDB" (database, trial)
6. create_technology: "Kafka" (platform, adopt)
7. create_technology: "RabbitMQ" (platform, hold, "Consolidating on Kafka")

8. set_element_technologies: OrderService → [Go, Kafka]
9. set_element_technologies: OrderDatabase → [PostgreSQL]
10. set_element_technologies: LegacyService → [Node.js, MongoDB]
```

## Best Practices

1. **Review quarterly**: Update statuses as your team's experience evolves
2. **Combine with conformance**: Create `technology_constraint` rules from your radar
3. **Track migration progress**: Technologies on "hold" should trend toward zero usage
4. **Document rationale**: The `description` should explain *why* a technology is at its status
