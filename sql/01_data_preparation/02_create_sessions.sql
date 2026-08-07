DROP TABLE IF EXISTS sessions;

CREATE TABLE sessions AS

SELECT

    visitorid,

    session_id,

    MIN(event_time) AS session_start,

    MAX(event_time) AS session_end,

    ROUND(
        EXTRACT(EPOCH FROM (MAX(event_time) - MIN(event_time))) / 60,
        2
    ) AS session_duration_minutes,

    COUNT(*) AS events_in_session,

    COUNT(*) FILTER (
        WHERE event = 'view'
    ) AS views,

    COUNT(*) FILTER (
        WHERE event = 'addtocart'
    ) AS carts,

    COUNT(*) FILTER (
        WHERE event = 'transaction'
    ) AS purchases,

    COUNT(DISTINCT itemid) AS unique_items,

    STRING_AGG(
        event,
        ' → '
        ORDER BY event_time
    ) AS event_sequence

FROM events_sessionized

GROUP BY
    visitorid,
    session_id

ORDER BY
    visitorid,
    session_id;