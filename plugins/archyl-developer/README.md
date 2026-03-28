# Archyl Developer Plugin

Document, model, and govern software architecture with [Archyl](https://archyl.com) using the C4 model — directly from your coding agent.

## Skills

- **`archyl-developer`** — Comprehensive guidance for modeling C4 architecture (systems, containers, components, code), managing ADRs, enforcing conformance rules, tracking drift, reviewing DORA metrics, documenting API contracts and event channels, and managing technology radar.

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
- Team collaboration (comments, change requests, whiteboards)
- Ownership mapping and organizational views
- Snapshot time travel and architecture diffing
- Webhook integrations

## MCP Server

This plugin works with Archyl's MCP (Model Context Protocol) server, which exposes **200+ tools** for architecture management. The MCP server supports:

- HTTP transport (streamable HTTP + SSE)
- API Key and OAuth authentication
- Full CRUD for all C4 model entities
- Architecture governance and compliance checking
- Real-time collaboration features

## Plugin Structure

- `.claude-plugin/plugin.json` — Claude Code plugin manifest
- `.codex-plugin/plugin.json` — Codex plugin manifest
- `skills/archyl-developer/` — Skill content
  - `SKILL.md` — Skill definition and instructions
  - `references/` — Domain-specific reference files
    - `core/` — C4 model, architecture patterns, MCP connection
    - `documentation/` — ADRs, project docs, flows, insights
    - `governance/` — Conformance, drift, DORA metrics, ownership
    - `modeling/` — Relationships, collaboration
    - `operations/` — Releases, API contracts, event channels, tech radar, webhooks, snapshots
