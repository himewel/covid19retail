{{ config(materialized='table') }}

  WITH iowa_counties AS (
    SELECT DISTINCT
      county_number,
      SUBSTR(LOWER(REPLACE(county, '\'', '')), 0, 10) AS county
    FROM {{ ref('iowa_liquor_sales') }}
    WHERE county_number IS NOT NULL
  ),
  covid19_counties AS (
    SELECT DISTINCT
      subregion2_code,
      subregion2_name,
      subregion1_code,
      subregion1_name,
      country_code,
      country_name
    FROM {{ ref('covid19_open_data') }}
    WHERE aggregation_level = 2
      AND subregion1_code = 'IA'
      AND country_code = 'US'
      AND subregion2_code IS NOT NULL
  )

  SELECT
    CAST(iowa_counties.county_number AS INT64) AS CdCounty,
    covid19_counties.subregion2_name AS DsCountyName,
    covid19_counties.subregion1_code AS CdState,
    covid19_counties.subregion1_name AS CdStateName,
    covid19_counties.country_code AS CdCountry,
    covid19_counties.country_name AS CdCountryName
  FROM covid19_counties
  FULL JOIN iowa_counties
    ON SUBSTR(LOWER(REGEXP_REPLACE(covid19_counties.subregion2_name, ' County|\'', '')), 0, 10) = iowa_counties.county
