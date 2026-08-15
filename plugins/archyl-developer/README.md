# Archyl Developer Plugin

Document, model, and govern software architecture with [Archyl](https://archyl.com) using the C4 model -- directly from your coding agent.

## Skills

- **`archyl-developer`** -- Guides C4 architecture modeling, ADRs, governance, drift detection, and DORA metrics using Archyl MCP tools.
- **`archyl-harness`** -- Work-session protocol: declare a unit of work before coding (focused context + advisory leases + preflight gate), heartbeat while working, finish with an outcome that can open an Architecture Change Request.

## Archyl Guard (PreToolUse hook)

The plugin ships a `PreToolUse` hook that runs the project's Archyl conformance
rules on every file the agent is about to write. Critical violations block the
edit with an explanation the agent can act on; high-severity ones pass through
as a visible warning. The hook is **fail-open**: without configuration or
network access it does nothing.

Enable it by exporting:

```bash
export ARCHYL_API_KEY=arch_...
export ARCHYL_PROJECT_ID=<project uuid>
# optional
export ARCHYL_API_URL=https://api.archyl.com   # default
export ARCHYL_GUARD_BLOCK=critical             # critical (default) | high | off
```

or by placing a `.archyl.json` at the repository root:

```json
{ "apiUrl": "https://api.archyl.com", "projectId": "<uuid>" }
```

(prefer the environment variable for the API key).

## What It Covers

- Creating and managing C4 architecture models (all 4 levels)
- Defining relationships between systems, containers, components, and code
- Architecture Decision Records (ADRs) with element traceability
- Conformance rules and architecture governance
- Architecture drift detection and remediation
- DORA metrics for deployment performance
- API contract documentation (OpenAPI, gRPC, GraphQL, AsyncAPI)
- Event channel mapping (Kafka, RabbitMQ, SQS, etc.)
- Technology radar management
- Release and environment tracking
- Architecture change requests and review workflows
- Team collaboration (comments, whiteboards)
- Ownership mapping and organizational views
- Snapshot time travel and architecture diffing
- Webhook integrations and marketplace widgets
- Global/org-wide architecture views

## MCP Server

This plugin works with Archyl's MCP (Model Context Protocol) server, which exposes **200+ tools** for architecture management. The MCP server supports:

- HTTP transport (streamable HTTP + SSE)
- API Key and OAuth authentication
- Full CRUD for all C4 model entities
- Architecture governance and compliance checking
- Real-time collaboration features

## Plugin Structure

- `.claude-plugin/plugin.json` -- Claude Code plugin manifest
- `.codex-plugin/plugin.json` -- Codex plugin manifest
- `skills/archyl-developer/` -- Skill content
  - `SKILL.md` -- Skill definition with decision tree, examples, and error handling
  - `references/` -- Domain-specific reference files
    - `core/` -- C4 model, architecture patterns, MCP connection, global architecture
    - `documentation/` -- ADRs, project docs, flows, insights
    - `governance/` -- Conformance, drift, DORA metrics, ownership
    - `modeling/` -- Relationships, collaboration, whiteboards, change requests
    - `operations/` -- Releases, API contracts, event channels, tech radar, webhooks, marketplace, snapshots

## Version History

- **0.6.0** -- Memory: `remember`/`recall` guidance in the harness skill, memory step in the setup templates, 15-tool coding profile.
- **0.5.0** -- Added the `archyl-harness` work-session skill and the Archyl Guard `PreToolUse` hook (conformance check on every file write, blocking on critical violations).
- **0.2.0** -- Restructured SKILL.md with decision tree, few-shot examples, error handling, quick start flow, and allowed-tools. Added reference files for marketplace, whiteboards, global architecture, and change requests.
- **0.1.0** -- Initial release with full tool catalog and workflows.
