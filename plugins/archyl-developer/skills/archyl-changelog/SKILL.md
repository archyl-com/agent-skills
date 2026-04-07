---
name: archyl-changelog
description: Generate architecture changelogs. Combines change history, ADRs, releases, change requests, and drift scores into a structured markdown timeline for any time period, filterable by date, element, team, or change type.
version: 0.1.0
allowed-tools: mcp__archyl__*
---

# Archyl Architecture Changelog

You are an architecture changelog generator. You collect data from multiple Archyl sources -- change history, ADRs, releases, change requests, version diffs, and drift scores -- and produce a structured, readable changelog for a given time period.

## When to Use

Run this skill when:
- You need a summary of architecture changes over a period (sprint, quarter, release)
- Preparing for an architecture review meeting
- Auditing who changed what and why
- Tracking drift score evolution alongside architecture decisions
- Building release notes with architecture impact

## Available Data Sources

| Source | Tool | What it provides |
|--------|------|-----------------|
| Change history | `list_history(projectId, page, pageSize)` | Audit log of all modifications to the C4 model |
| Version snapshots | `list_versions(projectId)` | Point-in-time snapshots of the architecture |
| Version diff | `diff_version(projectId, fromVersionId, toVersionId)` | Element-level diff between two snapshots |
| ADRs | `list_adrs(projectId)` | Architecture Decision Records with status and dates |
| Releases | `list_releases(projectId)` | Deployment releases with metadata |
| DORA metrics | `get_dora_metrics(projectId)` | Deployment frequency, lead time, change failure rate, MTTR |
| Drift history | `get_drift_history(projectId)` | Drift score evolution over time |
| Change requests | `list_requests(projectId)` | Architecture Change Requests |
| CR changes | `list_request_changes(projectId, requestId)` | Detailed changes within a Change Request |

## Changelog Workflow

### Step 1: Identify the Project and Time Range

```
1. list_projects -> find the target project
2. Ask the user for: time range, filters (element, team, change type), output format
3. Default: last 30 days, no filters, timeline format
```

### Step 2: Collect Raw Data

Fetch all data sources in parallel where possible:

```
1. list_history(projectId) -> all recent changes (paginate if needed)
2. list_adrs(projectId) -> all ADRs
3. list_releases(projectId) -> all releases
4. list_requests(projectId) -> all Change Requests
5. get_drift_history(projectId) -> drift score trend
6. get_dora_metrics(projectId) -> current delivery metrics
```

### Step 3: Filter by Time Range

From the collected data, keep only entries within the requested time range. For each data source:
- **History entries**: filter by `createdAt` or `timestamp` field
- **ADRs**: filter by `createdAt` or `updatedAt` (include if status changed in range)
- **Releases**: filter by `createdAt` or release date
- **Change Requests**: filter by `createdAt` or `updatedAt`
- **Drift history**: filter data points within the range

### Step 4: Apply Additional Filters

If the user specified filters:
- **Element filter**: keep only changes that reference the specified element(s)
- **Team filter**: keep only changes made by members of the specified team
- **Change type filter**: keep only specific types (e.g., only `created`, only `deleted`, only relationship changes)

### Step 5: Enrich Change Requests

For each Change Request in the filtered set, fetch its detailed changes:

```
list_request_changes(projectId, requestId) -> element-level changes within the CR
```

### Step 6: Optionally Diff Versions

If version snapshots bracket the time range, use `diff_version` for a structural diff:

```
1. list_versions(projectId) -> find versions closest to start and end of range
2. diff_version(projectId, fromVersionId, toVersionId) -> structural delta
```

This provides a high-level "before and after" view of the architecture.

### Step 7: Assemble and Output

Combine all filtered data into the requested output format.

## Output Formats

### Format 1: Timeline (default)

Chronological view of all architecture events, grouped by date.

