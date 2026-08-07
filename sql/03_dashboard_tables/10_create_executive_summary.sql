DROP TABLE IF EXISTS executive_summary;

CREATE TABLE executive_summary AS

SELECT

    COUNT(DISTINCT visitorid) AS total_visitors,

    COUNT(*) AS total_sessions,

    SUM(CASE WHEN views > 0 THEN 1 ELSE 0 END) AS viewed_sessions,

    SUM(CASE WHEN carts > 0 THEN 1 ELSE 0 END) AS cart_sessions,

    SUM(CASE WHEN purchases > 0 THEN 1 ELSE 0 END) AS purchased_sessions,

    ROUND(
        SUM(converted)::numeric / COUNT(*),
        4
    ) AS session_conversion_rate,

    ROUND(
        SUM(CASE WHEN carts > 0 THEN 1 ELSE 0 END)::numeric
        /
        NULLIF(SUM(CASE WHEN views > 0 THEN 1 ELSE 0 END),0),
        4
    ) AS view_to_cart_rate,

    ROUND(
        SUM(CASE WHEN purchases > 0 THEN 1 ELSE 0 END)::numeric
        /
        NULLIF(SUM(CASE WHEN carts > 0 THEN 1 ELSE 0 END),0),
        4
    ) AS cart_to_purchase_rate,

    (
        SELECT COUNT(*)
        FROM category_kpis
    ) AS categories_analyzed

FROM session_features;