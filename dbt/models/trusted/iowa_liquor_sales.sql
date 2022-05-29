{{ config(materialized='incremental', unique_key='invoice_and_item_number') }}

  SELECT *
  FROM {{ source('iowa_liquor', 'sales') }}
  WHERE county IS NOT NULL
    AND date >= '{{ env_var("START_DATE", "") }}'
    AND date < '{{ env_var("END_DATE", "") }}'
