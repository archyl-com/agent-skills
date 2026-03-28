# Architecture Insights

## Overview

Archyl generates AI-powered insights about your architecture — recommendations, warnings, and observations based on the C4 model, relationships, and patterns detected in your system.

## Viewing Insights

**Tool**: `list_insights`

```
Parameters:
- projectId (required): UUID
```

Returns a list of AI-generated recommendations. Each insight has:
- Title and description
- Severity/priority
- Affected C4 elements
- Suggested actions

## Managing Insights

- `get_insight(insightId)` — Get full insight details
- `silence_insight(insightId)` — Dismiss an insight you've reviewed and decided not to act on

## Types of Insights

Archyl may surface insights such as:

- **Missing relationships**: "Container X has no documented dependencies"
- **Circular dependencies**: "Detected circular dependency between A → B → C → A"
- **Orphaned elements**: "Component Y is not connected to any other element"
- **Technology concerns**: "Database Z uses a deprecated technology"
- **Complexity warnings**: "System W has 50+ containers — consider decomposing"
- **Documentation gaps**: "No ADRs linked to critical system X"

## Best Practices

1. **Review insights regularly**: They surface issues you might miss in day-to-day work
2. **Don't silence blindly**: Each insight represents a potential architectural risk
3. **Act or acknowledge**: Either fix the issue or silence with a documented reason
4. **Use as review input**: Insights are excellent agenda items for architecture review meetings
