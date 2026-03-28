# API Contracts

## Overview

API contracts in Archyl document the interfaces between services. They support multiple formats (OpenAPI, gRPC/Protobuf, GraphQL, AsyncAPI) and can be linked to C4 elements to show which containers expose or consume which APIs.

## Creating an API Contract

**Tool**: `create_api_contract`

```
Parameters:
- projectId (required): UUID
- name (required): Contract name (e.g., "Order API", "Payment Events Schema")
- format: "openapi", "grpc", "graphql", "asyncapi"
- version: API version (e.g., "3.1.0")
- content: The contract content (OpenAPI spec, proto definition, etc.)
- description: What this API does
```

## Linking to Architecture

**Tool**: `link_api_contract`

```
Parameters:
- contractId (required): UUID
- elementId (required): UUID of the C4 element
- elementType (required): C4 level (typically 2 for containers)
- role: "provider" or "consumer"
```

**Tool**: `unlink_api_contract`

```
Parameters:
- contractId (required): UUID
- elementId (required): UUID
```

## Querying Contracts

- `list_api_contracts(projectId)` — All contracts in a project
- `get_api_contract(contractId)` — Full contract details with spec
- `list_api_contracts_by_element(elementId, elementType)` — Contracts for a specific element

## Usage Patterns

### REST Service
```
1. create_api_contract: "User API" (format: "openapi", content: <spec>)
2. link_api_contract: → UserService container (role: "provider")
3. link_api_contract: → Frontend container (role: "consumer")
```

### Event-Driven Service
```
1. create_api_contract: "Order Events" (format: "asyncapi", content: <spec>)
2. link_api_contract: → OrderService (role: "provider")
3. link_api_contract: → NotificationService (role: "consumer")
```

### gRPC Service
```
1. create_api_contract: "Payment Proto" (format: "grpc", content: <proto>)
2. link_api_contract: → PaymentService (role: "provider")
3. link_api_contract: → OrderService (role: "consumer")
```

## Best Practices

1. **Contract per service boundary**: Each service exposing an API should have a contract
2. **Track providers AND consumers**: This reveals coupling between services
3. **Version contracts**: Use the version field to track API evolution
4. **Use with conformance rules**: Create `contract_compliance` rules to require contracts on all public services
