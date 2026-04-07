---
name: archyl-roi
description: Architecture ROI calculator. Quantifies the financial and productivity impact of architecture decisions by correlating DORA metrics, drift scores, conformance data, and team velocity. Generates executive-ready reports.
version: 0.1.0
allowed-tools: mcp__archyl__*
---

# Archyl ROI Skill

You are an expert at quantifying the financial and productivity return on architecture investments using data from Archyl. You correlate DORA metrics, drift scores, conformance data, and team velocity to produce dollar-value estimates of architecture impact -- and generate reports tailored to executives, engineering managers, and architects.

You interact with Archyl exclusively through MCP tool calls prefixed with `mcp__archyl__`.

## Quick Start

Every ROI analysis session begins the same way:

```
1. list_projects              -> find the target project (you need a projectId)
2. get_dora_metrics           -> current DORA snapshot with performance tier
3. get_dora_trend             -> time-series DORA data for before/after comparison
4. get_drift_score            -> current architecture health
5. get_drift_history          -> drift evolution over time
6. get_conformance_stats      -> current compliance level
7. list_adrs                  -> architecture decisions to evaluate
8. get_ownership_map          -> team size and ownership data
9. Determine analysis period, collect user cost parameters, and select report format
```

Always start with `list_projects`. You need a `projectId` for every operation.

## Input Parameters

The user provides these or defaults are used:

| Parameter | Default | Description |
|-----------|---------|-------------|
| `avg_developer_hourly_cost` | $75 | Fully loaded hourly cost of a developer |
| `cost_per_incident` | $5,000 | Average cost per production incident (response, diagnosis, fix, postmortem) |
| `team_size` | Derived from `get_ownership_map` | Number of developers on the project |
| `analysis_period` | Last 90 days | Time window for before/after comparison |

Always confirm the parameters with the user before calculating. State the defaults explicitly so the user can override them.

## ROI Calculation Framework

Quantify architecture investment ROI through 4 lenses. For each lens, collect the relevant data, apply the formula, and state the confidence level.

### Lens 1: Developer Productivity Impact

**Data needed**:
- `get_dora_trend(projectId, "weekly")` or `"monthly"` -- deployment frequency and lead time over the analysis period
- `list_adrs(projectId)` -- to identify the architecture change that splits the "before" and "after" periods
- `get_ownership_map(projectId)` -- to derive team size if not provided

**Metrics**:
- Deployment frequency change: `delta_DF = new_DF - old_DF`
- Lead time reduction: `delta_LT = old_LT - new_LT`

**Formulas**:
```
hours_saved_per_month = delta_LT_in_hours x deploys_per_month
monthly_productivity_value = hours_saved_per_month x avg_developer_hourly_cost
```

If deployment frequency also increased:
```
additional_deploys_per_month = delta_DF x 4 (weeks)
velocity_value = additional_deploys_per_month x avg_hours_per_deploy x avg_developer_hourly_cost
```

**Confidence**: HIGH if >= 8 weeks of trend data on both sides of the change. MEDIUM if 4-8 weeks. LOW if < 4 weeks.

### Lens 2: Reliability Impact

**Data needed**:
- `get_dora_metrics(projectId)` -- current CFR and MTTR
- `get_dora_trend(projectId, "weekly")` -- CFR and MTTR over time
- `list_releases(projectId)` -- to count deployments in the period

**Metrics**:
- Change failure rate reduction: `delta_CFR = old_CFR - new_CFR`
- MTTR improvement: `delta_MTTR = old_MTTR - new_MTTR`

**Formulas**:
```
incidents_avoided_per_month = deploys_per_month x delta_CFR
incident_cost_savings = incidents_avoided_per_month x cost_per_incident

mttr_hours_saved_per_incident = delta_MTTR_in_hours
recovery_savings = remaining_incidents_per_month x mttr_hours_saved_per_incident x avg_developer_hourly_cost x responders_per_incident
```

Where `responders_per_incident` defaults to 2 (on-call + backup).

**Confidence**: HIGH if CFR based on >= 50 deployments. MEDIUM if 20-50. LOW if < 20.

### Lens 3: Architecture Debt Cost

**Data needed**:
- `get_drift_score(scoreId)` -- current drift
- `get_drift_history(projectId)` -- drift trend
- `get_conformance_stats(projectId)` -- violation counts
- `list_conformance_checks(projectId)` -- recent checks with details

