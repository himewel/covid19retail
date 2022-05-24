{{ config(materialized='incremental') }}

SELECT *
FROM {{ source('covid19_open_data', 'covid19_open_data') }}
WHERE subregion1_code = 'IA'
  AND country_code = 'USA'
  AND date = '{{ dbt_airflow_macros.ds()}}'
