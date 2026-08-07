DROP TABLE IF EXISTS post_cart_behavior;

CREATE TABLE post_cart_behavior AS

WITH first_cart AS (

    SELECT
        visitorid,
        session_id,
        MIN(event_time) AS first_cart_time

    FROM events_sessionized

    WHERE event = 'addtocart'

    GROUP BY
        visitorid,
        session_id
),

events_after_cart AS (

    SELECT
        e.visitorid,
        e.session_id,
        e.event,
        e.event_time

    FROM events_sessionized e

    JOIN first_cart f

      ON e.visitorid = f.visitorid
     AND e.session_id = f.session_id

    WHERE e.event_time > f.first_cart_time
)

SELECT

    s.visitorid,
    s.session_id,

    STRING_AGG(
        event,
        ' → '
        ORDER BY event_time
    ) AS sequence_after_cart,

    COUNT(*) FILTER (
        WHERE event = 'view'
    ) AS views_after_cart,

    COUNT(*) FILTER (
        WHERE event = 'addtocart'
    ) AS repeated_addtocarts,

    COUNT(*) FILTER (
        WHERE event = 'transaction'
    ) AS purchases_after_cart,

    COUNT(*) AS actions_after_cart,

    CASE

        WHEN COUNT(*) FILTER (
                 WHERE event = 'view'
             ) = 0

         AND COUNT(*) FILTER (
                 WHERE event = 'transaction'
             ) > 0

        THEN TRUE

        ELSE FALSE

    END AS immediate_purchase,

    CASE

        WHEN COUNT(*) FILTER (
                 WHERE event = 'transaction'
             ) > 0

        THEN TRUE

        ELSE FALSE

    END AS purchased

FROM sessions s

LEFT JOIN events_after_cart e

       ON s.visitorid = e.visitorid
      AND s.session_id = e.session_id

GROUP BY

    s.visitorid,
    s.session_id

ORDER BY

    s.visitorid,
    s.session_id;