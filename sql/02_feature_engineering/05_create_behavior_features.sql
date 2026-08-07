DROP TABLE IF EXISTS behavior_features;

CREATE TABLE behavior_features AS
SELECT
    visitorid,
    session_id,

    COUNT(DISTINCT CASE
        WHEN event = 'view' THEN itemid
    END) AS unique_products_viewed,

    COUNT(CASE
        WHEN event = 'view' THEN 1
    END) AS total_views,

    COUNT(CASE
        WHEN event = 'view' THEN 1
    END)
    -
    COUNT(DISTINCT CASE
        WHEN event = 'view' THEN itemid
    END) AS repeat_views,

    COALESCE(MAX(view_count),0) AS max_views_same_product,

    ROUND(
        COALESCE(MAX(view_count),0)::numeric
        /
        NULLIF(
            COUNT(CASE WHEN event='view' THEN 1 END),
            0
        ),
        3
    ) AS focus_ratio

FROM (
    SELECT
        *,
        COUNT(*) FILTER (WHERE event='view')
        OVER(PARTITION BY visitorid,session_id,itemid) AS view_count
    FROM events_sessionized
) t

GROUP BY visitorid,session_id;select * from cart_behavior_analysis_202