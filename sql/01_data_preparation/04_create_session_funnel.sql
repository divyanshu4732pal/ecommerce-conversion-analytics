DROP TABLE IF EXISTS session_funnel;

CREATE TABLE session_funnel AS

SELECT
    s.*,

    CASE
        WHEN purchases > 0
             AND carts > 0
             AND views > 0
            THEN 'Purchased'

        WHEN purchases > 0
             AND carts = 0
             AND views > 0
            THEN 'Purchased without Cart'

        WHEN purchases > 0
             AND views = 0
            THEN 'Purchased without View'

        WHEN carts > 0
             AND purchases = 0
             AND views > 0
            THEN 'Cart Abandonment'

        WHEN carts > 0
             AND views = 0
            THEN 'Cart without View'

        ELSE 'View Only'
    END AS funnel_stage

FROM sessions s;