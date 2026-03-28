# Snapshots & Time Travel

## Overview

Archyl maintains versioned snapshots of your architecture. This enables time travel — viewing the architecture at any point in history and comparing changes between snapshots.

## Listing Snapshots

**Tool**: `list_versions`

```
Parameters:
- projectId (required): UUID
Returns:
- versions: Array of snapshots with timestamps and descriptions
```

## Viewing a Snapshot

**Tool**: `get_version`

```
Parameters:
- versionId (required): UUID
Returns:
- The complete architecture state at that point in time
```

## Comparing Snapshots

**Tool**: `diff_version`

```
Parameters:
- fromVersionId (required): UUID of the older snapshot
- toVersionId (required): UUID of the newer snapshot
Returns:
- added: Elements/relationships added between snapshots
- removed: Elements/relationships removed
- modified: Elements/relationships that changed
```

## History (Audit Log)

**Tool**: `list_history`

```
Parameters:
- projectId (required): UUID
Returns:
- entries: Chronological list of all changes (who, what, when)
```

## Use Cases

### Architecture Review
```
1. list_versions → find last month's snapshot
2. diff_version(lastMonth, current) → see what changed
3. Review changes in architecture meeting
```

### Incident Investigation
```
1. list_history → find changes around incident time
2. get_version(preIncident) → see architecture before the change
3. diff_version(preIncident, postIncident) → identify the architecture change that caused the issue
```

### Rollback Planning
```
1. get_version(knownGoodState) → see what the architecture looked like when things worked
2. diff_version(knownGood, current) → see everything that changed
3. Plan rollback based on the diff
```

## Best Practices

1. **Review diffs before major changes**: Use `diff_version` as a pre-check
2. **Use history for accountability**: `list_history` shows who changed what
3. **Snapshot before big operations**: Take note of the current state before refactoring the model
