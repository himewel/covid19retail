{{ config(materialized='table') }}

  SELECT DISTINCT
    CAST(CAST(category AS FLOAT64) AS INT64) AS CdCategory,
    category_name AS DsCategoryName
  FROM {{ ref('iowa_liquor_sales') }}
  WHERE category IS NOT NULL
    AND category_name IS NOT NULL
