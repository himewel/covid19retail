WITH source_count AS (
  SELECT date, count(1) AS total_count
  FROM {{ source('iowa_liquor', 'sales') }}
  WHERE county IS NOT NULL
  GROUP BY date
),
destination_count AS (
  SELECT date, count(1) AS total_count
  FROM {{ ref('iowa_liquor_sales') }}
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
