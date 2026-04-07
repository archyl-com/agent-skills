# Contributing

Thanks for your interest in contributing to the Archyl Agent Skills!

## Repository Structure

```
agent-skills/
├── .claude-plugin/marketplace.json    # Marketplace index
├── plugins/archyl-developer/
│   ├── .claude-plugin/plugin.json     # Claude Code manifest
│   ├── .codex-plugin/plugin.json      # Codex manifest
│   └── skills/
│       ├── archyl-developer/          # Core architecture skill
│       │   ├── SKILL.md
│       │   └── references/            # 23 domain-specific reference files
│       ├── archyl-preflight/          # Pre-implementation validation
│       │   └── SKILL.md
│       ├── archyl-postship/           # Post-ship documentation
│       │   └── SKILL.md
│       └── archyl-changelog/          # Architecture changelog generation
│           └── SKILL.md
└── templates/                         # Agent integration templates
    ├── CLAUDE.md.template
    ├── .cursorrules.template
    ├── AGENTS.md.template
    └── setup.sh
```

## Where to Make Changes

### Skills

Each skill has its own directory under `plugins/archyl-developer/skills/`:

| Skill | File | Purpose |
|-------|------|---------|
| `archyl-developer` | `SKILL.md` + `references/` | Core architecture modeling and governance |
| `archyl-preflight` | `SKILL.md` | Pre-implementation architecture validation |
| `archyl-postship` | `SKILL.md` | Post-ship documentation updates |
| `archyl-changelog` | `SKILL.md` | Architecture changelog generation |

### Reference Files

Domain-specific reference files live under `archyl-developer/references/` organized by domain:

- `core/` — C4 model, architecture patterns, MCP connection, global architecture
- `modeling/` — Relationships, collaboration, whiteboards, change requests
- `documentation/` — ADRs, project docs, flows, insights
- `governance/` — Conformance rules, drift detection, DORA metrics, ownership
- `operations/` — Releases, API contracts, event channels, tech radar, webhooks, marketplace, snapshots

### Templates

Agent integration templates live under `templates/`. These are meant to be copied into user projects.

## Branching

The default branch is `main`. Please branch from `main` and open PRs against `main`.

## Making a PR

1. Fork or clone this repository
2. Create a feature branch from `main`
3. Make your changes
4. Open a PR targeting `main`

## What to Contribute

- Fix incorrect tool names, parameters, or descriptions
- Add coverage for new Archyl features
- Improve workflow examples
- Add new reference files for missing domains
- Add new skills for specific use cases
- Improve templates for other coding agents
- Fix typos and improve clarity

## Guidelines

- Keep SKILL.md files focused and scannable — detailed content goes in `references/`
- Tool names must match exactly what Archyl's MCP server exposes
- Include practical examples in reference files
- Test your changes against a running Archyl instance if possible
- When adding a new skill, add it to `marketplace.json`
- Use the same YAML frontmatter format for SKILL.md files

### SKILL.md Frontmatter

```yaml
---
name: skill-name
description: One-line description of the skill
version: 0.1.0
allowed-tools: mcp__archyl__*
---
```

### Adding a New Skill

1. Create a directory under `plugins/archyl-developer/skills/<skill-name>/`
2. Add a `SKILL.md` with the frontmatter above
3. Add the skill to `.claude-plugin/marketplace.json`
4. Update this CONTRIBUTING.md with the new skill
5. Update the main README.md

## Questions?

Open an issue on this repository.
