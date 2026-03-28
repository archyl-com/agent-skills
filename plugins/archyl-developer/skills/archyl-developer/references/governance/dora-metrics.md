# DORA Metrics

## What are DORA Metrics?

DORA (DevOps Research and Assessment) metrics are four key indicators of software delivery performance. Archyl tracks these metrics based on release data and incident tracking.

## The Four Metrics

| Metric | What It Measures | Elite | High | Medium | Low |
|--------|-----------------|-------|------|--------|-----|
| **Deployment Frequency (DF)** | How often you deploy to production | On-demand (multiple/day) | Daily to weekly | Weekly to monthly | Monthly+ |
| **Lead Time for Changes (LT)** | Time from commit to production | < 1 hour | 1 day - 1 week | 1 week - 1 month | 1 month+ |
| **Change Failure Rate (CFR)** | % of deployments causing failures | 0-5% | 5-10% | 10-15% | 15%+ |
| **Mean Time to Recovery (MTTR)** | Time to restore service after failure | < 1 hour | < 1 day | < 1 week | 1 week+ |

## Retrieving DORA Metrics

### Current Metrics
**Tool**: `get_dora_metrics`

```
Parameters:
- projectId (required): UUID
Returns:
- deploymentFrequency: Deploys per period
- leadTimeForChanges: Average lead time
- changeFailureRate: Failure percentage
- meanTimeToRecovery: Average recovery time
- classification: Performance tier for each metric
```

### Trends Over Time
**Tool**: `get_dora_trend`

```
Parameters:
- projectId (required): UUID
- granularity: "day", "week", or "month"
Returns:
- trends: Array of {period, DF, LT, CFR, MTTR} entries
```

## Powering DORA Metrics

DORA metrics are computed from:
1. **Releases**: Created via `create_release` — each release represents a deployment
2. **Environments**: Tracked via `create_environment` — metrics focus on production
3. **Incidents**: Tracked through release metadata — failures and recovery times

## Best Practices

1. **Create releases consistently**: Every production deployment should be registered
2. **Track environments**: Set up your deployment pipeline stages
3. **Review weekly**: Use `get_dora_trend` with `week` granularity
4. **Set targets**: Pick one metric to improve each quarter
5. **Correlate with architecture changes**: When metrics improve/degrade, check what architectural changes coincided
