{{ config(materialized='table') }}

  WITH vendors AS (
    SELECT
      CAST(CAST(vendor_number AS FLOAT64) AS INT64) AS vendor_number,
      vendor_name,
      ROW_NUMBER() OVER(
        PARTITION BY CAST(CAST(vendor_number AS FLOAT64) AS INT64)
        ORDER BY date
      ) AS rank_val
    FROM {{ ref('iowa_liquor_sales') }}
    WHERE vendor_number IS NOT NULL
      AND vendor_name IS NOT NULL
  )
  SELECT
    vendor_number AS CdVendor,
    vendor_name AS DsVendorName
  FROM vendors
  WHERE rank_val = 1
