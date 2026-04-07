# Clean Architecture Rule Pack

Enforce clean architecture (hexagonal / ports & adapters) layer boundaries and dependency direction.

## When to Use

Use this pack when your services follow clean architecture principles with clearly separated domain, application, infrastructure, and presentation layers. This pack ensures dependencies always point inward and the domain remains pure.

## Rules

| # | Rule | Type | Severity | Description |
|---|------|------|----------|-------------|
| 1 | Domain Must Not Import Infrastructure | `layer_boundary` | critical | Domain layer cannot depend on infrastructure |
| 2 | Use Cases Must Not Import Presentation | `layer_boundary` | critical | Application layer cannot depend on handlers/controllers |
| 3 | Adapters Must Implement Domain Ports | `required_pattern` | high | Infrastructure adapters must implement domain interfaces |
| 4 | No Framework Imports in Domain | `technology_constraint` | critical | Domain layer must be framework-agnostic |
| 5 | Entities Must Not Depend on External Services | `dependency_rule` | critical | Entities cannot reference external services |
| 6 | Repository Interfaces in Domain Layer | `required_pattern` | high | Repository interfaces must be defined in domain |
| 7 | No Direct HTTP Calls From Domain | `technology_constraint` | critical | Domain cannot use HTTP/network technologies |
| 8 | Handlers Must Only Call Use Cases | `layer_boundary` | high | Presentation layer can only interact with application layer |
| 9 | Layered Container Structure | `required_pattern` | high | Containers must have domain and infrastructure layers |

## How to Install

Using the `archyl-developer` skill in Claude Code:

```
Use the archyl-developer skill to install the clean-architecture conformance rule pack.
Read the rules from rule-packs/clean-architecture/rules.json and create each rule
in my project [PROJECT_ID].
```

Or install rules individually using the `create_conformance_rule` MCP tool. See the main [README](../README.md) for details.

## Customization

- **Layer names** -- Update `source_layer` and `forbidden_target_layers` values to match your layer naming convention (e.g., "adapters" instead of "infrastructure", "ports" instead of "domain").
- **Framework list** -- Extend `forbidden_technologies` in rules 4 and 7 to include frameworks specific to your stack.
- **Handler exceptions** -- Rule 8 allows handlers to reference domain DTOs and value objects. Adjust `exception_types` if your architecture uses different shared types.
- **Strictness** -- For a gradual adoption, lower severity on rules 3 and 6 from `high` to `medium` while teams refactor.

## Pairs Well With

- **API-First** pack for contract governance at the presentation layer boundary
- **Microservices** pack when applying clean architecture inside each microservice
