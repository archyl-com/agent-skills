# Collaboration Features

## Comments

Comments enable team discussion directly on architecture elements.

### Adding Comments
**Tool**: `create_comment`

```
Parameters:
- projectId (required): UUID
- elementId (optional): UUID of C4 element (for element-level comments)
- elementType (optional): C4 level
- content (required): Comment text (Markdown supported)
- parentId (optional): UUID of parent comment (for replies)
```

### Managing Comments
- `list_comments(projectId)` — All project comments
- `list_comments_by_element(elementId, elementType)` — Comments on a specific element
- `get_comment_count(elementId, elementType)` — Quick count
- `resolve_comment(commentId)` — Mark as resolved
- `unresolve_comment(commentId)` — Reopen
- `add_comment_reaction(commentId, reaction)` — Add emoji reaction
- `remove_comment_reaction(commentId, reaction)` — Remove reaction

## Architecture Change Requests

Change requests are like pull requests, but for architecture. They propose changes to the C4 model and go through a review process.

### Creating a Change Request
**Tool**: `create_request`

```
Parameters:
- projectId (required): UUID
- title (required): Request title
- description: What changes are proposed and why
- changes: Array of proposed modifications
```

### Review Workflow
```
1. create_request → propose changes
2. list_request_changes → see what's being changed
3. create_comment → discuss the proposal
4. list_request_reviews → check review status
5. update_request → approve/merge/close
```

## Whiteboards

Whiteboards provide freeform visual collaboration spaces.

- `create_whiteboard(projectId, name)` — Create a whiteboard
- `list_whiteboards(projectId)` — List whiteboards
- `get_whiteboard(whiteboardId)` — Get whiteboard content
- `delete_whiteboard(whiteboardId)` — Remove whiteboard

## Teams

- `list_teams` — List organization teams
- `get_team(teamId)` — Get team details
- `create_team(name, description)` — Create a team

## Best Practices

1. **Use comments for context**: When making architecture changes, leave comments explaining *why*
2. **Use change requests for significant changes**: Major architecture changes should go through review
3. **Resolve comments**: Don't let comment threads pile up unresolved
4. **Assign ownership**: Use element ownership to route discussions to the right people
