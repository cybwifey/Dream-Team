# Script: extract_all_of_us_datasets.R
#
# Description:
# This script handles the automated extraction of all required datasets 
# from the All of Us Controlled Tier Dataset v8, using BigQuery via R.
# 
# The extraction pipeline:
#   - Runs SQL queries on BigQuery for multiple data domains (survey, person, Fitbit data, etc.)
#   - Exports queried data into Google Cloud Storage as CSV files
#   - Loads the exported CSV files into R dataframes for further preprocessing and modeling.
#
# Domains extracted:
#   - Survey responses
#   - Demographic info (person)
#   - Fitbit heart rate summary
#   - Fitbit heart rate minute level
#   - Fitbit activity summary
#   - Fitbit sleep level
#   - Fitbit sleep daily summary
#   - Fitbit device info
#   - Fitbit intraday steps
#
# Output:
# Cleaned R dataframes (one per domain) ready for downstream merging & preprocessing.
#
# Author: Sarina Etminan


library(tidyverse)
library(bigrquery)
library(lubridate)
library(glue)

#------------------------------------------
# GLOBAL ENVIRONMENT VARIABLES
#------------------------------------------

workspace_cdr <- Sys.getenv("WORKSPACE_CDR")
workspace_bucket <- Sys.getenv("WORKSPACE_BUCKET")
owner_email <- Sys.getenv("OWNER_EMAIL")
google_project <- Sys.getenv("GOOGLE_PROJECT")
export_date <- strftime(now(), "%Y%m%d")

#------------------------------------------
# GENERIC QUERY + EXPORT FUNCTION
#------------------------------------------

extract_and_export <- function(sql_query, export_name, col_types = NULL) {
  
  export_path <- file.path(
    workspace_bucket,
    "bq_exports",
    owner_email,
    export_date,
    export_name,
    paste0(export_name, "_*.csv")
  )
  
  message(glue('Exporting to {export_path}'))
  
  bq_table_save(
    bq_dataset_query(workspace_cdr, sql_query, billing = google_project),
    export_path,
    destination_format = "CSV"
  )
  
  return(export_path)
}

#------------------------------------------
# GENERIC IMPORT FUNCTION
#------------------------------------------

import_from_bucket <- function(export_path, col_types = NULL) {
  
  files <- system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE)
  
  bind_rows(map(files, function(file) {
    message(glue('Loading {file}'))
    read_csv(pipe(glue('gsutil cat {file}')), col_types = col_types, show_col_types = FALSE)
  }))
}

#------------------------------------------
# EXTRACTIONS START
#------------------------------------------

# 1️. Survey data
survey_sql <- "
    SELECT
        answer.person_id,
        answer.survey_datetime,
        answer.survey,
        answer.question_concept_id,
        answer.question,
        answer.answer_concept_id,
        answer.answer,
        answer.survey_version_concept_id,
        answer.survey_version_name   
    FROM
        `ds_survey` answer    
    WHERE
        (
            question_concept_id IN (
                SELECT DISTINCT concept_id
                FROM `cb_criteria` c
                JOIN (
                    SELECT CAST(cr.id as string) AS id
                    FROM `cb_criteria` cr
                    WHERE concept_id IN (1585710, 1586134)
                        AND domain_id = 'SURVEY'
                ) a ON (c.path like CONCAT('%', a.id, '.%'))
                WHERE domain_id = 'SURVEY' AND type = 'PPI' AND subtype = 'QUESTION'
            )
        )"

survey_path <- extract_and_export(survey_sql, "survey")
survey_df <- import_from_bucket(survey_path, 
                col_types = cols(
                    survey = col_character(), 
                    question = col_character(), 
                    answer = col_character(), 
                    survey_version_name = col_character()
                ))


# 2️. Person data
person_sql <- "
    SELECT
        person.person_id,
        person.gender_concept_id,
        p_gender_concept.concept_name as gender,
        person.birth_datetime as date_of_birth,
        person.race_concept_id,
        p_race_concept.concept_name as race,
        person.ethnicity_concept_id,
        p_ethnicity_concept.concept_name as ethnicity,
        person.sex_at_birth_concept_id,
        p_sex_at_birth_concept.concept_name as sex_at_birth,
        person.self_reported_category_concept_id,
        p_self_reported_category_concept.concept_name as self_reported_category  
    FROM
        `person` person  
    LEFT JOIN `concept` p_gender_concept ON person.gender_concept_id = p_gender_concept.concept_id  
    LEFT JOIN `concept` p_race_concept ON person.race_concept_id = p_race_concept.concept_id  
    LEFT JOIN `concept` p_ethnicity_concept ON person.ethnicity_concept_id = p_ethnicity_concept.concept_id  
    LEFT JOIN `concept` p_sex_at_birth_concept ON person.sex_at_birth_concept_id = p_sex_at_birth_concept.concept_id  
    LEFT JOIN `concept` p_self_reported_category_concept ON person.self_reported_category_concept_id = p_self_reported_category_concept.concept_id
"

person_path <- extract_and_export(person_sql, "person")
person_df <- import_from_bucket(person_path, 
                col_types = cols(
                    gender = col_character(),
                    race = col_character(),
                    ethnicity = col_character(),
                    sex_at_birth = col_character(),
                    self_reported_category = col_character()
                ))


