{{ config(materialized='incremental') }}

SELECT *
FROM {{ source('iowa_liquor', 'sales') }}
WHERE county IS NOT NULL
  AND date = '{{ dbt_airflow_macros.ds()}}'