```markdown
# Architecture Changelog: [Project Name]
**Period**: 2026-03-01 to 2026-03-31
**Generated**: 2026-04-01

---

## 2026-03-28

### Architecture Changes
- **Created** container `NotificationService` (Go, gin) in system `EcommercePlatform`
  — by @alice (human)
- **Created** relationship `OrderService -> NotificationService` (calls, HTTPS/JSON)
  — by @alice (human)

### ADR Decisions
- **ADR-042**: "Use SendGrid for transactional email" — status changed: proposed -> accepted
  — by @bob (human)

### Releases
- **v2.4.0** released to `production`
  — contains: NotificationService, OrderService updates

---

## 2026-03-21

### Architecture Changes
- **Modified** container `PaymentService` — updated technology from "Go 1.21" to "Go 1.22"
  — by @ci-bot (AI agent)
- **Deleted** component `LegacyEmailAdapter` from `UserService`
  — by @alice (human)

### Change Requests
- **CR-018**: "Remove legacy email adapter" — status: merged
  - Removed component `LegacyEmailAdapter`
  - Removed relationship `UserService -> SMTPRelay`

---

## Drift Score Evolution
| Date | Score | Delta |
|------|-------|-------|
| 2026-03-01 | 72% | — |
| 2026-03-15 | 78% | +6% |
| 2026-03-31 | 89% | +11% |

## DORA Metrics (current)
- Deployment Frequency: 3.2/week (High)
- Lead Time: 2.1 days (Medium)
- Change Failure Rate: 4.8% (Elite)
- MTTR: 45 min (Elite)
```

### Format 2: Summary

Compact overview with counts and key highlights, suitable for status reports.

```markdown
# Architecture Changelog Summary: [Project Name]
**Period**: 2026-03-01 to 2026-03-31

## Overview
- **12** architecture changes (8 created, 2 modified, 2 deleted)
- **3** ADRs updated (1 accepted, 1 proposed, 1 deprecated)
- **2** releases shipped
- **1** Change Request merged
- **Drift score**: 72% -> 89% (+17%)

## Key Changes
1. Added NotificationService with SendGrid integration
2. Migrated PaymentService to Go 1.22
3. Removed legacy email adapter from UserService

## Top Contributors
| Actor | Changes | Type |
|-------|---------|------|
| @alice | 6 | human |
| @ci-bot | 4 | AI agent |
| @bob | 2 | human |

## ADR Highlights
- **ADR-042** (accepted): Use SendGrid for transactional email
- **ADR-043** (proposed): Migrate to event-driven order processing
- **ADR-038** (deprecated): Use SMTP relay for notifications
```

### Format 3: Detailed

Full details for each change, including diffs and CR contents. Best for architecture reviews.

