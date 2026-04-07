# API-First Development Rule Pack

Enforce API contract-first practices, versioning, and documentation standards.

## When to Use

Use this pack when you want APIs to be designed and documented before implementation begins. This pack ensures every service exposes well-defined contracts, breaking changes are governed, and consumers have the information they need to integrate reliably.

## Rules

| # | Rule | Type | Severity | Description |
|---|------|------|----------|-------------|
| 1 | Public Services Must Have API Contract | `contract_compliance` | critical | All public services need OpenAPI/gRPC/GraphQL contracts |
| 2 | API Version Must Be Documented | `contract_compliance` | high | Contracts must include version identifiers |
| 3 | Breaking Changes Require ADR | `required_pattern` | high | Breaking changes must have an accompanying ADR |
| 4 | Authentication Documented in Contracts | `contract_compliance` | high | Auth requirements must be in the contract |
| 5 | Rate Limiting Specified | `contract_compliance` | medium | Public APIs must document rate limits |
| 6 | Standard Error Response Format | `contract_compliance` | high | Error responses must follow RFC 7807 or equivalent |
| 7 | Internal APIs Must Have Contracts | `contract_compliance` | medium | Internal service-to-service APIs should have contracts too |
| 8 | Contract Must Match Implementation | `contract_compliance` | high | Contracts must be linked to implementing containers |

## How to Install

Using the `archyl-developer` skill in Claude Code:

```
Use the archyl-developer skill to install the api-first conformance rule pack.
Read the rules from rule-packs/api-first/rules.json and create each rule
in my project [PROJECT_ID].
```

Or install rules individually using the `create_conformance_rule` MCP tool. See the main [README](../README.md) for details.

## Customization

- **Contract types** -- Adjust `contract_types` in rule 1 to match your stack. Add "asyncapi" if you also govern event contracts here.
- **Error format standard** -- Change from RFC 7807 to your organization's error format if you have one.
- **Internal API strictness** -- Promote rule 7 from `medium` to `high` if you want strict governance on all APIs, not just public ones.
- **Rate limiting** -- If rate limiting is handled at the infrastructure level (e.g., API gateway), you may scope rule 5 to only apply to services that handle their own rate limiting.

## Pairs Well With

- **Microservices** pack for inter-service communication governance
- **Clean Architecture** pack for ensuring contracts live at the right layer boundary
- **Security Baseline** pack for auth and gateway enforcement