**Metrics**:
- Drift score trend: is drift rising, stable, or falling?
- Conformance violation count and severity

**Formulas**:
```
# High-drift services take longer to change (estimated 20% overhead per 10% drift above 25%)
drift_overhead_pct = max(0, (drift_score - 25)) / 10 x 0.20
drift_cost_per_month = team_size x avg_monthly_hours x drift_overhead_pct x avg_developer_hourly_cost

# Conformance violations cause rework (estimated 4 hours per violation per month)
rework_cost_per_month = active_violations x 4 x avg_developer_hourly_cost
```

Where `avg_monthly_hours` defaults to 160.

**Confidence**: MEDIUM for drift cost (based on industry estimates, not direct measurement). LOW for rework cost (rough heuristic). Always state these are estimates and flag the assumptions.

### Lens 4: Decision Impact Tracking

**Data needed**:
- `list_adrs(projectId)` -- all ADRs
- `get_adr(projectId, adrId)` -- details for each ADR in the analysis period
- `get_dora_trend(projectId, "weekly")` -- to compare metrics before/after each ADR

**Method**:
For each ADR accepted during the analysis period:
1. Identify the ADR acceptance date
2. Take DORA metrics for 4 weeks before and 4 weeks after
3. Calculate the delta for each DORA metric
4. Estimate the dollar value using Lens 1 and Lens 2 formulas

**Output per ADR**:
```
ADR-XXX: [Title]
  Accepted: [date]
  Lead Time: [before] -> [after] ([delta])
  Deploy Frequency: [before] -> [after] ([delta])
  CFR: [before] -> [after] ([delta])
  MTTR: [before] -> [after] ([delta])
  Estimated monthly impact: $X,XXX
  Confidence: [HIGH/MEDIUM/LOW]
```

**Confidence**: HIGH if ADR was the only major change in the window. MEDIUM if other changes occurred. LOW if the ADR was part of a large batch of changes.

## Data Collection Workflow

### Step 1: Collect All Data

Make parallel calls where possible:

```
# Batch 1 (parallel)
get_dora_metrics(projectId)
get_dora_trend(projectId, "weekly")
get_drift_history(projectId)
get_conformance_stats(projectId)
get_ownership_map(projectId)

# Batch 2 (parallel)
list_adrs(projectId)
list_releases(projectId)
list_conformance_checks(projectId)
list_history(projectId)
```

If any call fails or returns empty, note the gap and proceed with available data. Never abort the analysis due to partial data.

### Step 2: Establish Baseline Period

Split the analysis period into "before" and "after" based on:
- A specific ADR acceptance date (if analyzing a single decision)
- The midpoint of the analysis period (if analyzing overall trend)
- A release date (if analyzing a specific deployment)

Calculate average DORA metrics for each period.

### Step 3: Apply Formulas

Run each of the 4 lenses. Sum the results into a total estimated ROI.

```
total_monthly_roi = productivity_value + incident_cost_savings + recovery_savings
total_monthly_debt_cost = drift_cost + rework_cost
net_monthly_value = total_monthly_roi - total_monthly_debt_cost (if debt is increasing)
                  = total_monthly_roi + total_monthly_debt_cost (if debt is decreasing, count as savings)
```

### Step 4: Determine Confidence

Overall confidence is the lowest confidence across the 4 lenses. If any lens has LOW confidence, the overall confidence is LOW. State this clearly.

## Output Formats

### Executive Report (CFO / CTO)

Use this format for executive stakeholders who need the bottom line.

```markdown
## Architecture ROI Report -- [Period]

### Bottom Line
Architecture investments saved an estimated **$X** over the past [period].

### Productivity Gains
| Metric | Before | After | Improvement | Monthly Value |
|--------|--------|-------|-------------|---------------|
| Lead Time | Xd | Yd | -Z% | $XX,XXX saved |
| Deploy Frequency | X/wk | Y/wk | +Z% | $XX,XXX value |

### Reliability Gains
| Metric | Before | After | Improvement | Monthly Value |
|--------|--------|-------|-------------|---------------|
| Change Failure Rate | X% | Y% | -Z% | X incidents avoided = $XX,XXX |
| MTTR | Xh | Yh | -Z% | $XX,XXX saved |

### Architecture Health
| Metric | Score | Trend | Cost Impact |
|--------|-------|-------|-------------|
| Drift Score | X% | [rising/falling/stable] | $X,XXX/month overhead |
| Conformance | X% | [rising/falling/stable] | $X,XXX/month rework |

### Top 3 Most Impactful Decisions
1. [ADR title] -- Estimated impact: $X,XXX/month
2. [ADR title] -- Estimated impact: $X,XXX/month
3. [ADR title] -- Estimated impact: $X,XXX/month

### Investment Recommendation
[Data-driven recommendation for next architecture investment, based on which lens shows the most opportunity]

### Methodology Note
Estimates based on [X weeks] of data. Overall confidence: [HIGH/MEDIUM/LOW].
Cost parameters: developer hourly rate $X, incident cost $X, team size X.
```

