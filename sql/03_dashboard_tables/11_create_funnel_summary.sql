DROP TABLE IF EXISTS funnel_summary;

CREATE TABLE funnel_summary AS

SELECT
    'Viewed' AS stage,
    COUNT(*) AS sessions
FROM session_features
WHERE views > 0

UNION ALL

SELECT
    'Added to Cart',
    COUNT(*)
FROM session_features
WHERE carts > 0

UNION ALL

SELECT
    'Purchased',
    COUNT(*)
FROM session_features
WHERE purchases > 0;