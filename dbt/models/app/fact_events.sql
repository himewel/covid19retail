{{ config(materialized='incremental', unique_key='CdEvent') }}

  SELECT
    SHA1(CONCAT(counties.CdCounty, covid19.date)) AS CdEvent,
    counties.CdCounty,
    dates.CdDate,
    covid19.school_closing AS InSchoolClosing,
    covid19.workplace_closing AS InWorkspaceClosing,
    covid19.cancel_public_events AS InCancelPublicEvents,
  	covid19.restrictions_on_gatherings AS InRestrictionsOnGatherings,
  	covid19.public_transport_closing AS InPublicTransportClosing,
  	covid19.stay_at_home_requirements AS InStayAtHomeRequirements,
  	covid19.restrictions_on_internal_movement AS InRestrictionsOnInternalMovement,
  	covid19.international_travel_controls AS InInternationalTravelControls,
  	covid19.income_support AS InIncomeSupport,
  	covid19.debt_relief AS InDebtRelief,
  	covid19.fiscal_measures AS InFiscalMeasures,
  	covid19.international_support AS InInternationalSupport,
  	covid19.public_information_campaigns AS InPublicInformationCampaigns,
  	covid19.testing_policy AS InTestingPolicy,
  	covid19.contact_tracing AS InContactTracing,
  	covid19.emergency_investment_in_healthcare AS InEmergencyInvestmentInHealthcare,
  	covid19.investment_in_vaccines AS InInvestmentInVaccines,
  	covid19.facial_coverings AS InFacialCoverings,
  	covid19.vaccination_policy AS InVaccinationPolicy,
  	covid19.stringency_index AS InStringencyIndex,
  	covid19.average_temperature_celsius AS NuAveTempCelsius,
  	covid19.minimum_temperature_celsius AS NuMinTempCelsius,
    covid19.maximum_temperature_celsius AS NuMaxTempCelsius
  FROM {{ ref('covid19_open_data') }} AS covid19
  JOIN {{ ref('dim_counties') }} AS counties
    ON covid19.subregion2_name = counties.DsCountyName
  JOIN {{ ref('dim_dates') }} AS dates
    ON covid19.date = dates.DsDate
