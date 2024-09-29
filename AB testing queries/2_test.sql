/* For AB test. Calculate duration from visit to purchase. */

WITH FirstVisit AS (
-- Capture the first visit time for each user on a given day
    SELECT
        user_pseudo_id,
        DATE(TIMESTAMP_MICROS(event_timestamp)) AS event_date,
        MIN(event_timestamp) AS first_visit_time
    FROM
        `raw_events`
    GROUP BY
        user_pseudo_id,
        event_date
),
Purchases AS (
    SELECT
        user_pseudo_id,
        DATE(TIMESTAMP_MICROS(event_timestamp)) AS event_date, -- Convert timestamp to date for grouping
        event_timestamp AS purchase_time,
        purchase_revenue_in_usd
    FROM
        `raw_events`
    WHERE
        event_name = 'purchase'
),
CombinedEvents AS (
-- Combine first visit times with all purchases for the same day
    SELECT
        p.user_pseudo_id,
        p.event_date,
        TIMESTAMP_MICROS(f.first_visit_time) AS first_visit_time,
        TIMESTAMP_MICROS(p.purchase_time) AS purchase_time,
-- Calculate the time difference between first visit and purchase in seconds
        TIMESTAMP_DIFF(TIMESTAMP_MICROS(p.purchase_time), TIMESTAMP_MICROS(f.first_visit_time), SECOND) AS duration_seconds,
        p.purchase_revenue_in_usd
    FROM
        Purchases p
    INNER JOIN
        FirstVisit f
    ON
-- Join by user ID key and event day to be the same day
        p.user_pseudo_id = f.user_pseudo_id
        AND p.event_date = f.event_date
)

SELECT
    c.event_date,
    COUNT(c.user_pseudo_id) AS total_purchases,
    SUM(c.purchase_revenue_in_usd) AS total_revenue,
    AVG(c.duration_seconds) / 60 AS avg_duration_minutes,
    AVG(c.duration_seconds) AS avg_duration_seconds, -- Average time (in seconds)
    APPROX_QUANTILES(c.duration_seconds, 100)[OFFSET(50)] AS median_duration_seconds -- median duration in seconds
FROM
    CombinedEvents c
GROUP BY
    c.event_date
ORDER BY
    c.event_date
