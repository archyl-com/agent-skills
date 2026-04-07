# Microservices Architecture Rule Pack

Enforce microservices architecture boundaries, service independence, and communication patterns.

## When to Use

Use this pack when your system is designed as a set of independently deployable services, each owning its own data and communicating through well-defined interfaces. This pack prevents common anti-patterns that erode microservices boundaries over time.

## Rules

| # | Rule | Type | Severity | Description |
|---|------|------|----------|-------------|
| 1 | No Shared Databases | `dependency_rule` | critical | No two services can depend on the same database |
| 2 | Service Must Have Own Container | `required_pattern` | critical | Each service must be modeled as its own container |
| 3 | No Direct DB Calls From API Gateway | `dependency_rule` | critical | API gateways must route to services, never query DBs |
| 4 | Inter-Service Communication Via Contracts | `contract_compliance` | high | Synchronous inter-service calls need API contracts |
| 5 | Health Check Component Required | `required_pattern` | high | Each service must include a health check component |
| 6 | Maximum Dependency Depth | `dependency_rule` | high | Dependency chains max 3 hops between services |
| 7 | No Circular Dependencies | `dependency_rule` | critical | No circular dependency chains between services |
| 8 | Independent Deployment Artifact | `required_pattern` | high | Each service must have Docker/OCI technology assigned |
| 9 | Service Naming Convention | `naming_convention` | medium | Service names must be PascalCase |
| 10 | Documented Inter-Service Relationships | `dependency_rule` | medium | All inter-service relationships must have descriptions |

## How to Install

Using the `archyl-developer` skill in Claude Code:

```
Use the archyl-developer skill to install the microservices conformance rule pack.
Read the rules from rule-packs/microservices/rules.json and create each rule
in my project [PROJECT_ID].
```

Or install rules individually using the `create_conformance_rule` MCP tool. See the main [README](../README.md) for details.

## Customization

- **Relaxing "No Shared Databases"** -- If you have a legitimate read replica shared between services, consider scoping this rule to write-access relationships only.
- **Adjusting dependency depth** -- The default max depth of 3 works for most topologies. Increase to 4 if your architecture has a standard middleware layer.
- **Naming convention** -- Change the PascalCase pattern to match your org's conventions (e.g., kebab-case for Kubernetes-native naming).
- **Health check pattern** -- Adjust the `component_name_pattern` regex if your health checks use a different naming convention.

## Pairs Well With

- **Event-Driven** pack for async communication governance
- **Security Baseline** pack for API gateway and network segmentation rules
- **API-First** pack for contract rigor on inter-service APIs
