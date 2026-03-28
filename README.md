# Archyl Coding Agent Plugin Marketplace

This repository provides a [Marketplace](https://code.claude.com/docs/en/discover-plugins) of coding agent plugins for working with [Archyl](https://archyl.com) — the AI-powered architecture documentation platform.

> [!NOTE]
> These plugins are in Public Preview and will continue to evolve and improve.
> We'd love to hear your feedback at [GitHub Issues](https://github.com/archyl-com/agent-skills/issues).

## Installation — Claude Code

**Step 1:** Marketplace Installation

1. Run `/plugin marketplace add archyl-com/agent-skills`
2. Run `/plugin` to open the plugin manager
3. Select **Marketplaces**
4. Choose `archyl-marketplace` from the list
5. Select **Enable auto-update** or **Disable auto-update**

**Step 2:** Plugin Installation

1. Run `/plugin install archyl-developer@archyl-com-agent-skills`
2. Restart Claude Code

**Step 3:** Configure MCP Server

Add this to your project's `.mcp.json`:

```json
{
    "mcpServers": {
        "archyl": {
            "type": "http",
            "url": "https://api.archyl.com/mcp",
            "headers": {
                "X-API-Key": "arch_your_api_key_here"
            }
        }
    }
}
```

Get your API key from the Archyl dashboard under **Settings → API Keys**.

## Other Coding Agents

The skill content is compatible with any agent that supports the plugin format. See the [archyl-developer plugin](./plugins/archyl-developer) for direct installation.

## Current Plugins

| Plugin                                             | Description                                                                                                            |
| -------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| **[archyl-developer](./plugins/archyl-developer)** | Comprehensive assistance for documenting, modeling, and governing software architecture with Archyl using the C4 model |

## What Can the Plugin Do?

The `archyl-developer` plugin gives your coding agent deep knowledge of Archyl's **200+ MCP tools** across these domains:

| Domain            | Capabilities                                                                        |
| ----------------- | ----------------------------------------------------------------------------------- |
| **C4 Modeling**   | Create and manage systems, containers, components, code elements, and relationships |
| **Documentation** | Architecture Decision Records, project docs, user/system flows, AI insights         |
| **Governance**    | Conformance rules, drift detection, DORA metrics, ownership mapping                 |
| **Operations**    | Releases, environments, API contracts, event channels, technology radar             |
| **Collaboration** | Comments, change requests, whiteboards, team management                             |
| **History**       | Snapshots, time travel, architecture diffing, audit logs                            |
| **Integrations**  | Webhooks, marketplace widgets, global architecture views                            |

## Requirements

- An Archyl account with API access
- Archyl MCP server running (self-hosted or cloud)
- Claude Code, Codex, or compatible coding agent
