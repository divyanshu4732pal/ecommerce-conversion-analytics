DROP TABLE IF EXISTS session_features;

CREATE TABLE session_features AS

SELECT
    s.*,

    CASE
        WHEN purchases > 0 THEN 1
        ELSE 0
    END AS converted,

    CASE
        WHEN carts > 0 THEN 1
        ELSE 0
    END AS cart_reached,

    ROUND(
        events_in_session::numeric /
        NULLIF(unique_items, 0),
        2
    ) AS events_per_item,

    CASE
        WHEN purchases > 0 THEN 'Converted'
        WHEN carts > 0 THEN 'Cart Abandonment'
        WHEN views > 1 THEN 'Browsing'
        ELSE 'Bounce'
    END AS session_type

FROM sessions s;