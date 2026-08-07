DROP TABLE IF EXISTS unique_products_summary;

CREATE TABLE unique_products_summary AS

SELECT
    CASE
        WHEN unique_products_viewed = 1 THEN '1 Product'
        WHEN unique_products_viewed = 2 THEN '2 Products'
        WHEN unique_products_viewed BETWEEN 3 AND 4 THEN '3–4 Products'
        WHEN unique_products_viewed BETWEEN 5 AND 7 THEN '5–7 Products'
        WHEN unique_products_viewed BETWEEN 8 AND 10 THEN '8–10 Products'
        WHEN unique_products_viewed BETWEEN 11 AND 15 THEN '11–15 Products'
        ELSE '16+ Products'
    END AS product_bucket,

    COUNT(*) AS sessions,

    COUNT(*) FILTER (WHERE sf.purchases > 0) AS purchased_sessions,

    ROUND(
        100.0 *
        COUNT(*) FILTER (WHERE sf.purchases > 0)
        / COUNT(*),
        2
    ) AS purchase_rate,

    ROUND(AVG(unique_products_viewed),2) AS avg_products_viewed

FROM behavior_features bf
JOIN session_funnel sf
USING (visitorid, session_id)

GROUP BY
    CASE
        WHEN unique_products_viewed = 1 THEN '1 Product'
        WHEN unique_products_viewed = 2 THEN '2 Products'
        WHEN unique_products_viewed BETWEEN 3 AND 4 THEN '3–4 Products'
        WHEN unique_products_viewed BETWEEN 5 AND 7 THEN '5–7 Products'
        WHEN unique_products_viewed BETWEEN 8 AND 10 THEN '8–10 Products'
        WHEN unique_products_viewed BETWEEN 11 AND 15 THEN '11–15 Products'
        ELSE '16+ Products'
    END

ORDER BY
    MIN(unique_products_viewed);