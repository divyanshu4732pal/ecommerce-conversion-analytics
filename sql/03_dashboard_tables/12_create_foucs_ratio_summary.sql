DROP TABLE IF EXISTS focus_ratio_summary;

CREATE TABLE focus_ratio_summary AS

SELECT
    CASE
        WHEN bf.focus_ratio < 0.20 THEN '0.00–0.20'
        WHEN bf.focus_ratio < 0.40 THEN '0.20–0.40'
        WHEN bf.focus_ratio < 0.60 THEN '0.40–0.60'
        WHEN bf.focus_ratio < 0.80 THEN '0.60–0.80'
        ELSE '0.80–1.00'
    END AS focus_bucket,

    COUNT(*) AS sessions,

    COUNT(*) FILTER (WHERE sf.purchases > 0) AS purchased_sessions,

    ROUND(
        100.0 *
        COUNT(*) FILTER (WHERE sf.purchases > 0)::numeric
        / COUNT(*),
        2
    ) AS purchase_rate,

    ROUND(AVG(bf.focus_ratio)::numeric,3) AS avg_focus_ratio

FROM behavior_features bf
JOIN session_funnel sf
USING (visitorid, session_id)

WHERE bf.unique_products_viewed > 1

GROUP BY
    CASE
        WHEN bf.focus_ratio < 0.20 THEN '0.00–0.20'
        WHEN bf.focus_ratio < 0.40 THEN '0.20–0.40'
        WHEN bf.focus_ratio < 0.60 THEN '0.40–0.60'
        WHEN bf.focus_ratio < 0.80 THEN '0.60–0.80'
        ELSE '0.80–1.00'
    END

ORDER BY
    MIN(bf.focus_ratio);