# Architecture Drift Detection

## What is Drift?

Architecture drift is the divergence between your documented architecture (the C4 model in Archyl) and the actual state of the codebase. Over time, code changes accumulate without corresponding architecture updates, making the documentation unreliable.

Archyl quantifies this as a **drift score** (0-100%), where:
- **0%** = Perfect alignment — docs match reality
- **100%** = Complete divergence — docs are fiction

## Computing Drift

**Tool**: `compute_drift_score`

Triggers a fresh drift computation. This compares the C4 model against the actual codebase structure (via connected git repositories).

```
Parameters:
- projectId (required): UUID
```

This is an async operation — it triggers the computation and returns immediately. Check the result with `get_drift_score`.

## Reading Drift Results

### Overall Score
**Tool**: `get_drift_score`

```
Parameters:
- projectId (required): UUID
Returns:
- score: Overall drift percentage (0-100)
- lastComputed: When the score was last calculated
- breakdown: Summary by C4 level
```

### Per-Element Breakdown
**Tool**: `get_drift_details`

```
Parameters:
- projectId (required): UUID
Returns:
- elements: Array of elements with their individual drift scores
- Each element shows: what's documented vs what exists in code
```

### Historical Trends
**Tool**: `get_drift_history`

```
Parameters:
- projectId (required): UUID
Returns:
- history: Array of {timestamp, score} entries
- Shows how drift has changed over time
```

## Interpreting Drift

| Score | Interpretation | Action |
|-------|---------------|--------|
| 0-10% | Excellent — docs are current | Maintain current practices |
| 10-25% | Good — minor gaps | Schedule a doc refresh |
| 25-50% | Concerning — significant gaps | Prioritize doc updates |
| 50-75% | Poor — docs are unreliable | Major doc overhaul needed |
| 75-100% | Critical — docs are misleading | Re-discover architecture |

## Common Causes of Drift

1. **New services added** without updating the C4 model
2. **Services retired** but still documented
3. **Technology changes** (migrated from PostgreSQL to CockroachDB) without updating containers
4. **Refactored components** that split or merged without model updates
5. **Renamed elements** in code but not in architecture

## Workflow: Reducing Drift

```
1. compute_drift_score → trigger fresh computation
2. get_drift_score → check overall health
3. get_drift_details → find the worst offenders
4. Fix top drifted elements:
   - Update descriptions and technologies
   - Add missing elements
   - Remove stale elements
   - Fix relationship types
5. compute_drift_score → verify improvement
```

## Best Practices

1. **Check drift weekly**: Integrate `get_drift_score` into your team's architecture review cadence
2. **Set a target**: Aim for <15% drift and alert when it exceeds 25%
3. **Update docs with code**: When merging a PR that adds/removes/renames services, update Archyl in the same workflow
4. **Use drift details**: Don't just look at the number — `get_drift_details` tells you *where* the problems are
5. **Track trends**: `get_drift_history` shows whether you're improving or regressing
