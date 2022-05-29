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
    reports.CdCounty,
    reports.CdDate,
    QtConfirmed,
    QtDeceased,
    QtPersonsVaccinated,
    QtPersonsFullyVaccinated,
    QtVaccineDosesAdministered,
    QtTested,
    QtRecovered,
    QtHospitalizedPatients,
    QtIntensiveCarePatients,
    QtConfirmedMale,
    QtConfirmedFemale,
    QtDeceasedMale,
    QtDeceasedFemale,
    QtTestedMale,
    QtTestedFemale,
    QtHospitalizedPatientsMale,
    QtHospitalizedPatientsFemale,
    QtIntensiveCarePatientsMale,
    QtIntensiveCarePatientsFemale,
    QtRecoveredMale,
    QtRecoveredFemale,
    QtVentilatorPatients,
    QtPersonsFullyVaccinatedPfizer,
    QtVaccineDosesAdministeredPfizer,
    QtPersonsFullyVaccinatedModerna,
    QtVaccineDosesAdministeredModerna,
    QtPersonsFullyVaccinatedJanssen,
    QtVaccineDosesAdministeredJanssen,
    QtCurrentHospitalizedPatients,
    QtCurrentIntensiveCarePatients,
    QtCurrentVentilatorPatient,
    InSchoolClosing,
    InWorkspaceClosing,
    InCancelPublicEvents,
    InRestrictionsOnGatherings,
    InPublicTransportClosing,
    InStayAtHomeRequirements,
    InRestrictionsOnInternalMovement,
    InInternationalTravelControls,
    InIncomeSupport,
    InDebtRelief,
    InFiscalMeasures,
    InInternationalSupport,
    InPublicInformationCampaigns,
    InTestingPolicy,
    InContactTracing,
    InEmergencyInvestmentInHealthcare,
    InInvestmentInVaccines,
    InFacialCoverings,
    InVaccinationPolicy,
    InStringencyIndex,
    NuAveTempCelsius,
    NuMinTempCelsius,
    NuMaxTempCelsius,
    QtBottlesSoldTotal,
    VrSalesDollarsTotal,
    VrVolumeSoldLitersTotal,
    NuDayOfWeek,
    NuDay,
    NuDayOfYear,
    NuWeekDay,
    NuWeek,
    NuIsoWeek,
    NuMonth,
    NuQuarter,
    NuYear,
    NuIsoYear,
    NuMonthYear,
    DsCountyName,
    CdState,
    CdStateName,
    CdCountry,
    CdCountryName,
    QtPopulation,
    QtPopulationMale,
    QtPopulationFemale,
    QtPopulationDensity,
    NuHumanIndexDevelopment,
    NuGdpUsd,
    NuGdpUsdPerCapita,
    CdOpenStreetMap,
    NuLatitude,
    NuLongitude,
    CdLocationGeometry,
    NuAreqSqKm,
    QtHospitalBedsPer1000
  FROM covid19retail_app.fact_reports AS reports
  JOIN covid19retail_app.fact_events AS events
    ON reports.CdDate = events.CdDate
      AND reports.CdCounty = events.CdCounty
  LEFT JOIN sales_by_county AS sales
    ON reports.CdDate = sales.CdDate
      AND reports.CdCounty = sales.CdCounty
  JOIN covid19retail_app.dim_dates AS dates
    ON reports.CdDate = dates.CdDate
  JOIN covid19retail_app.dim_counties AS counties
    ON reports.CdCounty = counties.CdCounty