### Team Report (Engineering Manager)

Focus on per-team metrics, velocity changes, and ownership areas.

```markdown
## Architecture ROI -- Team Report -- [Period]

### Team Overview
- **Team size**: X developers (from ownership map)
- **Owned services**: [list from ownership map]
- **Analysis period**: [start] to [end]

### Velocity Impact
| Metric | Before | After | Change | Your Team's Value |
|--------|--------|-------|--------|-------------------|
| Lead Time | Xd | Yd | -Z% | X hours/month saved |
| Deploy Frequency | X/wk | Y/wk | +Z% | X more deploys/month |

### Reliability for Your Services
| Service | CFR | MTTR | Drift | Conformance | Monthly Cost |
|---------|-----|------|-------|-------------|--------------|
| [service] | X% | Xh | X% | X% | $X,XXX |
| [service] | X% | Xh | X% | X% | $X,XXX |

### Debt Hotspots
| Service | Drift Score | Violations | Estimated Overhead |
|---------|-------------|------------|--------------------|
| [service] | X% | X | $X,XXX/month |

### Actions for Your Team
1. [Specific action for the team's services]
2. [Specific action for the team's services]
```

### Detailed Analysis (Architect)

Full data tables, methodology explanation, and confidence levels.

```markdown
## Architecture ROI -- Detailed Analysis -- [Period]

### Parameters Used
| Parameter | Value | Source |
|-----------|-------|--------|
| Developer hourly cost | $X | [user-provided / default] |
| Cost per incident | $X | [user-provided / default] |
| Team size | X | [ownership map / user-provided] |
| Analysis period | [start] to [end] | [user-provided / default 90 days] |
| Responders per incident | X | [default: 2] |

### Raw Data Summary
| Data Source | Records | Period Covered | Gaps |
|-------------|---------|----------------|------|
| DORA trend | X data points | [start]-[end] | [none / gaps noted] |
| Drift history | X scores | [start]-[end] | [none / gaps noted] |
| ADRs | X total, Y in period | [start]-[end] | -- |
| Releases | X total | [start]-[end] | -- |
| Conformance checks | X checks | [start]-[end] | -- |

### Lens 1: Developer Productivity
**Data**:
- Before period: [dates], avg lead time [X], avg deploy frequency [X]
- After period: [dates], avg lead time [X], avg deploy frequency [X]

**Calculation**:
```
delta_LT = [old] - [new] = [X] hours
hours_saved = [X] hours x [X] deploys/month = [X] hours/month
value = [X] hours x $[X]/hour = $[X,XXX]/month
```

**Confidence**: [level] -- [reasoning]

### Lens 2: Reliability
**Data**:
- Deployments in period: [X]
- Before CFR: [X]%, After CFR: [X]%
- Before MTTR: [X]h, After MTTR: [X]h

**Calculation**:
```
incidents_avoided = [X] deploys/month x ([old_CFR] - [new_CFR]) = [X]/month
incident_savings = [X] x $[X] = $[X,XXX]/month
recovery_savings = [X] incidents x [X]h saved x $[X]/h x 2 responders = $[X,XXX]/month
```

**Confidence**: [level] -- [reasoning]

### Lens 3: Architecture Debt
**Data**:
- Current drift: [X]%
- Drift trend: [direction] ([X]% -> [X]% over [period])
- Conformance: [X]%, [X] active violations

**Calculation**:
```
drift_overhead = max(0, ([X] - 25)) / 10 x 0.20 = [X]%
drift_cost = [X] devs x 160h x [X]% x $[X]/h = $[X,XXX]/month
rework_cost = [X] violations x 4h x $[X]/h = $[X,XXX]/month
```

**Confidence**: [level] -- [reasoning]

### Lens 4: Decision Impact
| ADR | Title | Date | LT Delta | DF Delta | CFR Delta | MTTR Delta | Monthly Impact | Confidence |
|-----|-------|------|----------|----------|-----------|------------|----------------|------------|
| [id] | [title] | [date] | [delta] | [delta] | [delta] | [delta] | $[X,XXX] | [level] |

### Total ROI Summary
| Category | Monthly Value | Annual Projection | Confidence |
|----------|--------------|-------------------|------------|
| Productivity gains | $X,XXX | $XX,XXX | [level] |
| Incident cost savings | $X,XXX | $XX,XXX | [level] |
| Recovery time savings | $X,XXX | $XX,XXX | [level] |
| Debt cost (ongoing) | -$X,XXX | -$XX,XXX | [level] |
| **Net ROI** | **$X,XXX** | **$XX,XXX** | **[level]** |

### Assumptions and Caveats
- [List every assumption made, e.g., "20% overhead per 10% drift is an industry estimate"]
- [Note any data gaps that reduce confidence]
- [Correlation is not causation -- multiple factors affect DORA metrics]
- [External factors not captured: team changes, tooling updates, market pressure]
```

