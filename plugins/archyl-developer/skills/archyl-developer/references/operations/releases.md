# Releases & Environments

## Overview

Archyl tracks the deployment lifecycle: environments represent deployment stages (dev, staging, production), and releases represent specific versions deployed to those environments. Together, they power DORA metrics and provide deployment history.

## Environments

### Creating Environments
**Tool**: `create_environment`

```
Parameters:
- projectId (required): UUID
- name (required): Environment name (e.g., "Development", "Staging", "Production")
- description: Environment details
- order: Sort order (1 = first in pipeline)
```

### Typical Pipeline Setup
```
1. create_environment: "Development" (order: 1)
2. create_environment: "Staging" (order: 2)
3. create_environment: "Production" (order: 3)
```

### Other Operations
- `list_environments` — List all environments
- `update_environment` — Modify environment
- `delete_environment` — Remove environment
- `reorder_environments` — Change pipeline order

## Releases

### Creating a Release
**Tool**: `create_release`

```
Parameters:
- projectId (required): UUID
- version (required): Semantic version (e.g., "2.1.0")
- description: Release notes / changelog
- environmentId: UUID of target environment
- status: "planned", "in_progress", "deployed", "failed", "rolled_back"
```

### Release Lifecycle
```
planned → in_progress → deployed
                      → failed → rolled_back
```

### Other Operations
- `list_releases(projectId)` — List releases with filters
- `get_release(releaseId)` — Get release details
- `update_release` — Update status, notes
- `delete_release` — Remove release record

## Best Practices

1. **Register every production deployment**: This feeds DORA metrics
2. **Use semantic versioning**: `major.minor.patch`
3. **Include release notes**: Document what changed in each release
4. **Track failures**: Recording failed deployments is critical for CFR and MTTR
5. **Automate via webhooks**: Set up `create_webhook_notification` to auto-register releases from CI/CD
