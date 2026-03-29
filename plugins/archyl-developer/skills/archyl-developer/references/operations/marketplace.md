# Marketplace Integrations & Widgets

## Overview

Archyl's marketplace provides pre-built integrations and widgets that extend architecture documentation with data from external tools. Widgets can display CI/CD status, monitoring dashboards, dependency graphs, or any custom visualization alongside C4 elements.

## Browsing the Marketplace

### List Available Products
**Tool**: `list_marketplace_products`

```
Parameters:
- (optional filters by category, search terms)
Returns:
- products: Array of available integrations with descriptions and pricing
```

### Get Product Details
**Tool**: `get_marketplace_product`

```
Parameters:
- productId (required): UUID
Returns:
- Product details, configuration options, supported features
```

## Managing Connections

Connections link a marketplace product to your organization or project.

### Create a Connection
**Tool**: `create_marketplace_connection`

```
Parameters:
- productId (required): UUID of the marketplace product
- projectId or organizationId: Scope of the connection
- config: Product-specific configuration (API keys, endpoints, etc.)
```

### Other Operations
- `list_marketplace_connections` -- List active connections
- `get_marketplace_connection` -- Get connection details
- `update_marketplace_connection` -- Modify configuration
- `delete_marketplace_connection` -- Remove connection

## Widgets

Widgets are visual components that display data from marketplace connections directly on C4 elements or project dashboards.

### Creating a Widget
**Tool**: `create_marketplace_widget`

```
Parameters:
- connectionId (required): UUID of the marketplace connection
- name (required): Widget name
- type: Widget type (varies by product)
- config: Widget-specific configuration (filters, display options)
- elementId (optional): UUID of C4 element to attach to
- elementType (optional): C4 level
```

### Querying Widgets
- `list_marketplace_widgets` -- List all widgets
- `get_marketplace_widget` -- Get widget details
- `list_marketplace_widgets_by_element` -- Widgets attached to a specific element
- `update_marketplace_widget` -- Modify widget
- `delete_marketplace_widget` -- Remove widget

### Organization-Level Widgets
For widgets that apply across all projects:
- `create_organization_widget` -- Create an org-wide widget
- `list_organization_widgets` -- List org-wide widgets

## Use Cases

### CI/CD Pipeline Status
Attach a CI widget to a container to show its latest build/deploy status:
```
1. create_marketplace_connection: GitHub Actions integration
2. create_marketplace_widget: "Build Status" → attached to ApiServer container
```

### Monitoring Dashboard
Show service health alongside architecture:
```
1. create_marketplace_connection: Datadog integration
2. create_marketplace_widget: "Service Health" → attached to PaymentService container
```

### Dependency Scanning
Display vulnerability data from security scanners:
```
1. create_marketplace_connection: Snyk integration
2. create_marketplace_widget: "Vulnerabilities" → attached to system level
```

## Best Practices

1. **Attach widgets to the right level**: CI/CD widgets on containers, monitoring on systems
2. **Keep connections scoped**: Use project-level connections for project-specific tools, org-level for shared tools
3. **Review connections quarterly**: Remove unused integrations
4. **Use org widgets for standards**: Org-wide widgets enforce consistent observability
