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
      country_name,
      population,
      population_male,
      population_female,
      openstreetmap_id,
      latitude,
      longitude,
      ST_ASTEXT(location_geometry) AS location_geometry,
      area_sq_km
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
    covid19_counties.country_name AS CdCountryName,
    covid19_counties.population AS QtPopulation,
    covid19_counties.population_male AS QtPopulationMale,
    covid19_counties.population_female AS QtPopulationFemale,
    covid19_counties.openstreetmap_id AS CdOpenStreetMap,
    covid19_counties.latitude AS NuLatitude,
    covid19_counties.longitude AS NuLongitude,
    ST_GEOGFROMTEXT(covid19_counties.location_geometry) AS CdLocationGeometry,
    covid19_counties.area_sq_km AS NuAreqSqKm
  FROM covid19_counties
  LEFT JOIN iowa_counties
    ON SUBSTR(LOWER(REGEXP_REPLACE(covid19_counties.subregion2_name, ' County|\'', '')), 0, 10) = iowa_counties.county
  WHERE iowa_counties.county_number IS NOT NULL
