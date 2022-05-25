{{ config(materialized='incremental') }}

SELECT *
FROM {{ source('covid19_open_data', 'covid19_open_data') }}
WHERE subregion1_code = 'IA'
  AND country_code = 'US'
  AND date = '{{ env_var("EXECUTION_DATE", "") }}'
