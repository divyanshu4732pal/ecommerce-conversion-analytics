CREATE TABLE opportunity_coverage AS
WITH ranked AS (
    SELECT
        category_id,
        opportunity_carts,
        ROW_NUMBER() OVER (ORDER BY opportunity_carts DESC) AS rank,
        SUM(opportunity_carts) OVER (ORDER BY opportunity_carts DESC) AS cumulative_opportunity,
        SUM(opportunity_carts) OVER () AS total_opportunity,
        COUNT(*) OVER () AS total_categories
    FROM category_performance
)

SELECT
    milestone,
    categories_required,
    ROUND(100.0 * categories_required / total_categories, 1) AS pct_categories
FROM (

    SELECT
        '50%' AS milestone,
        MIN(rank) AS categories_required,
        MAX(total_categories) AS total_categories
    FROM ranked
    WHERE cumulative_opportunity >= 0.50 * total_opportunity

    UNION ALL

    SELECT
        '60%',
        MIN(rank),
        MAX(total_categories)
    FROM ranked
    WHERE cumulative_opportunity >= 0.60 * total_opportunity

    UNION ALL

    SELECT
        '70%',
        MIN(rank),
        MAX(total_categories)
    FROM ranked
    WHERE cumulative_opportunity >= 0.70 * total_opportunity

    UNION ALL

    SELECT
        '80%',
        MIN(rank),
        MAX(total_categories)
    FROM ranked
    WHERE cumulative_opportunity >= 0.80 * total_opportunity

    UNION ALL

    SELECT
        '90%',
        MIN(rank),
        MAX(total_categories)
    FROM ranked
    WHERE cumulative_opportunity >= 0.90 * total_opportunity

) t;