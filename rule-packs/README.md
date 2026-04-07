# Archyl Conformance Rule Packs

Pre-built conformance rule packs for common architecture patterns. Each pack contains a curated set of rules that enforce architectural best practices, ready to install into any Archyl project.

## Available Packs

| Pack | Rules | Category | Description |
|------|-------|----------|-------------|
| [Microservices](./microservices/) | 10 | Architecture Pattern | Service boundaries, independence, communication patterns |
| [Clean Architecture](./clean-architecture/) | 9 | Architecture Pattern | Layer boundaries, dependency direction, port/adapter enforcement |
| [Event-Driven](./event-driven/) | 8 | Architecture Pattern | Event channel governance, schema compliance, naming |
| [API-First](./api-first/) | 8 | Architecture Pattern | Contract-first development, versioning, documentation |
| [Security Baseline](./security-baseline/) | 8 | Security | Architecture-level security governance |

## How to Install a Pack

### Using the archyl-developer skill

The recommended way to install a rule pack is through the `archyl-developer` skill in Claude Code:

```
Use the archyl-developer skill to create conformance rules from the microservices rule pack
at rule-packs/microservices/rules.json. Apply them to project [your-project-id].
```

### Using the Archyl MCP tools directly

You can also create rules one by one using the `create_conformance_rule` tool:

```json
{
  "name": "No Shared Databases",
  "ruleType": "dependency_rule",
  "severity": "critical",
  "description": "Each service must own its data...",
  "projectId": "your-project-id",
  "config": { ... }
}
```

### Programmatic installation

Parse the `rules.json` file and iterate through the rules array, calling the Archyl API for each rule:

```bash
# Example with jq and curl
for rule in $(cat rules.json | jq -c '.rules[]'); do
  curl -X POST https://api.archyl.com/conformance-rules \
    -H "Authorization: Bearer $ARCHYL_TOKEN" \
    -H "Content-Type: application/json" \
    -d "$rule"
done
```

## Customizing Rules After Installation

Rule packs are starting points, not rigid frameworks. After installing a pack:

1. **Adjust severities** -- Promote rules to `critical` for strict enforcement, or relax to `low` for advisory guidance during adoption.
2. **Scope rules** -- Apply rules to specific projects rather than org-wide if your architecture varies.
3. **Disable selectively** -- Turn off rules that don't apply to your context (e.g., disable "Event Schema Required" if you use a schema registry that handles this externally).
4. **Extend configs** -- Add forbidden technologies, naming patterns, or layer names that match your conventions.

## Combining Packs

Packs are designed to work together. Common combinations:

- **Microservices + Event-Driven + Security Baseline** -- Full microservices governance
- **Clean Architecture + API-First** -- Structured monolith or modular monolith
- **All five packs** -- Comprehensive governance for event-driven microservices

When combining packs, review for overlapping rules and disable duplicates to keep the conformance report clean.

## How to Contribute a New Rule Pack

1. Create a new directory under `rule-packs/` with a descriptive name
2. Add a `rules.json` following the standard format:
   ```json
   {
     "name": "Pack Name",
     "description": "One-line description",
     "version": "1.0.0",
     "category": "architecture-pattern | security | operational",
     "rules": [...]
   }
   ```
3. Add a `README.md` describing the pack, its rules, and when to use it
4. Include 6-10 rules per pack -- enough to be useful, not so many it's overwhelming
5. Use clear `description` fields that explain both **what** the rule enforces and **why**
6. Submit a pull request

### Rule Types Reference

| Type | Purpose |
|------|---------|
| `technology_constraint` | Enforce allowed/forbidden technologies on elements |
| `dependency_rule` | Control which elements can depend on which |
| `naming_convention` | Enforce naming patterns on elements or channels |
| `contract_compliance` | Require API contracts on specific elements or relationships |
| `required_pattern` | Require certain patterns, components, or structures |
| `layer_boundary` | Enforce layered architecture dependency rules |
| `event_channel_compliance` | Enforce event/messaging channel rules |

### Severity Levels

| Severity | When to Use |
|----------|-------------|
| `critical` | Violations that break the architecture pattern fundamentally |
| `high` | Violations that significantly increase risk or coupling |
| `medium` | Violations that reduce quality but don't break the pattern |
| `low` | Advisory rules and best-practice suggestions |