# 3️. Fitbit Heart Rate Summary
fitbit_hr_summary_sql <- "
    SELECT
        heart_rate_summary.person_id,
        heart_rate_summary.date,
        heart_rate_summary.zone_name,
        heart_rate_summary.min_heart_rate,
        heart_rate_summary.max_heart_rate,
        heart_rate_summary.minute_in_zone,
        heart_rate_summary.calorie_count  
    FROM
        `heart_rate_summary` heart_rate_summary 
"
hr_summary_path <- extract_and_export(fitbit_hr_summary_sql, "fitbit_heart_rate_summary")
fitbit_heart_rate_summary_df <- import_from_bucket(hr_summary_path, col_types = cols(zone_name = col_character()))


# 4️. Fitbit Heart Rate Level (minute level)
fitbit_hr_level_sql <- "
    SELECT
        heart_rate_minute_level.person_id,
        CAST(heart_rate_minute_level.datetime AS DATE) as date,
        AVG(heart_rate_value) as avg_rate  
    FROM
        `heart_rate_minute_level` heart_rate_minute_level   
    GROUP BY
        person_id, date
"
hr_level_path <- extract_and_export(fitbit_hr_level_sql, "fitbit_heart_rate_level")
fitbit_heart_rate_level_df <- import_from_bucket(hr_level_path)


# 5️. Fitbit Activity Summary
fitbit_activity_sql <- "
    SELECT
        activity_summary.person_id,
        activity_summary.date,
        activity_summary.activity_calories,
        activity_summary.calories_bmr,
        activity_summary.calories_out,
        activity_summary.elevation,
        activity_summary.fairly_active_minutes,
        activity_summary.floors,
        activity_summary.lightly_active_minutes,
        activity_summary.marginal_calories,
        activity_summary.sedentary_minutes,
        activity_summary.steps,
        activity_summary.very_active_minutes  
    FROM
        `activity_summary` activity_summary 
"
activity_path <- extract_and_export(fitbit_activity_sql, "fitbit_activity")
fitbit_activity_df <- import_from_bucket(activity_path)


# 6️. Fitbit Sleep Level
fitbit_sleep_level_sql <- "
    SELECT
        sleep_level.person_id,
        sleep_level.sleep_date,
        sleep_level.is_main_sleep,
        sleep_level.level,
        CAST(sleep_level.start_datetime AS DATE) as date,
        sleep_level.duration_in_min  
    FROM
        `sleep_level` sleep_level 
"
sleep_level_path <- extract_and_export(fitbit_sleep_level_sql, "fitbit_sleep_level")
fitbit_sleep_level_df <- import_from_bucket(sleep_level_path, 
                  col_types = cols(
                    is_main_sleep = col_character(),
                    level = col_character()
                  ))


# 7️. Fitbit Sleep Daily Summary
fitbit_sleep_daily_sql <- "
    SELECT
        sleep_daily_summary.person_id,
        sleep_daily_summary.sleep_date,
        sleep_daily_summary.is_main_sleep,
        sleep_daily_summary.minute_in_bed,
        sleep_daily_summary.minute_asleep,
        sleep_daily_summary.minute_after_wakeup,
        sleep_daily_summary.minute_awake,
        sleep_daily_summary.minute_restless,
        sleep_daily_summary.minute_deep,
        sleep_daily_summary.minute_light,
        sleep_daily_summary.minute_rem,
        sleep_daily_summary.minute_wake  
    FROM
        `sleep_daily_summary` sleep_daily_summary 
"
sleep_daily_path <- extract_and_export(fitbit_sleep_daily_sql, "fitbit_sleep_daily_summary")
fitbit_sleep_daily_summary_df <- import_from_bucket(sleep_daily_path, 
                  col_types = cols(is_main_sleep = col_character()))


# 8️. Fitbit Device Info
fitbit_device_sql <- "
    SELECT
        device.person_id,
        device.device_id,
        device.device_date,
        device.battery,
        device.battery_level,
        device.device_version,
        device.device_type,
        CAST(device.last_sync_time AS DATE) as last_sync_time,
        device.src_id  
    FROM
        `device` device 
"
device_path <- extract_and_export(fitbit_device_sql, "fitbit_device")
fitbit_device_df <- import_from_bucket(device_path, 
                  col_types = cols(
                    device_id = col_character(),
                    battery = col_character(),
                    battery_level = col_character(),
                    device_version = col_character(),
                    device_type = col_character(),
                    src_id = col_character()
                  ))


# 9️. Fitbit Intraday Steps
fitbit_intraday_steps_sql <- "
    SELECT
        steps_intraday.person_id,
        CAST(steps_intraday.datetime AS DATE) as date,
        SUM(CAST(steps_intraday.steps AS INT64)) as sum_steps  
    FROM
        `steps_intraday` steps_intraday   
    GROUP BY
        person_id, date
"
intraday_steps_path <- extract_and_export(fitbit_intraday_steps_sql, "fitbit_intraday_steps")
fitbit_intraday_steps_df <- import_from_bucket(intraday_steps_path)
