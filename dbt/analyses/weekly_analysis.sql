  WITH reports_weekly AS (
    SELECT
      DATE_SUB(dates.DsDate, INTERVAL dates.NuDayOfWeek - 1 DAY) AS refDate,
      reports.CdCounty,
      SUM(reports.QtConfirmed) AS QtConfirmed,
      SUM(reports.QtDeceased) AS QtDeceased
    FROM `covid19-retail-090522.covid19retail_app.fact_reports` AS reports
      JOIN `covid19-retail-090522.covid19retail_app.dim_dates` AS dates
      ON dates.CdDate = reports.CdDate
    GROUP BY refDate, reports.CdCounty
  ),
  sales_weekly AS (
    SELECT
      DATE_SUB(dates.DsDate, INTERVAL dates.NuDayOfWeek - 1 DAY) AS refDate,
      stores.CdCounty,
      SUM(sales.QtBottlesSold) AS QtBottlesSold,
      SUM(sales.VrSalesDollars) AS VrSalesDollars
    FROM `covid19-retail-090522.covid19retail_app.fact_sales` AS sales
    JOIN `covid19-retail-090522.covid19retail_app.dim_dates` AS dates
      ON dates.CdDate = sales.CdDate
    JOIN `covid19-retail-090522.covid19retail_app.dim_stores` AS stores
      ON stores.CdStore = sales.CdStore
    GROUP BY refDate, stores.CdCounty
  ),
  stringency_weekly AS (
    SELECT
      DATE_SUB(dates.DsDate, INTERVAL dates.NuDayOfWeek - 1 DAY) AS refDate,
      AVG(events.InStringencyIndex) AS InStringencyIndex
    FROM `covid19-retail-090522.covid19retail_app.fact_events` AS events
    JOIN `covid19-retail-090522.covid19retail_app.dim_dates` AS dates
      ON dates.CdDate = events.CdDate
    GROUP BY refDate
  )

  SELECT
    reports_weekly.refDate,
    reports_weekly.CdCounty,
    reports_weekly.QtConfirmed,
    reports_weekly.QtDeceased,
    sales_weekly.QtBottlesSold,
    sales_weekly.VrSalesDollars,
    stringency_weekly.InStringencyIndex
  FROM sales_weekly
  JOIN reports_weekly
    ON sales_weekly.CdCounty = reports_weekly.CdCounty
    AND sales_weekly.refDate = reports_weekly.refDate
  JOIN stringency_weekly
    ON sales_weekly.refDate = stringency_weekly.refDate
