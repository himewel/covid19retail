{{ config(materialized='table') }}

  SELECT DISTINCT
    CAST(CAST(vendor_number AS FLOAT64) AS INT64) AS CdVendor,
    vendor_name AS DsVendorName
  FROM {{ ref('iowa_liquor_sales') }}
  WHERE vendor_number IS NOT NULL
    AND vendor_name IS NOT NULL
