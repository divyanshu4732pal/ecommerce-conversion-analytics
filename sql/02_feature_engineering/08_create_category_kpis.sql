DROP TABLE IF EXISTS category_kpis;

CREATE TABLE category_kpis AS

WITH category_map AS (

    SELECT DISTINCT
        itemid,
        value::BIGINT AS category_id

    FROM item_properties

    WHERE property='categoryid'
),

event_category AS (

    SELECT
        e.event,
        c.category_id

    FROM events e
    JOIN category_map c
      ON e.itemid=c.itemid
)

SELECT

    ct.categoryid AS category_id,
    ct.parentid   AS parent_category,

    COUNT(*) FILTER (WHERE event='view')        AS views,
    COUNT(*) FILTER (WHERE event='addtocart')   AS carts,
    COUNT(*) FILTER (WHERE event='transaction') AS purchases,

    ROUND(
        COUNT(*) FILTER (WHERE event='addtocart')::numeric
        / NULLIF(COUNT(*) FILTER (WHERE event='view'),0),
        4
    ) AS view_to_cart_rate,

    ROUND(
        COUNT(*) FILTER (WHERE event='transaction')::numeric
        / NULLIF(COUNT(*) FILTER (WHERE event='addtocart'),0),
        4
    ) AS cart_to_purchase_rate,

    ROUND(
        COUNT(*) FILTER (WHERE event='transaction')::numeric
        / NULLIF(COUNT(*) FILTER (WHERE event='view'),0),
        4
    ) AS overall_conversion_rate

FROM category_tree ct

LEFT JOIN event_category ec
ON ct.categoryid=ec.category_id

GROUP BY
    ct.categoryid,
    ct.parentid;