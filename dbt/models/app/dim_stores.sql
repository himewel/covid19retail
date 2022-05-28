{{ config(materialized='table') }}

  WITH stores AS (
    SELECT
      ROW_NUMBER() OVER(PARTITION BY store_number ORDER BY store_name) AS rank_val,
      store_number,
      county_number,
      store_name,
      address,
      city,
      zip_code,
      store_location,
    FROM {{ ref('iowa_liquor_sales') }}
    WHERE category IS NOT NULL
      AND category_name IS NOT NULL
  )

  SELECT
    CAST(store_number AS INT64) AS CdStore,
    CAST(county_number AS INT64) AS CdCounty,
    store_name AS DsStoreName,
    address AS DsAddress,
    city AS DsCity,
    zip_code AS NuZipCode,
    store_location AS DsStoreLocation
  FROM stores
  WHERE rank_val = 1
