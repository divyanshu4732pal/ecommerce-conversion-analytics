# SQL Scripts

The SQL workflow is organized into three stages:

## 01_data_preparation
Transforms raw clickstream events into session-level tables.

Files:
- 01_create_events_sessionized.sql
- 02_create_sessions.sql
- 03_create_session_features.sql
- 04_create_session_funnel.sql

---

## 02_feature_engineering
Engineers business features used for behavioral analysis.

Files:
- 05_create_behavior_features.sql
- 06_create_cart_behavior_analysis.sql
- 07_create_post_cart_behavior.sql
- 08_create_category_kpis.sql
- 09_create_category_performance.sql

---

## 03_dashboard_tables
Creates summary tables that power the Tableau dashboard.

Files:
- 10_create_executive_summary.sql
- 11_create_funnel_summary.sql
- 12_create_focus_ratio_summary.sql
- 13_create_duration_summary.sql
- 14_create_unique_products_summary.sql
- 15_create_opportunity_coverage.sql
