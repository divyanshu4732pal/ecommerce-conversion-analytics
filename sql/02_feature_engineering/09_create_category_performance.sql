DROP TABLE IF EXISTS category_performance;

CREATE TABLE category_performance AS

SELECT

    *,

    (
        SELECT
            AVG(view_to_cart_rate)
        FROM category_kpis
    ) AS benchmark_view_to_cart,

    ROUND(

        GREATEST(

            views *
            (
                (
                    SELECT AVG(view_to_cart_rate)
                    FROM category_kpis
                )
                -
                view_to_cart_rate
            ),

            0

        ),

        0

    ) AS opportunity_carts

FROM category_kpis;