# Architecture Change Requests

## Overview

Architecture change requests are the review process for architecture modifications -- like pull requests, but for the C4 model. They allow teams to propose, discuss, and approve changes before they are committed to the architecture.

## Creating a Change Request

**Tool**: `create_request`

```
Parameters:
- projectId (required): UUID
- title (required): Short description of the proposed change
- description: Detailed explanation of what changes are proposed and why
- changes: Array of proposed modifications to C4 elements or relationships
```

## Reviewing Changes

### List Changes in a Request
**Tool**: `list_request_changes`

```
Parameters:
- requestId (required): UUID
Returns:
- changes: Array of proposed modifications (additions, updates, removals)
```

### List Reviews
**Tool**: `list_request_reviews`

```
Parameters:
- requestId (required): UUID
Returns:
- reviews: Array of review statuses and comments from reviewers
```

## Querying Change Requests

- `list_requests(projectId)` -- List all change requests for a project
- `get_request(requestId)` -- Get full request details

## Updating a Request

**Tool**: `update_request`

```
Parameters:
- requestId (required): UUID
- status: Update status (e.g., approve, merge, close)
- description: Updated description
```

## Workflow: Architecture Change Review

### Standard Review Process
```
1. create_request: "Add caching layer to Order Service"
   - description: "Proposal to add Redis cache between API and database..."
2. list_request_changes → review what is being changed
3. create_comment → team members discuss the proposal
4. list_request_reviews → check review status
5. update_request(status: "approved") → approve the change
6. Apply changes to the C4 model
```

### Quick Change (Minor Updates)
```
1. create_request: "Update OrderService technology to Go 1.22"
2. Review and approve immediately
3. update_container → apply the change
```

### Breaking Change (Requires Discussion)
```
1. create_request: "Decompose MonolithService into microservices"
2. Link to ADR: "ADR-042: Migrate to Microservices"
3. Multiple rounds of review and discussion
4. Final approval from architecture review board
5. Phased implementation with milestones
```

## Integration with Other Features

### With ADRs
When a change request represents a significant architectural decision:
```
1. create_adr: Document the decision rationale
2. create_request: Propose the specific changes
3. Link the change request description to the ADR
```

### With Conformance Rules
Before approving a change request:
```
1. Check if proposed changes violate any conformance rules
2. run_conformance_check → verify compliance
3. Only approve if conformance passes (or rule exceptions are documented)
```

### With Comments
```
1. create_comment on the change request → discussion
2. create_comment on specific C4 elements affected → element-level feedback
3. resolve_comment → mark addressed feedback
```

## Best Practices

1. **Use change requests for significant changes**: Not every minor update needs a review
2. **Include rationale**: The description should explain *why*, not just *what*
3. **Link to ADRs**: Significant changes should have a corresponding ADR
4. **Check conformance**: Run conformance checks before approving
5. **Keep requests focused**: One logical change per request, not a grab-bag of updates
6. **Resolve all comments**: Ensure discussion is addressed before merging