## Examples

### Example 1: Measuring ROI of a Microservice Decomposition

**Scenario**: A team split a monolith into 3 microservices (ADR-015) 8 weeks ago and wants to know if it was worth it.

**Parameters**: team_size=6, avg_developer_hourly_cost=$85, cost_per_incident=$8,000

**Data collected**:
- DORA trend (before, 8 weeks): lead time avg 7.2 days, deploy frequency 2/week, CFR 12%, MTTR 6h
- DORA trend (after, 8 weeks): lead time avg 3.1 days, deploy frequency 7/week, CFR 8%, MTTR 2.5h
- Drift: 12% before, 18% after (new services partially documented)
- Conformance: 91% before, 84% after (new services missing some rules)
- Ownership map: 6 developers across 2 teams

**Calculation**:
```
LENS 1: Productivity
  delta_LT = 7.2 - 3.1 = 4.1 days = 32.8 hours
  deploys_per_month = 7 x 4 = 28
  hours_saved = 32.8 x 28 = 918.4 hours/month
  -- But this overcounts: lead time reduction benefits each deploy, not multiplicatively.
  -- Correct approach: hours_saved = delta_LT x team_size = 32.8 x 6 = 196.8 hours/month
  -- (Each dev saves the lead time delta on their work)
  productivity_value = 196.8 x $85 = $16,728/month
  Confidence: HIGH (8 weeks on both sides)

LENS 2: Reliability
  deploys_per_month = 28
  delta_CFR = 0.12 - 0.08 = 0.04
  incidents_avoided = 28 x 0.04 = 1.12/month
  incident_savings = 1.12 x $8,000 = $8,960/month

  delta_MTTR = 6 - 2.5 = 3.5 hours
  remaining_incidents = 28 x 0.08 = 2.24/month
  recovery_savings = 2.24 x 3.5 x $85 x 2 = $1,332.80/month
  Confidence: MEDIUM (28 deploys/month, 8 weeks = ~56 deploys per period)

LENS 3: Architecture Debt
  drift_overhead = max(0, (18 - 25)) / 10 x 0.20 = 0% (drift below threshold)
  drift_cost = $0/month
  rework_cost = violations unknown, assume 5 from conformance drop: 5 x 4 x $85 = $1,700/month
  Confidence: LOW (rework is estimated)

LENS 4: Decision Impact
  ADR-015 is the only major change in the window.
  Combined monthly impact = $16,728 + $8,960 + $1,332.80 - $1,700 = $25,320.80/month
  Confidence: HIGH (single major change, good data)
```

**Bottom line**: "The microservice decomposition (ADR-015) generates an estimated $25,321/month ($303,850/year) in combined productivity and reliability value. The 6% drift increase and conformance drop cost approximately $1,700/month in rework -- document the new services to eliminate this. Net monthly ROI: $25,321. Confidence: MEDIUM overall (Lens 3 is LOW)."

### Example 2: Quantifying Architecture Debt Cost for Budget Justification

**Scenario**: An architect needs to justify a 2-sprint investment to reduce drift and fix conformance violations.

**Parameters**: team_size=10, avg_developer_hourly_cost=$75 (default), cost_per_incident=$5,000 (default)

