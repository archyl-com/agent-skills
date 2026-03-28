# Project Documentation

## Overview

Archyl supports rich project documentation that lives alongside the architecture model. Documents can be organized into folders, linked to C4 elements, and versioned over time.

## Creating Documentation

**Tool**: `create_documentation`

```
Parameters:
- projectId (required): UUID
- title (required): Document title
- content: Markdown content
- type: Document type/category
```

## Organizing with Folders

Use folders to structure documentation by topic or audience:

```
1. create_documentation_folder(projectId, name: "Onboarding")
2. create_documentation_folder(projectId, name: "Runbooks")
3. create_documentation_folder(projectId, name: "API Guides")
4. create_documentation(projectId, title: "Getting Started", ...)
5. move_documentation(docId, folderId) → move into "Onboarding"
```

## Folder Operations

- `list_documentation_folders` — List all folders
- `create_documentation_folder` — Create a new folder
- `update_documentation_folder` — Rename or update folder
- `delete_documentation_folder` — Delete folder
- `move_documentation` — Move a doc into a folder
- `move_documentation_folder` — Nest folders

## Org-Level Documentation

For documentation that spans projects:
- `list_global_docs` — List org-wide docs
- `create_global_doc` — Create an org-level document

## Best Practices

1. **Organize by audience**: Separate developer docs from operational runbooks
2. **Link to architecture**: Reference C4 elements to connect docs to the living model
3. **Keep docs near the architecture**: Archyl docs stay in sync with the C4 model, unlike wiki pages
4. **Use folders**: Don't dump everything at the root level
