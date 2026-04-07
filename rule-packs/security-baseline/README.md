# Security Baseline Rule Pack

Enforce architecture-level security governance rules for threat mitigation.

## When to Use

Use this pack as a baseline for any production architecture. These rules catch common security anti-patterns at the architecture level -- before code is written. They enforce gateway patterns, data protection, network segmentation, and dependency documentation that security teams need for review.

## Rules

| # | Rule | Type | Severity | Description |
|---|------|------|----------|-------------|
| 1 | No Public Services Without API Gateway | `dependency_rule` | critical | All public services must sit behind a gateway |
| 2 | External Dependencies Must Be Documented | `required_pattern` | high | All external dependencies must be explicit relationships |
| 3 | Database Not Publicly Accessible | `dependency_rule` | critical | Databases must not be reachable from outside the system |
| 4 | Authentication as Separate Service | `required_pattern` | high | Auth must be a dedicated container, not embedded |
| 5 | No Secrets in Container Configuration | `technology_constraint` | critical | No credentials in container descriptions or configs |
| 6 | External API Calls Must Be Documented | `dependency_rule` | high | Outbound calls must be modeled as relationships |
| 7 | Encryption Technology for Data at Rest | `technology_constraint` | high | Database containers must specify encryption |
| 8 | Network Segmentation Between Layers | `layer_boundary` | high | Presentation layer cannot directly access data layer |

## How to Install

Using the `archyl-developer` skill in Claude Code:

```
Use the archyl-developer skill to install the security-baseline conformance rule pack.
Read the rules from rule-packs/security-baseline/rules.json and create each rule
in my project [PROJECT_ID].
```

Or install rules individually using the `create_conformance_rule` MCP tool. See the main [README](../README.md) for details.

## Customization

- **Secrets patterns** -- Extend `forbidden_patterns_in_description` in rule 5 to include patterns specific to your stack (e.g., `AWS_SECRET_ACCESS_KEY`, `MONGO_URI`).
- **Auth model** -- If your organization uses a third-party auth provider (Auth0, Okta), you may model it as an external system instead of an internal container. Adjust rule 4 accordingly.
- **Encryption requirement** -- If some databases intentionally store non-sensitive public data, scope rule 7 to containers tagged with "sensitive-data".
- **Gateway exceptions** -- If you have internal-only services that are public within a VPN, consider adding a tag exception to rule 1.

## Pairs Well With

- **Microservices** pack for service boundary enforcement
- **API-First** pack for authentication and rate limiting documentation
- **Event-Driven** pack for securing async communication channels