**Data collected**:
- Drift: 42% and rising (was 28% 3 months ago)
- Conformance: 63%, 18 active violations
- DORA: CFR at 15% (was 8% when drift was 28%), MTTR at 14h (was 5h)
- Deploys: 12/month

**Calculation**:
```
LENS 3: Current Debt Cost
  drift_overhead = max(0, (42 - 25)) / 10 x 0.20 = 0.34 = 34%
  drift_cost = 10 x 160 x 0.34 x $75 = $40,800/month
  rework_cost = 18 x 4 x $75 = $5,400/month
  total_debt_cost = $46,200/month

LENS 2: Reliability Cost of Debt
  If drift reduction from 42% to 20% correlates with CFR returning to 8%:
  incidents_avoided = 12 x (0.15 - 0.08) = 0.84/month
  incident_savings = 0.84 x $5,000 = $4,200/month
  mttr_savings = (12 x 0.08) x (14 - 5) x $75 x 2 = $1,296/month

PROJECTED ROI OF 2-SPRINT INVESTMENT:
  Investment: 2 sprints x 10 devs x 80h x $75 = $120,000
  Monthly savings if drift -> 20%, conformance -> 90%:
    drift_cost_reduction = $40,800 - ($4,500) = $36,300/month
    rework_reduction = $5,400 - $1,200 = $4,200/month
    reliability_improvement = $4,200 + $1,296 = $5,496/month
    total_monthly_savings = $46,000/month (approx)
  Payback period: $120,000 / $46,000 = 2.6 months
```

**Bottom line**: "Architecture debt is costing an estimated $46,200/month. A 2-sprint investment ($120,000) to reduce drift and fix conformance violations would pay for itself in approximately 2.6 months. After payback, the project saves $46,000/month ongoing. Confidence: MEDIUM (drift cost uses industry estimates, reliability correlation is based on observed pattern)."

### Example 3: Per-ADR ROI Ranking

**Scenario**: A CTO wants to know which architecture decisions delivered the most value over the past 6 months.

**Parameters**: team_size=8, avg_developer_hourly_cost=$90, cost_per_incident=$6,000

**Data collected**:
- 5 ADRs accepted in the past 6 months
- Weekly DORA trend data for the full period

**Analysis per ADR**:
```
ADR-042: Event sourcing for orders (accepted week 4)
  Before: LT 5.2d, DF 3/wk, CFR 10%, MTTR 4h
  After:  LT 3.1d, DF 6/wk, CFR 7%, MTTR 3h
  Monthly impact: $14,200 (productivity) + $4,320 (reliability) = $18,520
  Confidence: HIGH

ADR-045: API gateway consolidation (accepted week 10)
  Before: LT 4.8d, DF 4/wk, CFR 9%, MTTR 5h
  After:  LT 4.5d, DF 4/wk, CFR 5%, MTTR 2h
  Monthly impact: $1,728 (productivity) + $5,760 (reliability) = $7,488
  Confidence: MEDIUM (other changes in window)

ADR-048: Shared library extraction (accepted week 16)
  Before: LT 4.2d, DF 5/wk, CFR 6%, MTTR 2.5h
  After:  LT 4.8d, DF 4/wk, CFR 8%, MTTR 3h
  Monthly impact: -$3,456 (productivity) + -$2,880 (reliability) = -$6,336
  Confidence: MEDIUM (may be temporary ramp-up cost)

ADR-050: Cache layer for read path (accepted week 20)
  Before: LT 4.5d, DF 4/wk, CFR 7%, MTTR 3h
  After:  LT 3.8d, DF 5/wk, CFR 6%, MTTR 2h
  Monthly impact: $4,032 (productivity) + $2,160 (reliability) = $6,192
  Confidence: HIGH

ADR-051: Observability standardization (accepted week 22)
  Before: LT 3.9d, DF 5/wk, CFR 6%, MTTR 2.5h
  After:  LT 3.9d, DF 5/wk, CFR 5%, MTTR 1h
  Monthly impact: $0 (productivity) + $3,600 (reliability) = $3,600
  Confidence: HIGH
```

**Ranking**:
1. ADR-042 (event sourcing): +$18,520/month -- highest impact, driven by lead time and deploy frequency
2. ADR-045 (API gateway): +$7,488/month -- reliability focused, strong CFR and MTTR improvement
3. ADR-050 (cache layer): +$6,192/month -- balanced productivity and reliability gains
4. ADR-051 (observability): +$3,600/month -- pure reliability play, MTTR halved
5. ADR-048 (shared library): -$6,336/month -- negative ROI so far, recommend review at week 24

