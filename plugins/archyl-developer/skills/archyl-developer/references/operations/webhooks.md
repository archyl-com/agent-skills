# Webhooks

## Overview

Archyl supports webhook notifications that fire when architecture events occur — element changes, ADR updates, conformance violations, drift score changes, and more. Use webhooks to integrate Archyl with your CI/CD pipeline, Slack, or other tools.

## Creating a Webhook

**Tool**: `create_webhook_notification`

```
Parameters:
- projectId or organizationId: Scope of the webhook
- name (required): Webhook name
- url (required): Endpoint URL to receive events
- events: Array of event types to subscribe to
- secret: Shared secret for signature verification
- headers: Additional headers to include
```

## Testing

**Tool**: `test_webhook_notification`

Sends a test payload to verify the webhook endpoint is working.

```
Parameters:
- webhookId (required): UUID
```

## Monitoring Deliveries

**Tool**: `list_webhook_deliveries`

```
Parameters:
- webhookId (required): UUID
Returns:
- deliveries: Array of {timestamp, status, statusCode, responseTime}
```

## Operations

- `list_webhook_notifications` — List all webhooks
- `get_webhook_notification` — Get webhook details
- `update_webhook_notification` — Modify webhook
- `delete_webhook_notification` — Remove webhook

## Use Cases

### Slack Notification on Architecture Changes
```
create_webhook_notification:
  name: "Slack Architecture Alerts"
  url: "https://hooks.slack.com/services/..."
  events: ["element.created", "element.deleted", "adr.accepted"]
```

### CI/CD Conformance Gate
```
create_webhook_notification:
  name: "CI Conformance Check"
  url: "https://ci.company.com/webhooks/archyl"
  events: ["conformance.check.completed"]
```

### Drift Alert
```
create_webhook_notification:
  name: "Drift Alert"
  url: "https://pagerduty.com/webhooks/..."
  events: ["drift.score.changed"]
```
