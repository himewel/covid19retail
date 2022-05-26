{{ config(materialized='table') }}

  SELECT DISTINCT
    CAST(store_number AS INT64) AS CdStore,
    store_name AS DsStoreName,
    address AS DsAddress,
    city AS DsCity,
    zip_code AS NuZipCode,
    store_location AS DsStoreLocation,
    CAST(county_number AS INT64) AS CdCounty
  FROM {{ ref('iowa_liquor_sales') }}
  WHERE category IS NOT NULL
    AND category_name IS NOT NULL
