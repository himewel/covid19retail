{{ config(materialized='table') }}

  SELECT
    SUBSTR(invoice_and_item_number, 0, LENGTH(invoice_and_item_number) - 5) AS CdInvoice,
    CAST(LTRIM(SUBSTR(invoice_and_item_number, -5), '0') AS INT64) AS NuItemNumber,
    date AS DtSale,
    CAST(store_number AS INT64) AS CdStore,
    CAST(item_number AS INT64) AS CdProduct,
    bottles_sold AS QtBottlesSold,
    sale_dollars AS VrSalesDollars,
    volume_sold_liters AS VrVolumeSoldLiters,
    volume_sold_gallons AS VrVolumeSoldGalons
  FROM {{ ref('iowa_liquor_sales') }}
