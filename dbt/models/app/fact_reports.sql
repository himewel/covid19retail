{{ config(materialized='incremental', unique_key='CdReport') }}

  SELECT
    SHA1(CONCAT(counties.CdCounty, covid19.date)) AS CdReport,
    counties.CdCounty,
  	dates.CdDate,
  	covid19.new_confirmed AS QtConfirmed,
  	covid19.new_deceased AS QtDeceased,
  	covid19.new_persons_vaccinated AS QtPersonsVaccinated,
  	covid19.new_persons_fully_vaccinated AS QtPersonsFullyVaccinated,
  	covid19.new_vaccine_doses_administered AS QtVaccineDosesAdministered,
  	covid19.new_tested AS QtTested,
  	covid19.new_recovered AS QtRecovered,
  	covid19.new_hospitalized_patients AS QtHospitalizedPatients,
  	covid19.new_intensive_care_patients AS QtIntensiveCarePatients,
  	covid19.new_confirmed_male AS QtConfirmedMale,
  	covid19.new_confirmed_female AS QtConfirmedFemale,
  	covid19.new_deceased_male AS QtDeceasedMale,
  	covid19.new_deceased_female AS QtDeceasedFemale,
  	covid19.new_tested_male AS QtTestedMale,
  	covid19.new_tested_female AS QtTestedFemale,
  	covid19.new_hospitalized_patients_male AS QtHospitalizedPatientsMale,
  	covid19.new_hospitalized_patients_female AS QtHospitalizedPatientsFemale,
  	covid19.new_intensive_care_patients_male AS QtIntensiveCarePatientsMale,
  	covid19.new_intensive_care_patients_female AS QtIntensiveCarePatientsFemale,
  	covid19.new_recovered_male AS QtRecoveredMale,
  	covid19.new_recovered_female AS QtRecoveredFemale,
  	covid19.new_ventilator_patients AS QtVentilatorPatients,
  	covid19.new_persons_fully_vaccinated_pfizer AS QtPersonsFullyVaccinatedPfizer,
  	covid19.new_vaccine_doses_administered_pfizer AS QtVaccineDosesAdministeredPfizer,
  	covid19.new_persons_fully_vaccinated_moderna AS QtPersonsFullyVaccinatedModerna,
  	covid19.new_vaccine_doses_administered_moderna AS QtVaccineDosesAdministeredModerna,
  	covid19.new_persons_fully_vaccinated_janssen AS QtPersonsFullyVaccinatedJanssen,
  	covid19.new_vaccine_doses_administered_janssen AS QtVaccineDosesAdministeredJanssen,
    covid19.current_hospitalized_patients AS QtCurrentHospitalizedPatients,
    covid19.current_intensive_care_patients AS QtCurrentIntensiveCarePatients,
    covid19.current_ventilator_patients AS QtCurrentVentilatorPatient
  FROM {{ ref('covid19_open_data') }} AS covid19
  JOIN {{ ref('dim_counties') }} AS counties
    ON covid19.subregion2_name = counties.DsCountyName
  JOIN {{ ref('dim_dates') }} AS dates
    ON covid19.date = dates.DsDate
