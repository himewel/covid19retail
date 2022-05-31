{{ config(materialized='incremental', unique_key='CdEvent') }}

  SELECT
    SHA1(CAST(covid19.date AS STRING)) AS CdEvent,
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
  	covid19.public_information_campaigns AS InPublicInformationCampaigns,
  	covid19.testing_policy AS InTestingPolicy,
  	covid19.contact_tracing AS InContactTracing,
  	covid19.investment_in_vaccines AS InInvestmentInVaccines,
  	covid19.facial_coverings AS InFacialCoverings,
  	covid19.vaccination_policy AS InVaccinationPolicy,
  	covid19.stringency_index AS InStringencyIndex,
    covid19.new_persons_vaccinated AS QtPersonsVaccinated,
    covid19.new_vaccine_doses_administered AS QtVaccineDosesAdministered,
  	covid19.new_tested AS QtTested,
  	covid19.new_recovered AS QtRecovered,
  	covid19.new_hospitalized_patients AS QtHospitalizedPatients,
    covid19.current_hospitalized_patients AS QtCurrentHospitalizedPatients,
    covid19.current_intensive_care_patients AS QtCurrentIntensiveCarePatients,
    covid19.current_ventilator_patients AS QtCurrentVentilatorPatient,
  	covid19.new_persons_fully_vaccinated_pfizer AS QtPersonsFullyVaccinatedPfizer,
  	covid19.new_vaccine_doses_administered_pfizer AS QtVaccineDosesAdministeredPfizer,
  	covid19.new_persons_fully_vaccinated_moderna AS QtPersonsFullyVaccinatedModerna,
  	covid19.new_vaccine_doses_administered_moderna AS QtVaccineDosesAdministeredModerna,
  	covid19.new_persons_fully_vaccinated_janssen AS QtPersonsFullyVaccinatedJanssen,
  	covid19.new_vaccine_doses_administered_janssen AS QtVaccineDosesAdministeredJanssen
  FROM {{ ref('covid19_open_data') }} AS covid19
  JOIN {{ ref('dim_dates') }} AS dates
    ON covid19.date = dates.DsDate
  WHERE covid19.aggregation_level = 1