```markdown
# Architecture Changelog (Detailed): [Project Name]
**Period**: 2026-03-01 to 2026-03-31

---

## Structural Diff (version snapshot)

**From**: v12 (2026-03-01) -> **To**: v15 (2026-03-31)

### Added
- Container: `NotificationService` (system: EcommercePlatform)
  - Technology: Go 1.22, gin 1.9
  - Components: EmailSender, PushSender
- Relationship: `OrderService -> NotificationService` (calls)
- Event Channel: `order.completed` (Kafka)

### Modified
- Container: `PaymentService`
  - Technology: Go 1.21 -> Go 1.22
- Relationship: `ApiGateway -> PaymentService`
  - Description updated: "Routes payment requests" -> "Routes payment and refund requests"

### Removed
- Component: `LegacyEmailAdapter` (was in: UserService)
- Relationship: `UserService -> SMTPRelay` (uses)

---

## Change Request Details

### CR-018: Remove legacy email adapter
**Status**: merged | **Author**: @alice | **Date**: 2026-03-21

**Changes**:
1. Deleted component `LegacyEmailAdapter` from `UserService`
2. Deleted relationship `UserService -> SMTPRelay`
3. Updated `UserService` description to remove email references

**Reason**: Replaced by NotificationService (see ADR-042)

---

## ADR Details

### ADR-042: Use SendGrid for transactional email
**Status**: proposed (2026-03-15) -> accepted (2026-03-28)
**Linked elements**: NotificationService, EmailSender

**Context**: Direct SMTP relay was unreliable for high-volume transactional emails...
**Decision**: Adopt SendGrid for all transactional email delivery...
**Consequences**: Vendor dependency on SendGrid. Fallback to SES planned for Q3.

---

## Full Change History

| Date | Action | Element | Actor | Type |
|------|--------|---------|-------|------|
| 2026-03-28 | created | NotificationService | @alice | human |
| 2026-03-28 | created | OrderService -> NotificationService | @alice | human |
| 2026-03-28 | updated | ADR-042 (accepted) | @bob | human |
| 2026-03-25 | created | order.completed channel | @alice | human |
| 2026-03-21 | deleted | LegacyEmailAdapter | @alice | human |
| 2026-03-21 | deleted | UserService -> SMTPRelay | @alice | human |
| 2026-03-21 | updated | PaymentService (Go 1.22) | @ci-bot | AI agent |

---

## Drift Score Evolution
| Date | Score | Delta | Notes |
|------|-------|-------|-------|
| 2026-03-01 | 72% | — | Pre-notification service |
| 2026-03-15 | 68% | -4% | New code deployed, docs not yet updated |
| 2026-03-22 | 78% | +10% | Post-ship documentation applied |
| 2026-03-31 | 89% | +11% | CR-018 merged, stale elements removed |

## DORA Metrics
| Metric | Value | Tier | Trend |
|--------|-------|------|-------|
| Deployment Frequency | 3.2/week | High | stable |
| Lead Time | 2.1 days | Medium | improving |
| Change Failure Rate | 4.8% | Elite | stable |
| MTTR | 45 min | Elite | improving |
```

## Examples

### Example 1: "Show me what changed in the architecture this month"

```
User: What architecture changes happened in March?

1. list_projects -> find project
2. list_history(projectId) -> get all changes
3. list_adrs(projectId) -> get ADRs
4. list_releases(projectId) -> get releases
5. list_requests(projectId) -> get CRs
6. get_drift_history(projectId) -> drift trend
7. get_dora_metrics(projectId) -> current DORA
8. Filter everything to March date range
9. Output in timeline format (default)
```

### Example 2: "Summarize architecture changes for the PaymentService"

```
User: What changed on PaymentService last quarter?

1. list_projects -> find project
2. Collect all data sources (history, ADRs, releases, CRs, drift)
3. Filter to last quarter date range
4. Filter to changes referencing PaymentService (by element name or ID)
5. For CRs touching PaymentService: list_request_changes to get details
6. Output in summary format
```

### Example 3: "Prepare a detailed changelog for architecture review"

```
User: I need a detailed changelog for our Q1 architecture review

1. list_projects -> find project
2. Collect all data sources
3. Filter to Q1 date range (Jan 1 - Mar 31)
4. list_versions(projectId) -> find snapshots at Q1 boundaries
5. diff_version(projectId, jan1VersionId, mar31VersionId) -> structural diff
6. For each CR: list_request_changes for full details
7. Output in detailed format with version diff, CR details, and ADR details
```

### Example 4: "What did the AI agents change?"

```
User: Show me all architecture changes made by AI agents this sprint

1. list_projects -> find project
2. list_history(projectId) -> get all changes
3. Filter to sprint date range
4. Filter to entries where actor type is "AI agent" or "bot"
5. Output in timeline format
```

## Error Handling

### No history found for the period
The project may be new or the date range may be too narrow. Suggest widening the range or checking if the project has any history at all with `list_history` without date filters.

### No versions available for diff
Version snapshots may not be enabled or no snapshots exist yet. Skip the version diff step and rely on the change history for the structural view.

### Large history (many pages)
Paginate through `list_history` using the `page` and `pageSize` parameters. Process each page, filtering by date range, and stop when entries fall outside the range.

### Mixed date formats
Normalize all dates to ISO 8601 (YYYY-MM-DD) in the output regardless of the format returned by the API.
