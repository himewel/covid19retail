{{ config(materialized='table') }}

  SELECT DISTINCT
    CAST(item_number AS INT64) AS CdProduct,
    CAST(CAST(category AS FLOAT64) AS INT64) AS CdCategory,
    CAST(CAST(vendor_number AS FLOAT64) AS INT64) AS CdVendor,
    item_description AS DsProductName,
    pack AS QtPackItems,
    bottle_volume_ml AS NuBottleVolumeMl,
    state_bottle_cost AS VrStateBottleCost,
    state_bottle_retail AS VrStateBottleRetail
  FROM {{ ref('iowa_liquor_sales') }}
  WHERE item_number IS NOT NULL
    AND item_description IS NOT NULL
