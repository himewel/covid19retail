  WITH source_count AS (
    SELECT date, count(1) AS total_count
    FROM {{ source('covid19_open_data', 'covid19_open_data') }}
    WHERE subregion1_code = 'IA'
    AND country_code = 'US'
    GROUP BY date
  ),
  destination_count AS (
    SELECT date, count(1) AS total_count
    FROM {{ ref('covid19_open_data') }}
    GROUP BY date
  )

  SELECT
    destination_count.date,
    source_count.total_count AS source_count,
    destination_count.total_count AS destination_count
  FROM destination_count
  LEFT JOIN source_count
    ON destination_count.date = source_count.date
  WHERE source_count != destination_count
