# MCP Server Connection & Protocol

## Connection Setup

Archyl exposes an MCP server over HTTP. To connect, add this to your `.mcp.json`:

```json
{
  "mcpServers": {
    "archyl": {
      "type": "http",
      "url": "http://localhost:8081/mcp",
      "headers": {
        "X-API-Key": "your-api-key-here"
      }
    }
  }
}
```

For cloud-hosted Archyl:

```json
{
  "mcpServers": {
    "archyl": {
      "type": "http",
      "url": "https://your-instance.archyl.com/mcp",
      "headers": {
        "X-API-Key": "arch_xxxxxxxxxxxx"
      }
    }
  }
}
```

## Authentication Methods

### API Key (Recommended for MCP)
- Header: `X-API-Key: arch_xxxxxxxxxxxx`
- Query parameter: `?apiKey=arch_xxxxxxxxxxxx`
- Generated from Archyl dashboard under Settings → API Keys

### OAuth Bearer Token
- Header: `Authorization: Bearer <jwt-token>`
- Used when authenticated via GitHub/GitLab/Bitbucket OAuth

## Transport Protocols

The MCP server supports two transports:

### Streamable HTTP (Default)
- `POST /mcp` — Send JSON-RPC requests
- `DELETE /mcp` — Close session

### SSE (Server-Sent Events)
- `GET /mcp` — Open SSE stream for receiving responses
- `POST /mcp` — Send requests on the same session

## Session Management

- Sessions persist for 24 hours
- Sessions are cleaned up after 1 hour of inactivity
- Each MCP connection creates a session tied to the authenticated user and organization

## Tool Call Format

All MCP tools are called via JSON-RPC 2.0:

```json
{
  "jsonrpc": "2.0",
  "method": "tools/call",
  "params": {
    "name": "list_projects",
    "arguments": {}
  },
  "id": 1
}
```

## Response Format

Successful responses include:

```json
{
  "content": [
    {"type": "text", "text": "Success message"}
  ],
  "isError": false,
  "structuredContent": {
    "projects": [...],
    "total": 5
  }
}
```

Error responses:

```json
{
  "content": [
    {"type": "text", "text": "Error: project not found"}
  ],
  "isError": true
}
```

## Common Parameters

- **UUIDs**: All resource identifiers are UUID v4 strings
- **Pagination**: `page` (1-indexed), `pageSize` (default varies by endpoint)
- **Element Types**: `1` = System, `2` = Container, `3` = Component, `4` = Code
- **Timestamps**: ISO 8601 format

## Rate Limits

Rate limits depend on the subscription tier:
- **Free**: Standard rate limits
- **Business**: Higher limits
- **Scale**: Highest limits

## OAuth Endpoints (Advanced)

For building custom integrations:
- `GET /.well-known/oauth-authorization-server` — OAuth metadata
- `GET /.well-known/oauth-protected-resource` — Protected resource metadata
- `GET /oauth/authorize` — Authorization endpoint
- `POST /oauth/token` — Token endpoint
