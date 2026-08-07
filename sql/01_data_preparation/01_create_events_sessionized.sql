DROP TABLE IF EXISTS events_sessionized;

CREATE TABLE events_sessionized AS

WITH ordered_events AS (

    SELECT
        visitorid,
        itemid,
        event,
        transactionid,
        timestamp,

        TO_TIMESTAMP(timestamp / 1000.0) AS event_time,

        LAG(TO_TIMESTAMP(timestamp / 1000.0))
            OVER (
                PARTITION BY visitorid
                ORDER BY timestamp
            ) AS prev_event_time

    FROM events
),

session_flags AS (

    SELECT
        *,

        CASE
            WHEN prev_event_time IS NULL THEN 1

            WHEN event_time - prev_event_time
                 > INTERVAL '30 minutes'
            THEN 1

            ELSE 0
        END AS new_session

    FROM ordered_events
)

SELECT
    visitorid,
    itemid,
    event,
    transactionid,
    timestamp,
    event_time,

    SUM(new_session)
        OVER (
            PARTITION BY visitorid
            ORDER BY event_time
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND CURRENT ROW
        ) AS session_id

FROM session_flags;