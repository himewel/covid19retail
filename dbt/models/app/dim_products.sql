{{ config(materialized='table') }}

  WITH products AS (
    SELECT
      ROW_NUMBER() OVER(PARTITION BY item_number ORDER BY item_description) AS rank_val,
      item_number,
      category,
      vendor_number,
      item_description,
      pack,
      bottle_volume_ml,
      state_bottle_cost,
      state_bottle_retail
    FROM {{ ref('iowa_liquor_sales') }}
    WHERE item_number IS NOT NULL
      AND item_description IS NOT NULL
  )

  SELECT
    CAST(item_number AS INT64) AS CdProduct,
    CAST(CAST(category AS FLOAT64) AS INT64) AS CdCategory,
    CAST(CAST(vendor_number AS FLOAT64) AS INT64) AS CdVendor,
    item_description AS DsProductName,
    pack AS QtPackItems,
    bottle_volume_ml AS NuBottleVolumeMl,
    state_bottle_cost AS VrStateBottleCost,
    state_bottle_retail AS VrStateBottleRetail
  FROM products
  WHERE rank_val = 1
