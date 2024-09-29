/* Get data for AB testing newsletter versions. */

-- Select only first timestamp for each event avoiding duplication.
WITH
  ranked_events AS (
  SELECT *,
    RANK() OVER (PARTITION BY user_pseudo_id, event_name ORDER BY TIMESTAMP_MICROS(event_timestamp)) AS event_rank
  FROM
    `raw_events` ),
  events AS (
  SELECT *
  FROM ranked_events
  WHERE
    event_rank = 1
  ORDER BY
    TIMESTAMP_MICROS(event_timestamp) )

-- Get the count of unique events for each campaign, filtered by 'NewYear_V1' and 'NewYear_V2'.

SELECT
  COUNT(event_name) AS no_unique_events,
  event_name,
  campaign
FROM
  events
WHERE
  campaign IN ('NewYear_V1', 'NewYear_V2')
  GROUP BY
    ALL
  ORDER BY
    campaign,
    COUNT(event_name) DESC