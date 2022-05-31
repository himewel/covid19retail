{{ config(materialized='incremental', unique_key='CdReport') }}

  SELECT
    SHA1(CONCAT(counties.CdCounty, covid19.date)) AS CdReport,
    counties.CdCounty,
  	dates.CdDate,
  	covid19.new_confirmed AS QtConfirmed,
  	covid19.new_deceased AS QtDeceased,
    covid19.new_persons_fully_vaccinated AS QtPersonsFullyVaccinated,
    covid19.average_temperature_celsius AS NuAveTempCelsius,
    covid19.minimum_temperature_celsius AS NuMinTempCelsius,
    covid19.maximum_temperature_celsius AS NuMaxTempCelsius
  FROM {{ ref('covid19_open_data') }} AS covid19
  JOIN {{ ref('dim_counties') }} AS counties
    ON covid19.subregion2_name = counties.DsCountyName
  JOIN {{ ref('dim_dates') }} AS dates
    ON covid19.date = dates.DsDate
