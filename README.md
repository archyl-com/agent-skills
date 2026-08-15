# Archyl Agent Skills

A [Marketplace](https://code.claude.com/docs/en/discover-plugins) of coding agent plugins for [Archyl](https://archyl.com) — the Architecture Intelligence Platform for AI-Native Teams.

> [!NOTE]
> These plugins are in Public Preview and will continue to evolve and improve.
> We'd love to hear your feedback at [GitHub Issues](https://github.com/archyl-com/agent-skills/issues).

## Why

AI agents write better code when they understand the architecture. Archyl gives agents access to your C4 model, conformance rules, ADRs, API contracts, and technology radar — so they respect your architecture before writing a single line of code.

## Available Skills

| Skill | Description |
|-------|-------------|
| **[archyl-developer](./plugins/archyl-developer/skills/archyl-developer)** | Comprehensive skill for modeling, documenting, and governing software architecture with the C4 model. 200+ MCP tools. |
| **[archyl-preflight](./plugins/archyl-developer/skills/archyl-preflight)** | Pre-flight validation. Run **before** implementing a feature to verify your approach conforms to the architecture. |
| **[archyl-postship](./plugins/archyl-developer/skills/archyl-postship)** | Post-ship documentation. Run **after** shipping to auto-update the C4 model, create ADRs, and file Change Requests. |
| **[archyl-changelog](./plugins/archyl-developer/skills/archyl-changelog)** | Architecture changelog. Generate a readable timeline of architecture changes, ADRs, releases, and drift evolution. |
| **[archyl-review](./plugins/archyl-developer/skills/archyl-review)** | Architecture review bot. Analyzes code changes against the C4 model and conformance rules to provide structured PR feedback. |
| **[archyl-dora](./plugins/archyl-developer/skills/archyl-dora)** | DORA correlation engine. Analyzes how architecture changes impact deployment frequency, lead time, change failure rate, and MTTR. |
| **[archyl-autofix](./plugins/archyl-developer/skills/archyl-autofix)** | Drift auto-fix. Proposes specific fixes when drift is detected — update docs or suggest code changes. |
| **[archyl-roi](./plugins/archyl-developer/skills/archyl-roi)** | Architecture ROI calculator. Quantifies the financial impact of architecture decisions on developer productivity and reliability. |
| **[archyl-predict](./plugins/archyl-developer/skills/archyl-predict)** | Predictive insights. Forecasts drift trajectories, DORA regressions, and complexity hotspots before they materialize. |
| **[archyl-orchestrate](./plugins/archyl-developer/skills/archyl-orchestrate)** | Multi-agent coordination. Negotiates API contracts, resolves dependency conflicts, and coordinates cross-team architecture changes. |

## Installation — Claude Code

**Step 1: Marketplace**

```bash
/plugin marketplace add archyl-com/agent-skills
```

**Step 2: Install skills**

```bash
/plugin install archyl-developer@archyl-marketplace
/plugin install archyl-preflight@archyl-marketplace
/plugin install archyl-postship@archyl-marketplace
/plugin install archyl-changelog@archyl-marketplace
/plugin install archyl-review@archyl-marketplace
/plugin install archyl-dora@archyl-marketplace
/plugin install archyl-autofix@archyl-marketplace
/plugin install archyl-roi@archyl-marketplace
/plugin install archyl-predict@archyl-marketplace
/plugin install archyl-orchestrate@archyl-marketplace
```

Restart Claude Code after installation.

**Step 3: Configure MCP Server**

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

Get your API key from the Archyl dashboard under **Settings > API Keys**.

## Quick Setup — Agent Integration

Run the setup script to add architecture context references to your project:

```bash
curl -fsSL https://raw.githubusercontent.com/archyl-com/agent-skills/main/templates/setup.sh | bash
```

This will:
- Add an `@archyl.txt` reference to your `CLAUDE.md` (or create one)
- Create an `AGENTS.md` with pre/post implementation checklists
- Append architecture context to `.cursorrules` if it exists

Or manually add to your `CLAUDE.md`:

```markdown
# Architecture

@archyl.txt

## Rules
- Before implementing any feature, run `/archyl-preflight` to validate your approach.
- After shipping a feature, run `/archyl-postship` to update architecture documentation.
```

## Agent Workflow

```
                 ┌──────────────────┐
                 │  archyl-preflight │  ← Agent validates approach
                 │  reads archyl.txt │    before writing code
                 └────────┬─────────┘
                          │
                          ▼
                 ┌──────────────────┐
                 │  Agent writes     │
                 │  code             │
                 └────────┬─────────┘
                          │
                          ▼
                 ┌──────────────────┐
                 │  CI pipeline      │  ← conformance-check action
                 │  validates PR     │    blocks architecture violations
                 └────────┬─────────┘
                          │
                          ▼
                 ┌──────────────────┐
                 │  archyl-postship  │  ← Agent updates C4 model,
                 │  updates docs     │    creates ADRs & Change Requests
                 └────────┬─────────┘
                          │
                          ▼
                 ┌──────────────────┐
                 │  generate-context │  ← CI regenerates archyl.txt
                 │  updates file     │    for the next agent
                 └──────────────────┘
```

## Skill Capabilities

### archyl-developer

The foundational skill with deep knowledge of Archyl's 200+ MCP tools:

| Domain | Capabilities |
|--------|-------------|
| **C4 Modeling** | Create and manage systems, containers, components, code elements, and relationships |
| **Documentation** | Architecture Decision Records, project docs, user/system flows, AI insights |
| **Governance** | Conformance rules, drift detection, DORA metrics, ownership mapping |
| **Operations** | Releases, environments, API contracts, event channels, technology radar |
| **Collaboration** | Comments, change requests, whiteboards, team management |
| **History** | Snapshots, time travel, architecture diffing, audit logs |
| **Integrations** | Webhooks, marketplace widgets, global architecture views |

### archyl-preflight

Pre-implementation validation that checks your planned approach against:

- **C4 model** — Are you modifying the right elements? Do the relationships make sense?
- **Conformance rules** — Does your approach respect dependency boundaries, tech constraints, and naming conventions?
- **Technology radar** — Are you using approved technologies?
- **API contracts** — Do existing contracts cover your planned usage?
- **Event channels** — Is async communication properly channeled?

Returns a **PASS** / **WARN** / **FAIL** verdict with actionable guidance.

### archyl-postship

Post-implementation documentation that automatically:

- Updates the **C4 model** with new services, components, and relationships
- Creates **ADRs** for architectural decisions made during implementation
- Files **Architecture Change Requests** for human architect review
- Updates **API contracts** and **event channels**
- Computes the **drift score** to verify documentation alignment improved

### archyl-changelog

Generates a structured architecture changelog combining:

- **Change history** — What elements were created, modified, or removed
- **ADR timeline** — Decisions proposed, accepted, deprecated
- **Release log** — Deployments and their architecture impact
- **Drift evolution** — How documentation alignment changed over time
- **Change Requests** — Who reviewed and approved architecture changes

Supports filtering by date range, element, team, or change type. Three output formats: timeline, summary, or detailed.

### archyl-review

Architecture review bot that analyzes code changes against the documented architecture:

- **Conformance check** — Runs rules against changed files, reports violations
- **Boundary analysis** — Detects service boundary crossings
- **Technology check** — Flags unapproved or deprecated technologies
- **API contract check** — Verifies contracts are up to date
- **Recommendations** — Actionable suggestions with severity levels (BLOCKER/WARNING/INFO)

### archyl-dora

Correlates DORA metrics with architecture health:

- **Timeline correlation** — Aligns DORA trends with drift scores, ADRs, and releases
- **Pattern detection** — Identifies how architecture changes impact delivery performance
- **Executive summary** — CTO-level findings with data
- **Detailed analysis** — Architect-level correlation reports
- **Trend reports** — Periodic architecture health tracking

### archyl-autofix

When drift is detected, proposes specific fixes:

- **Mode A (update docs)** — Code is truth, update the C4 model to match
- **Mode B (suggest code changes)** — Architecture is truth, suggest code realignment
- **Mode C (review needed)** — Intent unclear, flag for human decision
- **Safety-first** — Always creates Change Requests, never auto-deletes without confirmation
- **Drift verification** — Re-computes drift score after fixes to verify improvement

### archyl-roi

Quantifies the financial impact of architecture decisions through 4 lenses:

- **Developer productivity** — Lead time reduction x deploys = hours saved = dollars saved
- **Reliability** — Change failure rate reduction = incidents avoided x cost per incident
- **Architecture debt** — Drift cost, conformance violation rework, time-to-change overhead
- **Decision impact** — Per-ADR ROI tracking, before/after DORA comparison

Three output formats: Executive Report (CFO/CTO), Team Report (Eng Manager), Detailed Analysis (Architect).

### archyl-predict

Forecasts architecture risks before they materialize:

- **Drift trajectory** — Projects when drift will cross 30%/50%/70% thresholds
- **DORA trajectory** — Predicts tier changes (e.g., "Lead time trending toward Medium by June")
- **Conformance decay** — Identifies rules with declining compliance rates
- **Complexity hotspots** — Detects "god services" via fan-in/fan-out coupling metrics
- **Risk scoring** — Composite per-element risk score combining all dimensions

### archyl-orchestrate

Coordinates multiple AI agents working on the same architecture:

- **API contract negotiation** — Agents propose and agree on contracts via Archyl
- **Event channel coordination** — Detects duplicate events, ensures proper producer/consumer links
- **Dependency conflict resolution** — Identifies circular deps, boundary violations, proposes fixes
- **Cross-team changes** — Creates per-team Change Requests with scoped impact analysis

## Conformance Rule Packs

Pre-built rule sets for common architecture patterns. Install a pack to instantly enforce best practices:

| Pack | Rules | Description |
|------|-------|-------------|
| **[microservices](./rule-packs/microservices)** | 10 | No shared DBs, independent deployability, bounded communication |
| **[clean-architecture](./rule-packs/clean-architecture)** | 9 | Layer boundaries, domain isolation, port/adapter enforcement |
| **[event-driven](./rule-packs/event-driven)** | 8 | Channel compliance, schema requirements, dead letter queues |
| **[api-first](./rule-packs/api-first)** | 8 | Contract requirements, versioning, auth documentation |
| **[security-baseline](./rule-packs/security-baseline)** | 8 | Gateway enforcement, secret management, external access controls |

See [rule-packs/README.md](./rule-packs/README.md) for installation instructions.

## SDKs

Programmatic access to the Archyl API for custom integrations:

| SDK | Install | Language |
|-----|---------|----------|
| **[Node.js](./sdk/node)** | `npm install @archyl/sdk` | Node 18+, zero dependencies |
| **[Python](./sdk/python)** | `pip install archyl-sdk` | Python 3.10+, httpx |

```javascript
// Node.js
const { ArchylClient } = require('@archyl/sdk');
const archyl = new ArchylClient({ apiKey: 'arch_...', organizationId: 'uuid' });
const c4 = await archyl.projects.getC4Model(projectId);
const drift = await archyl.governance.computeDrift(projectId);
```

```python
# Python
from archyl import ArchylClient
client = ArchylClient(api_key="arch_...", organization_id="uuid")
c4 = client.projects.get_c4_model(project_id)
drift = client.governance.compute_drift(project_id)
```

See [sdk/README.md](./sdk/README.md) for full documentation.

## Templates

Ready-to-use templates for integrating Archyl into your agent configuration:

| Template | Purpose |
|----------|---------|
| [`CLAUDE.md.template`](./templates/CLAUDE.md.template) | Architecture section for Claude Code projects |
| [`.cursorrules.template`](./templates/.cursorrules.template) | Architecture context for Cursor |
| [`AGENTS.md.template`](./templates/AGENTS.md.template) | Agent instructions for any AI coding agent |
| [`setup.sh`](./templates/setup.sh) | One-line setup script |

## GitHub Actions

For CI/CD integration, see the companion [Archyl GitHub Actions](https://github.com/archyl-com/actions):

| Action | Description |
|--------|-------------|
| **conformance-check** | Block PRs that violate architecture rules |
| **drift-score** | Measure and enforce architecture drift thresholds |
| **generate-context** | Auto-generate `archyl.txt` for AI agents |
| **release** | Track deployments in Archyl |
| **auto-cr** | Auto-create Architecture Change Requests from merge diffs |
| **sync** | Sync `archyl.yaml` to Archyl |

## Other Coding Agents

The skill content is compatible with any agent that supports the plugin format. See the individual skill directories for direct installation.

## Requirements

- An [Archyl](https://archyl.com) account with API access
- Archyl MCP server (cloud or self-hosted)
- Claude Code, Codex, or compatible coding agent

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines on adding or improving skills.
