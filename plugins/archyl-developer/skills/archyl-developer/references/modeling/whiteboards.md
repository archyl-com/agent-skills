# Whiteboards

## Overview

Whiteboards in Archyl provide freeform visual collaboration spaces for brainstorming, sketching architecture ideas, and discussing design options before committing changes to the formal C4 model. They complement the structured C4 diagrams with unstructured visual thinking.

## Creating a Whiteboard

**Tool**: `create_whiteboard`

```
Parameters:
- projectId (required): UUID
- name (required): Whiteboard name (e.g., "Migration Planning", "Q2 Architecture Review")
```

## Listing Whiteboards

**Tool**: `list_whiteboards`

```
Parameters:
- projectId (required): UUID
Returns:
- whiteboards: Array of whiteboard summaries with name, creation date, last modified
```

## Getting Whiteboard Content

**Tool**: `get_whiteboard`

```
Parameters:
- whiteboardId (required): UUID
Returns:
- Full whiteboard content including shapes, text, connections, and embedded elements
```

## Deleting a Whiteboard

**Tool**: `delete_whiteboard`

```
Parameters:
- whiteboardId (required): UUID
```

## Use Cases

### Architecture Brainstorming
Before making formal changes to the C4 model, sketch ideas on a whiteboard:
```
1. create_whiteboard: "Service Decomposition Options"
2. Sketch different decomposition strategies
3. Discuss with team via comments
4. Once decided, create formal C4 elements
```

### Architecture Review Sessions
Prepare visual materials for review meetings:
```
1. create_whiteboard: "Q2 Architecture Review"
2. Annotate current architecture with proposed changes
3. Capture feedback during the meeting
```

### Onboarding New Engineers
Create visual walkthroughs that complement the formal model:
```
1. create_whiteboard: "System Overview for New Engineers"
2. Annotate with callouts, context, and "start here" guidance
```

## Best Practices

1. **Whiteboards are temporary**: Move finalized decisions into the C4 model and ADRs
2. **Name descriptively**: Include purpose and date (e.g., "Migration Options - March 2026")
3. **Clean up regularly**: Delete whiteboards that have served their purpose
4. **Link to ADRs**: When a whiteboard discussion leads to a decision, create an ADR referencing it
