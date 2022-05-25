{{ config(materialized='incremental') }}

SELECT *
FROM {{ source('iowa_liquor', 'sales') }}
WHERE county IS NOT NULL
  AND date = '{{ env_var("EXECUTION_DATE", "") }}'
