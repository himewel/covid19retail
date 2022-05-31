  WITH sales_by_county AS (
    SELECT
      sales.CdDate,
      stores.CdCounty,
      SUM(sales.QtBottlesSold) AS QtBottlesSoldTotal,
      SUM(sales.VrSalesDollars) AS VrSalesDollarsTotal,
      SUM(sales.VrVolumeSoldLiters) AS VrVolumeSoldLitersTotal
    FROM covid19retail_app.fact_sales AS sales
    JOIN covid19retail_app.dim_stores AS stores
      ON sales.CdStore = stores.CdStore
    GROUP BY CdDate, CdCounty
  )

  SELECT
    dates.DsDate,
    counties.DsCountyName,
    counties.CdState,
    counties.CdStateName,
    counties.CdCountryName,
    counties.QtPopulation,
    counties.QtPopulationMale,
    counties.QtPopulationFemale,
    counties.NuLatitude,
    counties.NuLongitude,
    counties.NuAreqSqKm,
    reports.QtConfirmed,
    reports.QtDeceased,
    reports.QtPersonsFullyVaccinated,
    reports.NuAveTempCelsius,
    reports.NuMinTempCelsius,
    reports.NuMaxTempCelsius,
    events.InSchoolClosing,
    events.InWorkspaceClosing,
    events.InCancelPublicEvents,
    events.InRestrictionsOnGatherings,
    events.InPublicTransportClosing,
    events.InStayAtHomeRequirements,
    events.InRestrictionsOnInternalMovement,
    events.InInternationalTravelControls,
    events.InIncomeSupport,
    events.InDebtRelief,
    events.InPublicInformationCampaigns,
    events.InTestingPolicy,
    events.InContactTracing,
    events.InInvestmentInVaccines,
    events.InFacialCoverings,
    events.InVaccinationPolicy,
    events.InStringencyIndex,
    events.QtPersonsVaccinated,
    events.QtVaccineDosesAdministered,
    events.QtTested,
    events.QtRecovered,
    events.QtHospitalizedPatients,
    events.QtCurrentHospitalizedPatients,
    events.QtCurrentIntensiveCarePatients,
    events.QtCurrentVentilatorPatient,
    events.QtPersonsFullyVaccinatedPfizer,
    events.QtVaccineDosesAdministeredPfizer,
    events.QtPersonsFullyVaccinatedModerna,
    events.QtVaccineDosesAdministeredModerna,
    events.QtPersonsFullyVaccinatedJanssen,
    events.QtVaccineDosesAdministeredJanssen,
    sales.QtBottlesSoldTotal,
    sales.VrSalesDollarsTotal,
    sales.VrVolumeSoldLitersTotal
  FROM covid19retail_app.fact_reports AS reports
  JOIN covid19retail_app.fact_events AS events
    ON reports.CdDate = events.CdDate
  LEFT JOIN sales_by_county AS sales
    ON reports.CdDate = sales.CdDate
    AND reports.CdCounty = sales.CdCounty
  JOIN covid19retail_app.dim_dates AS dates
    ON reports.CdDate = dates.CdDate
  JOIN covid19retail_app.dim_counties AS counties
    ON reports.CdCounty = counties.CdCounty
