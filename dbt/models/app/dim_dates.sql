{{ config(materialized='table') }}

  WITH dates AS (
    SELECT DISTINCT date
    FROM {{ ref('covid19_open_data') }}
  )

  SELECT
    CAST(FORMAT_DATETIME('%Y%m%d', date) AS INT64) AS CdDate,
    date AS DsDate,
    EXTRACT(DAYOFWEEK FROM date) AS NuDayOfWeek,
    EXTRACT(DAY FROM date) AS NuDay,
    EXTRACT(DAYOFYEAR FROM date) AS NuDayOfYear,
    EXTRACT(WEEK(SUNDAY) FROM date) AS NuWeekDay,
    EXTRACT(WEEK FROM date) AS NuWeek,
    EXTRACT(ISOWEEK FROM date) AS NuIsoWeek,
    EXTRACT(MONTH FROM date) AS NuMonth,
    EXTRACT(QUARTER FROM date) AS NuQuarter,
    EXTRACT(YEAR FROM date) AS NuYear,
    EXTRACT(ISOYEAR FROM date) AS NuIsoYear,
    FORMAT_DATE('%Y%m', date) AS NuMonthYear
  FROM dates
