# E-commerce Conversion Funnel & Opportunity Analysis

An end-to-end product analytics project diagnosing where and why an e-commerce
platform loses customers in the purchase journey — and which product categories
offer the greatest opportunity for improvement.

**[View Interactive Dashboard on Tableau Public →](https://public.tableau.com/app/profile/divyanshu.pal7246/viz/Ecommerce_Conversion_Analytics_twbx/ExecutiveSummary)**
---

## Business Problem

An e-commerce platform generates significant traffic but converts only a
fraction of it into purchases. Before recommending any fix, this project set
out to answer three questions in order:

1. **Where** in the customer journey are the biggest drop-offs?
2. **Why** do some sessions convert and others don't?
3. **Which** product categories should be prioritized for intervention, and
   what's the realistic upside?

## Dataset

Built on real e-commerce clickstream data (~2.75M events: views, cart-adds,
purchases) spanning 4.5 months, with a persistent visitor ID, item metadata,
and a category hierarchy.

The raw data ships as flat event logs with **no session identifier and no
pre-built relational structure** — a deliberate choice over more common
portfolio datasets, since it required building the analytical schema from
scratch rather than working from a table someone else had already normalized.

## Methodology

**1. Data Validation** — confirmed metadata coverage (78% of items, 99.85%
of events), category hierarchy completeness (98% of categories have a
parent), and that the expected View→Cart→Purchase funnel actually holds for
the majority of transactions (80.3%) before trusting the dataset further.

**2. Sessionization** — no session field exists in the raw data. Sessions
were engineered from timestamp gaps, testing 30/45/60-minute inactivity
thresholds against real session metrics before selecting the standard
30-minute cutoff.

**3. Funnel Analysis** — quantified conversion at every stage, revealing
that the dominant bottleneck is **View→Cart (2.5%)**, not cart abandonment
(72.8%) — cart abandonment affects a much smaller, already-engaged pool of
sessions than the earlier browse-to-cart drop-off.

**4. Behavioral Analysis** — engineered session-level features (duration,
unique items viewed, focus ratio, post-cart browsing) to compare converting
vs. non-converting sessions, testing and rejecting weaker hypotheses (raw
repeat-view counts showed no discriminating power) alongside stronger ones.

**5. Category Opportunity Ranking** — built a custom prioritization metric,
*Opportunity Carts*, benchmarked against the median performance of proven
high-traffic categories rather than a raw average, to avoid outlier skew.

**6. Dashboarding** — three linked Tableau dashboards following a
what → why → so-what structure: Executive Summary, Behavioral Drivers, and
Category Opportunity.

## Key Findings

- **71% of visitors generate only a single event** and never meaningfully
  engage — the addressable population for behavioral optimization is a
  minority of traffic, not the average visitor.
- **The primary bottleneck is View→Cart, not checkout.** Only 2.5% of
  sessions that view a product ever add it to cart — a far larger leak than
  cart abandonment, which is high (72.8%) but affects a much smaller pool.
- **Product exploration is the strongest behavioral predictor of purchase**:
  purchase rate rises from 0.5% (1 product viewed) to 31.7% (16+ products).
- **Focus Ratio shows a counterintuitive, U-shaped pattern**: sessions with
  very narrow, single-item focus convert *worse* than sessions with broader
  browsing — suggesting narrow fixation may signal hesitation, not
  commitment.
- **Category opportunity is spread across many categories rather than
  concentrated in a few**: reaching 50% of total addressable opportunity
  requires 37 categories, 80% requires 102 — meaning prioritization should
  work through a ranked list rather than assume a handful of fixes will
  capture most of the value.

## Dashboard Walkthrough

### 1. Executive Summary
![Executive Summary](dashboard/images/Executive%20Summary.png)

KPIs, funnel visualization, and headline finding at a glance.

### 2. Behavioral Drivers of Conversion
![Behavioral Insights](dashboard/images/Behavioral%20Insights.png)

What separates converting sessions from non-converting ones, and why.

### 3. Product Category Performance
![Category Performance](dashboard/images/Product%20Category%20Performance.png)

Category-level opportunity ranking, benchmark methodology, and the
business recommendation.

## Recommendation

Prioritize categories by their Opportunity Carts ranking, working down the
list according to available business resources — since opportunity is
distributed across many categories rather than concentrated in a handful,
no small set of fixes captures most of the value. Behavioral findings
suggest interventions should target **product discovery and pre-cart
hesitation** (comparison tools, richer product information, trust signals)
rather than checkout optimization, since the data shows the browse-to-cart
stage, not cart abandonment, is the dominant constraint.

## Repository Structure

\`\`\`
ecommerce-conversion-analytics/
│
├── README.md
├── sql/
│   ├── 01_data_preparation/       — cleaning, sessionization, base tables
│   ├── 02_feature_engineering/    — behavioral & category KPI tables
│   └── 03_dashboard_tables/       — final aggregated tables feeding Tableau
├── dashboard/
│   ├── Ecommerce_Conversion_Analytics.twbx
│   └── images/
│       ├── Executive Summary.png
│       ├── Behavioral Insights.png
│       └── Product Category Performance.png
\`\`\`

## Tools & Skills

**PostgreSQL** — schema design from raw, unstructured event logs; CTEs and
window functions for sessionization; KPI engineering; custom benchmark and
opportunity-scoring logic

**Tableau** — multi-dashboard design following a what → why → so-what
narrative structure; benchmark methodology made transparent on-dashboard
rather than buried in documentation

**Analytical approach** — hypothesis-driven testing, including hypotheses
that were tested and explicitly rejected (raw repeat-view counts showed no
discriminating power); business-first prioritization framework design;
honest scoping of associative vs. causal claims throughout


## Known Limitations

- The underlying dataset does not include price or revenue data, so
  opportunity is measured in **additional carts**, not revenue impact.
  This was a deliberate trade-off: the dataset's persistent visitor ID
  enabled genuine behavioral and longitudinal analysis that a
  revenue-inclusive alternative dataset could not support.
- The 30-minute session inactivity threshold, while validated against
  this dataset's own session-length and event-density patterns (tested
  against 45- and 60-minute alternatives), remains a judgment call rather
  than a ground truth — no session boundary is directly observable in
  raw clickstream data.
- Product-level drill-down within individual categories was deliberately
  scoped out — the category-level opportunity ranking was treated as
  sufficient to answer the core prioritization question within the
  project's time budget.

 ## Author

**Divyanshu Pal** · [Tableau Public Profile](https://public.tableau.com/app/profile/divyanshu.pal7246)
