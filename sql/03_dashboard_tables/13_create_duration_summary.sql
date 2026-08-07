DROP TABLE IF EXISTS duration_summary;

CREATE TABLE duration_summary AS

WITH non_zero AS (
    SELECT
        session_duration_minutes,
        purchases,
        NTILE(4) OVER (ORDER BY session_duration_minutes) AS nz_bucket
    FROM session_funnel
    WHERE session_duration_minutes > 0
),

combined AS (

    -- Bucket 1: Zero-duration sessions
    SELECT
        1 AS duration_bucket,
        session_duration_minutes,
        purchases
    FROM session_funnel
    WHERE session_duration_minutes = 0

    UNION ALL

    -- Buckets 2-5: Non-zero sessions
    SELECT
        nz_bucket + 1 AS duration_bucket,
        session_duration_minutes,
        purchases
    FROM non_zero
)

SELECT
    duration_bucket,

    CASE
        WHEN duration_bucket = 1 THEN '0 min'
        WHEN duration_bucket = 5 THEN
            CONCAT(
                ROUND(MIN(session_duration_minutes)::numeric,2),
                '+ min'
            )
        ELSE
            CONCAT(
                ROUND(MIN(session_duration_minutes)::numeric,2),
                '–',
                ROUND(MAX(session_duration_minutes)::numeric,2),
                ' min'
            )
    END AS duration_label,

    ROUND(AVG(session_duration_minutes)::numeric,2) AS avg_duration,

    COUNT(*) AS sessions,

    COUNT(*) FILTER (WHERE purchases > 0) AS purchased_sessions,

    ROUND(
        100.0 *
        COUNT(*) FILTER (WHERE purchases > 0)::numeric /
        COUNT(*),
        2
    ) AS purchase_rate

FROM combined
GROUP BY duration_bucket
ORDER BY duration_bucket;