DROP TABLE IF EXISTS cart_behavior_analysis;

CREATE TABLE cart_behavior_analysis AS

SELECT

    sf.visitorid,
    sf.session_id,

    sf.funnel_stage,
    sf.purchased,

    bf.unique_products_viewed,
    bf.total_views,
    bf.repeat_views,
    bf.max_views_same_product,
    bf.focus_ratio

FROM session_funnel sf

LEFT JOIN behavior_features bf

USING(visitorid,session_id);