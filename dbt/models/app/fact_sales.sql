{{ config(materialized='incremental', unique_key='CdSale') }}

  SELECT
    sales.invoice_and_item_number AS CdSale,
    dates.CdDate,
    CAST(sales.store_number AS INT64) AS CdStore,
    CAST(sales.item_number AS INT64) AS CdProduct,
    SUBSTR(sales.invoice_and_item_number, 0, LENGTH(sales.invoice_and_item_number) - 5) AS CdInvoice,
    CAST(LTRIM(SUBSTR(sales.invoice_and_item_number, -5), '0') AS INT64) AS NuItemNumber,
    IFNULL(sales.bottles_sold, 0) AS QtBottlesSold,
    IFNULL(sales.sale_dollars, 0) AS VrSalesDollars,
    IFNULL(sales.volume_sold_liters, 0) AS VrVolumeSoldLiters,
    IFNULL(sales.volume_sold_gallons, 0) AS VrVolumeSoldGalons
  FROM {{ ref('iowa_liquor_sales') }} AS sales
  JOIN {{ ref('dim_dates') }} AS dates
    ON sales.date = dates.DsDate
