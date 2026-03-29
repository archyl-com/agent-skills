# Archyl Developer Plugin

Document, model, and govern software architecture with [Archyl](https://archyl.com) using the C4 model -- directly from your coding agent.

## Skills

- **`archyl-developer`** -- Guides C4 architecture modeling, ADRs, governance, drift detection, and DORA metrics using Archyl MCP tools.

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

- **0.2.0** -- Restructured SKILL.md with decision tree, few-shot examples, error handling, quick start flow, and allowed-tools. Added reference files for marketplace, whiteboards, global architecture, and change requests.
- **0.1.0** -- Initial release with full tool catalog and workflows.