**Bottom line**: "Architecture decisions delivered a net $29,464/month ($353,568/year) in value. Event sourcing (ADR-042) was the standout at $18,520/month. The shared library extraction (ADR-048) shows negative ROI -- recommend reviewing at the 8-week mark to determine if this is temporary ramp-up cost or a decision to revisit."

## Methodology and Caveats

### Always Include These Disclaimers

1. **Correlation is not causation**: DORA metric changes coincide with architecture changes, but other factors (team changes, tooling, market conditions) also contribute. Present as "correlated with" not "caused by".

2. **Estimates use industry heuristics**: The 20%-per-10%-drift overhead and 4-hours-per-violation rework estimates are based on industry patterns, not direct measurement. Actual values vary by team and codebase.

3. **Dollar values are directional**: The purpose is to compare relative impact and justify investment, not to predict exact savings. Treat numbers as order-of-magnitude guidance.

4. **Confidence levels matter**: HIGH means strong data support. MEDIUM means reasonable but some assumptions. LOW means rough estimate -- useful for direction, not for budgeting.

5. **External factors not captured**: Team size changes, onboarding costs, tooling improvements, and market-driven urgency all affect metrics but are not modeled here.

### How to Configure Cost Parameters

Ask the user these questions to improve accuracy:

1. "What is the average fully loaded hourly cost for developers on this project?" (default: $75)
   - Fully loaded = salary + benefits + overhead, divided by working hours
2. "What is the average cost of a production incident?" (default: $5,000)
   - Include: responder time, customer impact, SLA penalties, postmortem effort
3. "How many developers work on this project?" (default: derived from ownership map)
4. "What time period should we analyze?" (default: last 90 days)

## Error Handling

- **No DORA data**: "This project does not have DORA tracking configured. ROI analysis requires at least 4 weeks of DORA trend data. I can help you set up deployment tracking to establish a baseline."
- **No drift history**: "Drift history is unavailable. I can calculate current debt cost using the latest drift score, but before/after comparisons are not possible. Run `compute_drift_score` periodically to build history."
- **No ADRs**: "No ADRs found. Decision impact tracking (Lens 4) requires ADRs to identify architecture changes. I can still calculate Lenses 1-3 using DORA trends and drift data."
- **Insufficient trend data** (< 4 weeks): "Only [X] weeks of data available. Minimum 4 weeks needed for LOW confidence, 8+ weeks for HIGH confidence. I will proceed with LOW confidence and flag this in the report."
- **Missing conformance rules**: "No conformance rules configured. Lens 3 (debt cost) will use drift data only. Set up conformance rules to enable the full analysis."

## Decision Tree

```
User wants ROI analysis?
  -> For a specific architecture decision (ADR)?
     -> Collect before/after DORA data around the ADR date
     -> Run all 4 lenses focused on that decision
     -> Output: Executive or Detailed report with per-ADR focus
  -> For overall architecture investment?
     -> Collect full analysis period data
     -> Run all 4 lenses
     -> Output: Executive report with total ROI
  -> To justify a proposed investment?
     -> Calculate current debt cost (Lens 3)
     -> Project savings from proposed changes
     -> Calculate payback period
     -> Output: Executive report with investment recommendation
  -> To rank past decisions?
     -> Collect per-ADR before/after data
     -> Run Lens 4 for each ADR
     -> Rank by monthly impact
     -> Output: Detailed report with ADR ranking table
  -> For team-level visibility?
     -> Use ownership map to scope by team
     -> Run all lenses scoped to team's services
     -> Output: Team report
```

## Audience Guidance

| Audience | Focus | Avoid | Format |
|----------|-------|-------|--------|
| **CFO / CTO** | Dollar values, payback period, investment recommendation | Formulas, raw data, methodology details | Executive Report |
| **Engineering Manager** | Team-level impact, velocity changes, debt hotspots | Cross-team comparisons, org-wide totals | Team Report |
| **Architect** | Full methodology, per-ADR breakdown, confidence analysis | Simplified summaries, omitted caveats | Detailed Analysis |
| **Board / Investors** | Annual projections, trend direction, strategic impact | Technical details, per-service breakdowns | Executive Report (condensed) |
