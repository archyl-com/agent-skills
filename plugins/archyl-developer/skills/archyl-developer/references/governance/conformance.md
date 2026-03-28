# Conformance Rules (Architecture Governance)

## Overview

Conformance rules are architectural guardrails that enforce constraints on your C4 model. They let you define rules that the architecture must follow and automatically check for violations — like linting, but for architecture.

## Rule Types

| Rule Type | Purpose | Example |
|-----------|---------|---------|
| `technology_constraint` | Enforce allowed/forbidden technologies | "All services must use Go or Rust" |
| `dependency_rule` | Control which elements can depend on which | "Frontend containers must not call Database containers directly" |
| `naming_convention` | Enforce naming patterns | "All containers must follow PascalCase" |
| `contract_compliance` | Require API contracts on specific elements | "All services must have an OpenAPI spec" |
| `required_pattern` | Require certain patterns or structures | "Every service must have a health check component" |
| `layer_boundary` | Enforce layered architecture rules | "Domain layer must not import from infrastructure" |
| `event_channel_compliance` | Enforce event/messaging rules | "All async communication must go through event channels" |

## Creating Rules

**Tool**: `create_conformance_rule`

```
Parameters:
- projectId (required): UUID
- name (required): Human-readable rule name
- type (required): One of the rule types above
- description: What this rule enforces and why
- config: Rule-specific configuration (JSON)
- severity: "error", "warning", or "info"
```

## Running Checks

**Tool**: `run_conformance_check`

Runs all active conformance rules against the current architecture (or specific changed files).

```
Parameters:
- projectId (required): UUID
- changedFiles: (optional) Array of file paths to check incrementally
```

## Reviewing Results

```
1. run_conformance_check(projectId) → triggers check
2. list_conformance_checks(projectId) → list check runs
3. get_conformance_report(checkId) → detailed violations
4. get_conformance_stats(projectId) → compliance statistics
```

## Example: Setting Up Governance

### Technology Standards
```
create_conformance_rule:
  name: "Backend Language Policy"
  type: "technology_constraint"
  description: "All backend services must use Go, Rust, or Java"
  severity: "error"
```

### Dependency Boundaries
```
create_conformance_rule:
  name: "No Direct DB Access from Frontend"
  type: "dependency_rule"
  description: "Frontend containers must access data through API containers only"
  severity: "error"
```

### API Contract Requirements
```
create_conformance_rule:
  name: "OpenAPI Required for Public Services"
  type: "contract_compliance"
  description: "All externally-facing services must have an OpenAPI contract"
  severity: "warning"
```

## Workflow: Governance in CI/CD

1. **Define rules** in Archyl before the PR is created
2. **Run conformance check** as part of architecture review
3. **Review report** — fix errors, acknowledge warnings
4. **Track stats** over time — trending toward full compliance

## Best Practices

1. **Start with errors for critical rules**: Technology constraints and layer boundaries
2. **Use warnings for aspirational rules**: New conventions being adopted gradually
3. **Review stats regularly**: `get_conformance_stats` shows compliance trends
4. **Link to ADRs**: When creating a rule, reference the ADR that motivated it
