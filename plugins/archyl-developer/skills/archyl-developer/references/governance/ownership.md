# Ownership Mapping

## Overview

Archyl tracks ownership of C4 elements — which team or individual is responsible for each system, container, component, or code element. This enables clear accountability and helps answer "who owns this?" questions across the organization.

## Managing Element Ownership

### Add an Owner
**Tool**: `add_element_owner`

```
Parameters:
- elementId (required): UUID of the C4 element
- elementType (required): C4 level (1-4)
- ownerId (required): UUID of the user or team
- ownerType: "user" or "team"
```

### Remove an Owner
**Tool**: `remove_element_owner`

### Set All Owners at Once
**Tool**: `set_element_owners`

Replace all owners of an element in one call.

### Get Current Owners
**Tool**: `get_element_owners`

## Organization-Wide Ownership Map

**Tool**: `get_ownership_map`

Returns the complete ownership structure across the entire organization — every project, every element, and who owns what. This is a powerful tool for:

- **Org-wide visibility**: See which teams own which systems
- **Gap analysis**: Find elements with no owner
- **Load balancing**: See if some teams own too many elements
- **Incident routing**: Know who to contact when something breaks

## Ownership Patterns

### Team-Based Ownership
Assign systems and containers to teams:
```
add_element_owner(PaymentSystem, TeamPayments)
add_element_owner(ApiGateway, TeamPlatform)
add_element_owner(Frontend, TeamProduct)
```

### Individual Ownership for Components
Assign components to tech leads:
```
add_element_owner(AuthService, alice@company.com)
add_element_owner(BillingModule, bob@company.com)
```

### Shared Ownership
Some elements are owned by multiple teams:
```
add_element_owner(SharedLibrary, TeamPayments)
add_element_owner(SharedLibrary, TeamPlatform)
```

## Best Practices

1. **Every system must have an owner**: Use `get_ownership_map` to find orphans
2. **Prefer team ownership over individual**: People change teams; team ownership is more stable
3. **Review quarterly**: Ownership should be reviewed as teams restructure
4. **Link to conformance**: Create conformance rules that require ownership on all containers
