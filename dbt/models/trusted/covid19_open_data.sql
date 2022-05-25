{{ config(materialized='incremental', unique_key='surrogate_key') }}

  SELECT
    SHA1(CONCAT(location_key, date, aggregation_level)) AS surrogate_key,
    *
  FROM {{ source('covid19_open_data', 'covid19_open_data') }}
  WHERE subregion1_code = 'IA'
    AND country_code = 'US'
    AND date = '{{ env_var("EXECUTION_DATE", "") }}'
