# Global & Organization-Wide Architecture

## Overview

Archyl supports organization-level architecture management that spans individual projects. Global views let you see systems, relationships, decisions, and documentation across the entire organization, enabling enterprise architecture governance.

## Global Systems

### List All Systems Across the Organization
**Tool**: `list_global_systems`

```
Returns:
- systems: All systems across all projects in the organization
- Useful for understanding the full system landscape
```

### List All Cross-Project Relationships
**Tool**: `list_global_relationships`

```
Returns:
- relationships: All inter-system relationships across the organization
- Shows how projects/systems depend on each other at the org level
```

## Global ADRs

Organization-wide decisions that apply across all projects.

### List Global ADRs
**Tool**: `list_global_adrs`

```
Returns:
- adrs: Organization-wide architecture decision records
```

### Create a Global ADR
**Tool**: `create_global_adr`

```
Parameters:
- title (required): Decision title
- status: "proposed", "accepted", "deprecated", "superseded"
- context: Why this org-wide decision is needed
- decision: What was decided
- consequences: Trade-offs and implications
```

Use global ADRs for decisions that affect all teams:
- "All services must use structured logging with JSON output"
- "New services must be deployed on Kubernetes"
- "Inter-service communication must use gRPC or event channels"

## Global Documentation

### List Global Docs
**Tool**: `list_global_docs`

```
Returns:
- documents: Organization-wide documentation
```

### Create a Global Document
**Tool**: `create_global_doc`

```
Parameters:
- title (required): Document title
- content: Markdown content
- type: Document category
```

Use global docs for:
- Architecture principles and standards
- Technology strategy documents
- Onboarding guides for new engineers
- Cross-team integration guides

## Global API Contracts

### List Global API Contracts
**Tool**: `list_global_api_contracts`

```
Returns:
- contracts: Organization-wide API contracts
```

### Create a Global API Contract
**Tool**: `create_global_api_contract`

```
Parameters:
- name (required): Contract name
- format: "openapi", "grpc", "graphql", "asyncapi"
- content: Contract specification
```

Use global contracts for shared APIs consumed by multiple projects.

## Global Comments

**Tool**: `list_global_comments`

```
Returns:
- comments: Organization-wide comment threads
```

## Organizations & Teams

### List Organizations
**Tool**: `list_organizations`

### Get Organization Details
**Tool**: `get_organization`

```
Parameters:
- organizationId (required): UUID
```

### List Teams
**Tool**: `list_teams`

### Get Team Details
**Tool**: `get_team`

```
Parameters:
- teamId (required): UUID
```

### Create a Team
**Tool**: `create_team`

```
Parameters:
- name (required): Team name
- description: Team purpose and responsibilities
```

## Use Cases

### Enterprise Architecture Overview
```
1. list_global_systems → see all systems across the org
2. list_global_relationships → understand cross-project dependencies
3. get_ownership_map → see which teams own what
```

### Establishing Organization Standards
```
1. create_global_adr: "Mandatory API versioning strategy"
2. create_global_doc: "API Design Guidelines"
3. Create conformance rules in each project that enforce the standard
```

### Cross-Team Dependency Mapping
```
1. list_global_relationships → find all cross-project dependencies
2. get_ownership_map → identify which teams are coupled
3. Use insights to surface problematic dependencies
```

## Best Practices

1. **Use global ADRs sparingly**: Only for truly organization-wide decisions
2. **Document integration points**: Cross-project relationships are the most important to document
3. **Map ownership at the system level**: Every system should have a team owner
4. **Review the global view quarterly**: The org-wide architecture should be reviewed at a regular cadence
