---
name: archyl-developer
description: Use this skill when the user mentions Archyl, C4 model, architecture documentation, architecture diagrams, systems/containers/components modeling, ADRs, architecture decision records, conformance rules, drift detection, DORA metrics, architecture discovery, architecture governance, technology radar, API contracts, event channels, releases, or any task related to documenting or managing software architecture. Also triggers for "update architecture", "add system", "add container", "add component", "create ADR", "check drift", "conformance check", "architecture review".
version: 0.1.0
---

# Archyl Developer Skill

You are an expert at using Archyl — an AI-powered architecture documentation platform that implements the C4 model for software architecture visualization and governance.

## Overview

Archyl provides a comprehensive MCP (Model Context Protocol) server with **200+ tools** for managing software architecture. You interact with Archyl exclusively through MCP tool calls. The tools are prefixed with `mcp__archyl__` in your environment.

**Before doing anything**, always call `mcp__archyl__list_projects` to discover available projects and get the `projectId` you'll need for most operations.

## C4 Model Primer

Archyl implements all 4 levels of the [C4 model](https://c4model.com/):

| Level | Element | Description | Example |
|-------|---------|-------------|---------|
| 1 | **System** | Top-level software systems and external dependencies | "Payment Platform", "Email Service" |
| 2 | **Container** | Deployable units within a system | "API Server", "PostgreSQL Database", "React Frontend" |
| 3 | **Component** | Logical groupings within a container | "AuthService", "PaymentProcessor", "UserRepository" |
| 4 | **Code** | Classes, interfaces, functions within a component | "PaymentGateway interface", "processPayment()" |

**Element types** (used in `elementType` parameters):
- `1` = System
- `2` = Container
- `3` = Component
- `4` = Code Element

**Relationship types**: `uses`, `depends_on`, `calls`, `reads_from`, `writes_to`, `sends_to`, `consumes_from`, `implements`, `extends`

## Tool Categories

### 1. Project Management
- `list_projects` — List all projects (start here!)
- `get_project` — Get project details
- `create_project` — Create a new project
- `update_project` — Update project metadata
- `delete_project` — Delete a project
- `get_project_settings` / `update_project_settings` — Manage project configuration

### 2. C4 Architecture Modeling
**Systems (Level 1):**
- `list_systems` — List all systems in a project
- `create_system` — Create a system (params: `projectId`, `name`, `description`, `type`)
- `update_system` / `delete_system` — Modify or remove systems

**Containers (Level 2):**
- `list_containers` — List containers in a project
- `create_container` — Create a container (params: `projectId`, `systemId`, `name`, `description`, `technology`, `type`)
- Container types: `service`, `database`, `queue`, `api-gateway`, `web-app`, `mobile-app`, `file-storage`, `function`
- `update_container` / `delete_container`

**Components (Level 3):**
- `list_components` — List components in a project
- `create_component` — Create a component (params: `projectId`, `containerId`, `name`, `description`, `technology`)
- `update_component` / `delete_component`

**Code Elements (Level 4):**
- `create_code_element` — Create a code element (params: `projectId`, `componentId`, `name`, `description`, `type`, `language`)
- `update_code_element` / `delete_code_element`

**Full Model:**
- `get_project_c4_model` — Get the complete C4 model for a project in one call (systems, containers, components, code, relationships)

### 3. Relationships
- `create_relationship` — Connect two C4 elements (params: `projectId`, `sourceId`, `sourceType`, `targetId`, `targetType`, `type`, `description`)
- `update_relationship` / `delete_relationship`
- `list_relationships` — List all relationships in a project

### 4. Overlays (Visual Groupings)
- `create_overlay` — Create a visual grouping (bounded contexts, swimlanes)
- `update_overlay` / `delete_overlay` / `list_overlays`

### 5. Architecture Decision Records (ADRs)
- `list_adrs` — List ADRs for a project
- `create_adr` — Create an ADR (params: `projectId`, `title`, `status`, `context`, `decision`, `consequences`)
  - Status values: `proposed`, `accepted`, `deprecated`, `superseded`
- `get_adr` / `update_adr` / `delete_adr`
- `link_adr_to_element` — Link an ADR to a C4 element for traceability

### 6. Project Documentation
- `list_documentation` / `get_documentation`
- `create_documentation` — Create a document (params: `projectId`, `title`, `content`, `type`)
- `update_documentation` / `delete_documentation`
- `move_documentation` — Move doc to folder
- `list_documentation_folders` / `create_documentation_folder` / `update_documentation_folder` / `delete_documentation_folder`

### 7. Flows (User/System Flows)
- `list_flows` / `get_flow`
- `create_flow` — Create a user or system flow with steps
- `update_flow` / `delete_flow`

### 8. Architecture Insights
- `list_insights` — List AI-generated architecture recommendations
- `get_insight` — Get insight details
- `silence_insight` — Dismiss an insight

### 9. Comments & Collaboration
- `list_comments` / `list_comments_by_element` / `get_comment` / `get_comment_count`
- `create_comment` — Add a comment on a project or element
- `update_comment` / `delete_comment`
- `resolve_comment` / `unresolve_comment`
- `add_comment_reaction` / `remove_comment_reaction`

### 10. Architecture Change Requests
- `list_requests` / `get_request`
- `create_request` — Create an architecture change request (like a PR for architecture)
- `update_request`
- `list_request_changes` / `list_request_reviews`

### 11. API Contracts
- `list_api_contracts` / `get_api_contract`
- `create_api_contract` — Create an API contract (OpenAPI, gRPC, GraphQL specs)
- `update_api_contract` / `delete_api_contract`
- `link_api_contract` / `unlink_api_contract` — Link contracts to C4 elements
- `list_api_contracts_by_element`

### 12. Event Channels
- `list_event_channels` / `get_event_channel`
- `create_event_channel` — Define event channels (Kafka topics, SQS queues, etc.)
- `update_event_channel` / `delete_event_channel`
- `link_event_channel` / `unlink_event_channel`
- `list_event_channels_by_element`

### 13. Releases & Environments
- `list_environments` / `create_environment` / `update_environment` / `delete_environment` / `reorder_environments`
- `list_releases` / `get_release` / `create_release` / `update_release` / `delete_release`

### 14. Technology Radar
- `list_technologies` — List technologies with filters
- `create_technology` / `get_technology` / `update_technology` / `delete_technology`
- `get_technology_radar` — Get all technologies with usage counts
- `get_element_technologies` / `set_element_technologies`
- `get_relationship_technologies` / `set_relationship_technologies`

### 15. Conformance Rules (Architecture Governance)
- `list_conformance_rules` / `get_conformance_rule`
- `create_conformance_rule` — Create architecture rules
  - Rule types: `technology_constraint`, `dependency_rule`, `naming_convention`, `contract_compliance`, `required_pattern`, `layer_boundary`, `event_channel_compliance`
- `update_conformance_rule` / `delete_conformance_rule`
- `run_conformance_check` — Run compliance rules against changes
- `list_conformance_checks` / `get_conformance_report` / `get_conformance_stats`

### 16. Drift Detection (Architecture vs Code)
- `compute_drift_score` — Trigger drift computation (compares C4 model vs actual codebase)
- `get_drift_score` — Get latest drift score (0-100%)
- `get_drift_history` — Get drift trends over time
- `get_drift_details` — Get per-element drift breakdown

### 17. DORA Metrics
- `get_dora_metrics` — Calculate Deployment Frequency, Lead Time, Change Failure Rate, MTTR
- `get_dora_trend` — Get DORA metrics over time (granularity: `day`, `week`, `month`)

### 18. Ownership
- `add_element_owner` / `remove_element_owner` / `set_element_owners` / `get_element_owners`
- `get_ownership_map` — Get organizational ownership structure across the org

### 19. Whiteboards
- `list_whiteboards` / `get_whiteboard` / `create_whiteboard` / `delete_whiteboard`

### 20. Snapshots & History
- `list_versions` / `get_version` / `diff_version` — Time-travel through architecture snapshots
- `list_history` — Audit/change history

### 21. Global Architecture (Org-Wide)
- `list_global_systems` / `list_global_relationships`
- `list_global_adrs` / `create_global_adr`
- `list_global_docs` / `create_global_doc`

### 22. Organizations & Teams
- `list_organizations` / `get_organization`
- `list_teams` / `get_team` / `create_team`

### 23. Webhooks
- `list_webhook_notifications` / `get_webhook_notification`
- `create_webhook_notification` / `update_webhook_notification` / `delete_webhook_notification`
- `test_webhook_notification` / `list_webhook_deliveries`

### 24. Marketplace (Widgets & Integrations)
- `list_marketplace_products` / `get_marketplace_product`
- `list_marketplace_connections` / `get_marketplace_connection`
- `create_marketplace_connection` / `update_marketplace_connection` / `delete_marketplace_connection`
- `list_marketplace_widgets` / `get_marketplace_widget` / `create_marketplace_widget` / `update_marketplace_widget` / `delete_marketplace_widget`
- `list_marketplace_widgets_by_element`
- `create_organization_widget` / `list_organization_widgets`

### 25. Agent Context
- `get_agent_context` — Get enriched context for AI agents working with the project

## Common Workflows

### Workflow 1: Document a New Project's Architecture

```
1. create_project → get projectId
2. create_system (one per top-level system)
3. create_container (services, databases, queues within each system)
4. create_component (logical modules within containers)
5. create_relationship (connect elements together)
6. create_overlay (optional: group by bounded context or team)
```

### Workflow 2: Analyze Existing Architecture

```
1. list_projects → find project
2. get_project_c4_model → get full model in one call
3. list_relationships → understand connections
4. list_adrs → review past decisions
5. get_drift_score → check if docs match reality
6. list_insights → review AI recommendations
```

### Workflow 3: Architecture Governance Check

```
1. list_conformance_rules → see existing rules
2. create_conformance_rule → add new rules if needed
3. run_conformance_check → check compliance
4. get_conformance_report → review violations
5. get_conformance_stats → see compliance trends
```

### Workflow 4: Track Architecture Drift

```
1. compute_drift_score → trigger fresh computation
2. get_drift_score → see overall score (0-100%)
3. get_drift_details → identify which elements have drifted
4. get_drift_history → see trends
```

### Workflow 5: Record an Architecture Decision

```
1. create_adr with status "proposed"
2. link_adr_to_element → connect to affected C4 elements
3. create_comment → add discussion
4. update_adr with status "accepted" → when decision is finalized
```

### Workflow 6: Manage Technology Radar

```
1. list_technologies → see current tech landscape
2. get_technology_radar → get full radar with usage counts
3. create_technology → register new technologies
4. set_element_technologies → tag elements with their tech stack
```

### Workflow 7: Review DORA Metrics

```
1. get_dora_metrics → get current metrics (DF, LT, CFR, MTTR)
2. get_dora_trend with granularity "week" → see weekly trends
```

### Workflow 8: Manage Releases

```
1. list_environments → see deployment environments
2. create_release → register a new release
3. list_releases → track release history
```

## Best Practices

### Naming Conventions
- **Systems**: PascalCase, descriptive (`PaymentPlatform`, `NotificationService`)
- **Containers**: PascalCase with type hint (`ApiServer`, `PostgresDatabase`, `RedisCache`)
- **Components**: PascalCase, module-oriented (`AuthService`, `PaymentProcessor`)
- **Code Elements**: Exact symbol names from source code

### Relationship Modeling
- Use `uses` for general dependencies between systems
- Use `calls` for synchronous HTTP/gRPC calls between containers
- Use `sends_to` / `consumes_from` for async messaging (queues, events)
- Use `reads_from` / `writes_to` for database access
- Use `implements` / `extends` for code-level inheritance

### ADR Best Practices
- Always set a meaningful `status` (proposed → accepted → deprecated/superseded)
- Link ADRs to the C4 elements they affect with `link_adr_to_element`
- Include `context` (why), `decision` (what), and `consequences` (trade-offs)

### Architecture as Code
- Use `get_project_c4_model` to export the full model before making changes
- Use `diff_version` to compare snapshots before and after changes
- Set up `conformance_rules` to enforce architectural guardrails
- Regularly check `drift_score` to ensure documentation stays accurate

### Working with Large Architectures
- Start with `list_projects` to orient yourself
- Use `get_project_c4_model` for a complete snapshot rather than listing each level separately
- Use `get_agent_context` for AI-enriched context about the project
- Navigate top-down: systems → containers → components → code

## MCP Connection

Archyl's MCP server runs at a configurable HTTP endpoint. Connection requires either:
- **API Key**: `X-API-Key` header
- **OAuth Bearer**: `Authorization` header

The MCP server supports both SSE (Server-Sent Events) and streamable HTTP transports.

## References

For detailed guidance on specific topics, see the reference files:

- **Core Concepts**: `references/core/` — C4 model deep-dive, architecture patterns, MCP protocol details
- **Modeling**: `references/modeling/` — Systems, containers, components, code elements, relationships
- **Documentation**: `references/documentation/` — ADRs, project docs, flows, insights
- **Governance**: `references/governance/` — Conformance rules, drift detection, DORA metrics, ownership
- **Operations**: `references/operations/` — Releases, API contracts, event channels, technology radar, webhooks
