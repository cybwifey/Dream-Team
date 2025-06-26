# Script: extract_aou_bigquery_filtered.R
#
# Description:
# This script handles the automated extraction of all required datasets 
# from the All of Us Controlled Tier Dataset v8, using BigQuery via R.
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
# Author: Adrian, Andrei, Sarina, AOU

library(tidyverse)
library(bigrquery)

# This query represents dataset "Final Dataset" for domain "measurement" and was generated for All of Us Controlled Tier Dataset v8
dataset_91252870_measurement_sql <- paste("
    SELECT
        measurement.person_id,
        measurement.measurement_concept_id,
        m_standard_concept.concept_name as standard_concept_name,
        m_standard_concept.concept_code as standard_concept_code,
        m_standard_concept.vocabulary_id as standard_vocabulary,
        measurement.measurement_datetime,
        measurement.measurement_type_concept_id,
        m_type.concept_name as measurement_type_concept_name,
        measurement.operator_concept_id,
        m_operator.concept_name as operator_concept_name,
        measurement.value_as_number,
        measurement.value_as_concept_id,
        m_value.concept_name as value_as_concept_name,
        measurement.unit_concept_id,
        m_unit.concept_name as unit_concept_name,
        measurement.range_low,
        measurement.range_high,
        measurement.visit_occurrence_id,
        m_visit.concept_name as visit_occurrence_concept_name,
        measurement.measurement_source_value,
        measurement.measurement_source_concept_id,
        m_source_concept.concept_name as source_concept_name,
        m_source_concept.concept_code as source_concept_code,
        m_source_concept.vocabulary_id as source_vocabulary,
        measurement.unit_source_value,
        measurement.value_source_value 
    FROM
        ( SELECT
            * 
        FROM
            `measurement` measurement 
        WHERE
            (
                measurement_concept_id IN (SELECT
                    DISTINCT c.concept_id 
                FROM
                    `cb_criteria` c 
                JOIN
                    (SELECT
                        CAST(cr.id as string) AS id       
                    FROM
                        `cb_criteria` cr       
                    WHERE
                        concept_id IN (3004249, 3012888, 3025315, 3038553)       
                        AND full_text LIKE '%_rank1]%'      ) a 
                        ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                        OR c.path LIKE CONCAT('%.', a.id) 
                        OR c.path LIKE CONCAT(a.id, '.%') 
                        OR c.path = a.id) 
                WHERE
                    is_standard = 1 
                    AND is_selectable = 1)
            )  
            AND (
                measurement.PERSON_ID IN (SELECT
                    distinct person_id  
                FROM
                    `cb_search_person` cb_search_person  
                WHERE
                    cb_search_person.person_id IN (SELECT
                        person_id 
                    FROM
                        `cb_search_person` p 
                    WHERE
                        DATE_DIFF(CURRENT_DATE, dob, YEAR) - IF(EXTRACT(MONTH FROM dob)*100 + EXTRACT(DAY FROM dob) > EXTRACT(MONTH FROM CURRENT_DATE)*100 + EXTRACT(DAY FROM CURRENT_DATE), 1, 0) BETWEEN 65 AND 125 
                        AND NOT EXISTS (      SELECT
                            'x'      
                        FROM
                            `death` d      
                        WHERE
                            d.person_id = p.person_id ) ) 
                    AND cb_search_person.person_id IN (SELECT
                        criteria.person_id 
                    FROM
                        (SELECT
                            DISTINCT person_id, entry_date, concept_id 
                        FROM
                            `cb_search_all_events` 
                        WHERE
                            (concept_id IN(SELECT
                                DISTINCT c.concept_id 
                            FROM
                                `cb_criteria` c 
                            JOIN
                                (SELECT
                                    CAST(cr.id as string) AS id       
                                FROM
                                    `cb_criteria` cr       
                                WHERE
                                    concept_id IN (80502, 316139, 4140090, 4182210)       
                                    AND full_text LIKE '%_rank1]%'      ) a 
                                    ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                                    OR c.path LIKE CONCAT('%.', a.id) 
                                    OR c.path LIKE CONCAT(a.id, '.%') 
                                    OR c.path = a.id) 
                            WHERE
                                is_standard = 1 
                                AND is_selectable = 1) 
                            AND is_standard = 1 )) criteria 
                    UNION
                    DISTINCT SELECT
                        criteria.person_id 
                    FROM
                        (SELECT
                            DISTINCT person_id, entry_date, concept_id 
                        FROM
                            `cb_search_all_events` 
                        WHERE
                            (concept_id IN(SELECT
                                DISTINCT c.concept_id 
                            FROM
                                `cb_criteria` c 
                            JOIN
                                (SELECT
                                    CAST(cr.id as string) AS id       
                                FROM
                                    `cb_criteria` cr       
                                WHERE
                                    concept_id IN (44782432, 201820, 4218017)       
                                    AND full_text LIKE '%_rank1]%'      ) a 
                                    ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                                    OR c.path LIKE CONCAT('%.', a.id) 
                                    OR c.path LIKE CONCAT(a.id, '.%') 
                                    OR c.path = a.id) 
                            WHERE
                                is_standard = 1 
                                AND is_selectable = 1) 
                            AND is_standard = 1 )) criteria ) )
                )
            ) measurement 
        LEFT JOIN
            `concept` m_standard_concept 
                ON measurement.measurement_concept_id = m_standard_concept.concept_id 
        LEFT JOIN
            `concept` m_type 
                ON measurement.measurement_type_concept_id = m_type.concept_id 
        LEFT JOIN
            `concept` m_operator 
                ON measurement.operator_concept_id = m_operator.concept_id 
        LEFT JOIN
            `concept` m_value 
                ON measurement.value_as_concept_id = m_value.concept_id 
        LEFT JOIN
            `concept` m_unit 
                ON measurement.unit_concept_id = m_unit.concept_id 
        LEFT JOIn
            `visit_occurrence` v 
                ON measurement.visit_occurrence_id = v.visit_occurrence_id 
        LEFT JOIN
            `concept` m_visit 
                ON v.visit_concept_id = m_visit.concept_id 
        LEFT JOIN
            `concept` m_source_concept 
                ON measurement.measurement_source_concept_id = m_source_concept.concept_id", sep="")

# Formulate a Cloud Storage destination path for the data exported from BigQuery.
# NOTE: By default data exported multiple times on the same day will overwrite older copies.
#       But data exported on a different days will write to a new location so that historical
#       copies can be kept as the dataset definition is changed.
measurement_91252870_path <- file.path(
  Sys.getenv("WORKSPACE_BUCKET"),
  "bq_exports",
  Sys.getenv("OWNER_EMAIL"),
  strftime(lubridate::now(), "%Y%m%d"),  # Comment out this line if you want the export to always overwrite.
  "measurement_91252870",
  "measurement_91252870_*.csv")
message(str_glue('The data will be written to {measurement_91252870_path}. Use this path when reading ',
                 'the data into your notebooks in the future.'))

# Perform the query and export the dataset to Cloud Storage as CSV files.
# NOTE: You only need to run `bq_table_save` once. After that, you can
#       just read data from the CSVs in Cloud Storage.
bq_table_save(
  bq_dataset_query(Sys.getenv("WORKSPACE_CDR"), dataset_91252870_measurement_sql, billing = Sys.getenv("GOOGLE_PROJECT")),
  measurement_91252870_path,
  destination_format = "CSV")
# Read the data directly from Cloud Storage into memory.
# NOTE: Alternatively you can `gsutil -m cp {measurement_91252870_path}` to copy these files
#       to the Jupyter disk.
read_bq_export_from_workspace_bucket <- function(export_path) {
  col_types <- cols(standard_concept_name = col_character(), standard_concept_code = col_character(), standard_vocabulary = col_character(), measurement_type_concept_name = col_character(), operator_concept_name = col_character(), value_as_concept_name = col_character(), unit_concept_name = col_character(), visit_occurrence_concept_name = col_character(), measurement_source_value = col_character(), source_concept_name = col_character(), source_concept_code = col_character(), source_vocabulary = col_character(), unit_source_value = col_character(), value_source_value = col_character())
  bind_rows(
    map(system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE),
        function(csv) {
          message(str_glue('Loading {csv}.'))
          chunk <- read_csv(pipe(str_glue('gsutil cat {csv}')), col_types = col_types, show_col_types = FALSE)
          if (is.null(col_types)) {
            col_types <- spec(chunk)
          }
          chunk
        }))
}
dataset_91252870_measurement_df <- read_bq_export_from_workspace_bucket(measurement_91252870_path)

dim(dataset_91252870_measurement_df)

head(dataset_91252870_measurement_df, 5)
library(tidyverse)
library(bigrquery)

# This query represents dataset "Final Dataset" for domain "fitbit_heart_rate_summary" and was generated for All of Us Controlled Tier Dataset v8
dataset_91252870_fitbit_heart_rate_summary_sql <- paste("
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
    WHERE
        heart_rate_summary.PERSON_ID IN (SELECT
            distinct person_id  
        FROM
            `cb_search_person` cb_search_person  
        WHERE
            cb_search_person.person_id IN (SELECT
                person_id 
            FROM
                `cb_search_person` p 
            WHERE
                DATE_DIFF(CURRENT_DATE, dob, YEAR) - IF(EXTRACT(MONTH FROM dob)*100 + EXTRACT(DAY FROM dob) > EXTRACT(MONTH FROM CURRENT_DATE)*100 + EXTRACT(DAY FROM CURRENT_DATE), 1, 0) BETWEEN 65 AND 125 
                AND NOT EXISTS (      SELECT
                    'x'      
                FROM
                    `death` d      
                WHERE
                    d.person_id = p.person_id ) ) 
            AND cb_search_person.person_id IN (SELECT
                criteria.person_id 
            FROM
                (SELECT
                    DISTINCT person_id, entry_date, concept_id 
                FROM
                    `cb_search_all_events` 
                WHERE
                    (concept_id IN(SELECT
                        DISTINCT c.concept_id 
                    FROM
                        `cb_criteria` c 
                    JOIN
                        (SELECT
                            CAST(cr.id as string) AS id       
                        FROM
                            `cb_criteria` cr       
                        WHERE
                            concept_id IN (80502, 316139, 4140090, 4182210)       
                            AND full_text LIKE '%_rank1]%'      ) a 
                            ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                            OR c.path LIKE CONCAT('%.', a.id) 
                            OR c.path LIKE CONCAT(a.id, '.%') 
                            OR c.path = a.id) 
                    WHERE
                        is_standard = 1 
                        AND is_selectable = 1) 
                    AND is_standard = 1 )) criteria 
            UNION
            DISTINCT SELECT
                criteria.person_id 
            FROM
                (SELECT
                    DISTINCT person_id, entry_date, concept_id 
                FROM
                    `cb_search_all_events` 
                WHERE
                    (concept_id IN(SELECT
                        DISTINCT c.concept_id 
                    FROM
                        `cb_criteria` c 
                    JOIN
                        (SELECT
                            CAST(cr.id as string) AS id       
                        FROM
                            `cb_criteria` cr       
                        WHERE
                            concept_id IN (44782432, 201820, 4218017)       
                            AND full_text LIKE '%_rank1]%'      ) a 
                            ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                            OR c.path LIKE CONCAT('%.', a.id) 
                            OR c.path LIKE CONCAT(a.id, '.%') 
                            OR c.path = a.id) 
                    WHERE
                        is_standard = 1 
                        AND is_selectable = 1) 
                    AND is_standard = 1 )) criteria ) )", sep="")

# Formulate a Cloud Storage destination path for the data exported from BigQuery.
# NOTE: By default data exported multiple times on the same day will overwrite older copies.
#       But data exported on a different days will write to a new location so that historical
#       copies can be kept as the dataset definition is changed.
fitbit_heart_rate_summary_91252870_path <- file.path(
  Sys.getenv("WORKSPACE_BUCKET"),
  "bq_exports",
  Sys.getenv("OWNER_EMAIL"),
  strftime(lubridate::now(), "%Y%m%d"),  # Comment out this line if you want the export to always overwrite.
  "fitbit_heart_rate_summary_91252870",
  "fitbit_heart_rate_summary_91252870_*.csv")
message(str_glue('The data will be written to {fitbit_heart_rate_summary_91252870_path}. Use this path when reading ',
                 'the data into your notebooks in the future.'))

# Perform the query and export the dataset to Cloud Storage as CSV files.
# NOTE: You only need to run `bq_table_save` once. After that, you can
#       just read data from the CSVs in Cloud Storage.
bq_table_save(
  bq_dataset_query(Sys.getenv("WORKSPACE_CDR"), dataset_91252870_fitbit_heart_rate_summary_sql, billing = Sys.getenv("GOOGLE_PROJECT")),
  fitbit_heart_rate_summary_91252870_path,
  destination_format = "CSV")
# Read the data directly from Cloud Storage into memory.
# NOTE: Alternatively you can `gsutil -m cp {fitbit_heart_rate_summary_91252870_path}` to copy these files
#       to the Jupyter disk.
read_bq_export_from_workspace_bucket <- function(export_path) {
  col_types <- cols(zone_name = col_character())
  bind_rows(
    map(system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE),
        function(csv) {
          message(str_glue('Loading {csv}.'))
          chunk <- read_csv(pipe(str_glue('gsutil cat {csv}')), col_types = col_types, show_col_types = FALSE)
          if (is.null(col_types)) {
            col_types <- spec(chunk)
          }
          chunk
        }))
}
dataset_91252870_fitbit_heart_rate_summary_df <- read_bq_export_from_workspace_bucket(fitbit_heart_rate_summary_91252870_path)

dim(dataset_91252870_fitbit_heart_rate_summary_df)

head(dataset_91252870_fitbit_heart_rate_summary_df, 5)
library(tidyverse)
library(bigrquery)

# This query represents dataset "Final Dataset" for domain "fitbit_activity" and was generated for All of Us Controlled Tier Dataset v8
dataset_91252870_fitbit_activity_sql <- paste("
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
    WHERE
        activity_summary.PERSON_ID IN (SELECT
            distinct person_id  
        FROM
            `cb_search_person` cb_search_person  
        WHERE
            cb_search_person.person_id IN (SELECT
                person_id 
            FROM
                `cb_search_person` p 
            WHERE
                DATE_DIFF(CURRENT_DATE, dob, YEAR) - IF(EXTRACT(MONTH FROM dob)*100 + EXTRACT(DAY FROM dob) > EXTRACT(MONTH FROM CURRENT_DATE)*100 + EXTRACT(DAY FROM CURRENT_DATE), 1, 0) BETWEEN 65 AND 125 
                AND NOT EXISTS (      SELECT
                    'x'      
                FROM
                    `death` d      
                WHERE
                    d.person_id = p.person_id ) ) 
            AND cb_search_person.person_id IN (SELECT
                criteria.person_id 
            FROM
                (SELECT
                    DISTINCT person_id, entry_date, concept_id 
                FROM
                    `cb_search_all_events` 
                WHERE
                    (concept_id IN(SELECT
                        DISTINCT c.concept_id 
                    FROM
                        `cb_criteria` c 
                    JOIN
                        (SELECT
                            CAST(cr.id as string) AS id       
                        FROM
                            `cb_criteria` cr       
                        WHERE
                            concept_id IN (80502, 316139, 4140090, 4182210)       
                            AND full_text LIKE '%_rank1]%'      ) a 
                            ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                            OR c.path LIKE CONCAT('%.', a.id) 
                            OR c.path LIKE CONCAT(a.id, '.%') 
                            OR c.path = a.id) 
                    WHERE
                        is_standard = 1 
                        AND is_selectable = 1) 
                    AND is_standard = 1 )) criteria 
            UNION
            DISTINCT SELECT
                criteria.person_id 
            FROM
                (SELECT
                    DISTINCT person_id, entry_date, concept_id 
                FROM
                    `cb_search_all_events` 
                WHERE
                    (concept_id IN(SELECT
                        DISTINCT c.concept_id 
                    FROM
                        `cb_criteria` c 
                    JOIN
                        (SELECT
                            CAST(cr.id as string) AS id       
                        FROM
                            `cb_criteria` cr       
                        WHERE
                            concept_id IN (44782432, 201820, 4218017)       
                            AND full_text LIKE '%_rank1]%'      ) a 
                            ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                            OR c.path LIKE CONCAT('%.', a.id) 
                            OR c.path LIKE CONCAT(a.id, '.%') 
                            OR c.path = a.id) 
                    WHERE
                        is_standard = 1 
                        AND is_selectable = 1) 
                    AND is_standard = 1 )) criteria ) )", sep="")

# Formulate a Cloud Storage destination path for the data exported from BigQuery.
# NOTE: By default data exported multiple times on the same day will overwrite older copies.
#       But data exported on a different days will write to a new location so that historical
#       copies can be kept as the dataset definition is changed.
fitbit_activity_91252870_path <- file.path(
  Sys.getenv("WORKSPACE_BUCKET"),
  "bq_exports",
  Sys.getenv("OWNER_EMAIL"),
  strftime(lubridate::now(), "%Y%m%d"),  # Comment out this line if you want the export to always overwrite.
  "fitbit_activity_91252870",
  "fitbit_activity_91252870_*.csv")
message(str_glue('The data will be written to {fitbit_activity_91252870_path}. Use this path when reading ',
                 'the data into your notebooks in the future.'))

# Perform the query and export the dataset to Cloud Storage as CSV files.
# NOTE: You only need to run `bq_table_save` once. After that, you can
#       just read data from the CSVs in Cloud Storage.
bq_table_save(
  bq_dataset_query(Sys.getenv("WORKSPACE_CDR"), dataset_91252870_fitbit_activity_sql, billing = Sys.getenv("GOOGLE_PROJECT")),
  fitbit_activity_91252870_path,
  destination_format = "CSV")
# Read the data directly from Cloud Storage into memory.
# NOTE: Alternatively you can `gsutil -m cp {fitbit_activity_91252870_path}` to copy these files
#       to the Jupyter disk.
read_bq_export_from_workspace_bucket <- function(export_path) {
  col_types <- NULL
  bind_rows(
    map(system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE),
        function(csv) {
          message(str_glue('Loading {csv}.'))
          chunk <- read_csv(pipe(str_glue('gsutil cat {csv}')), col_types = col_types, show_col_types = FALSE)
          if (is.null(col_types)) {
            col_types <- spec(chunk)
          }
          chunk
        }))
}
dataset_91252870_fitbit_activity_df <- read_bq_export_from_workspace_bucket(fitbit_activity_91252870_path)

dim(dataset_91252870_fitbit_activity_df)

head(dataset_91252870_fitbit_activity_df, 5)
library(tidyverse)
library(bigrquery)

# This query represents dataset "Final Dataset" for domain "fitbit_sleep_daily_summary" and was generated for All of Us Controlled Tier Dataset v8
dataset_91252870_fitbit_sleep_daily_summary_sql <- paste("
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
    WHERE
        PERSON_ID IN (SELECT
            distinct person_id  
        FROM
            `cb_search_person` cb_search_person  
        WHERE
            cb_search_person.person_id IN (SELECT
                person_id 
            FROM
                `cb_search_person` p 
            WHERE
                DATE_DIFF(CURRENT_DATE, dob, YEAR) - IF(EXTRACT(MONTH FROM dob)*100 + EXTRACT(DAY FROM dob) > EXTRACT(MONTH FROM CURRENT_DATE)*100 + EXTRACT(DAY FROM CURRENT_DATE), 1, 0) BETWEEN 65 AND 125 
                AND NOT EXISTS (      SELECT
                    'x'      
                FROM
                    `death` d      
                WHERE
                    d.person_id = p.person_id ) ) 
            AND cb_search_person.person_id IN (SELECT
                criteria.person_id 
            FROM
                (SELECT
                    DISTINCT person_id, entry_date, concept_id 
                FROM
                    `cb_search_all_events` 
                WHERE
                    (concept_id IN(SELECT
                        DISTINCT c.concept_id 
                    FROM
                        `cb_criteria` c 
                    JOIN
                        (SELECT
                            CAST(cr.id as string) AS id       
                        FROM
                            `cb_criteria` cr       
                        WHERE
                            concept_id IN (80502, 316139, 4140090, 4182210)       
                            AND full_text LIKE '%_rank1]%'      ) a 
                            ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                            OR c.path LIKE CONCAT('%.', a.id) 
                            OR c.path LIKE CONCAT(a.id, '.%') 
                            OR c.path = a.id) 
                    WHERE
                        is_standard = 1 
                        AND is_selectable = 1) 
                    AND is_standard = 1 )) criteria 
            UNION
            DISTINCT SELECT
                criteria.person_id 
            FROM
                (SELECT
                    DISTINCT person_id, entry_date, concept_id 
                FROM
                    `cb_search_all_events` 
                WHERE
                    (concept_id IN(SELECT
                        DISTINCT c.concept_id 
                    FROM
                        `cb_criteria` c 
                    JOIN
                        (SELECT
                            CAST(cr.id as string) AS id       
                        FROM
                            `cb_criteria` cr       
                        WHERE
                            concept_id IN (44782432, 201820, 4218017)       
                            AND full_text LIKE '%_rank1]%'      ) a 
                            ON (c.path LIKE CONCAT('%.', a.id, '.%') 
                            OR c.path LIKE CONCAT('%.', a.id) 
                            OR c.path LIKE CONCAT(a.id, '.%') 
                            OR c.path = a.id) 
                    WHERE
                        is_standard = 1 
                        AND is_selectable = 1) 
                    AND is_standard = 1 )) criteria ) )", sep="")

# Formulate a Cloud Storage destination path for the data exported from BigQuery.
# NOTE: By default data exported multiple times on the same day will overwrite older copies.
#       But data exported on a different days will write to a new location so that historical
#       copies can be kept as the dataset definition is changed.
fitbit_sleep_daily_summary_91252870_path <- file.path(
  Sys.getenv("WORKSPACE_BUCKET"),
  "bq_exports",
  Sys.getenv("OWNER_EMAIL"),
  strftime(lubridate::now(), "%Y%m%d"),  # Comment out this line if you want the export to always overwrite.
  "fitbit_sleep_daily_summary_91252870",
  "fitbit_sleep_daily_summary_91252870_*.csv")
message(str_glue('The data will be written to {fitbit_sleep_daily_summary_91252870_path}. Use this path when reading ',
                 'the data into your notebooks in the future.'))

# Perform the query and export the dataset to Cloud Storage as CSV files.
# NOTE: You only need to run `bq_table_save` once. After that, you can
#       just read data from the CSVs in Cloud Storage.
bq_table_save(
  bq_dataset_query(Sys.getenv("WORKSPACE_CDR"), dataset_91252870_fitbit_sleep_daily_summary_sql, billing = Sys.getenv("GOOGLE_PROJECT")),
  fitbit_sleep_daily_summary_91252870_path,
  destination_format = "CSV")
# Read the data directly from Cloud Storage into memory.
# NOTE: Alternatively you can `gsutil -m cp {fitbit_sleep_daily_summary_91252870_path}` to copy these files
#       to the Jupyter disk.
read_bq_export_from_workspace_bucket <- function(export_path) {
  col_types <- cols(is_main_sleep = col_character())
  bind_rows(
    map(system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE),
        function(csv) {
          message(str_glue('Loading {csv}.'))
          chunk <- read_csv(pipe(str_glue('gsutil cat {csv}')), col_types = col_types, show_col_types = FALSE)
          if (is.null(col_types)) {
            col_types <- spec(chunk)
          }
          chunk
        }))
}
dataset_91252870_fitbit_sleep_daily_summary_df <- read_bq_export_from_workspace_bucket(fitbit_sleep_daily_summary_91252870_path)


library(dplyr)

df_clean <- dataset_91252870_fitbit_heart_rate_summary_df %>% drop_na()

df_clean <- dataset_91252870_fitbit_heart_rate_summary_df %>% drop_na(minute_in_zone, calorie_count)

cleaned <- dataset_91252870_fitbit_heart_rate_summary_df %>%
  group_by(person_id) %>%
  summarise(
    avg_min_heart_rate = mean(min_heart_rate),
    avg_max_heart_rate = mean(max_heart_rate),
    avg_minutes = mean(minute_in_zone),
    avg_calories = mean(calorie_count)
  )

head(cleaned)
head(dataset_91252870_fitbit_sleep_daily_summary_df)

aou_bucket_to_workspace("bq_exports/adriankwan@researchallofus.org/20250624/fitbit_heart_rate_summary_91252870/fitbit_heart_rate_summary_91252870_000000000009.csv")
fitbit_heartrate <- read.csv("fitbit_heart_rate_summary_91252870_000000000009.csv")

library(dplyr)

df_cleaned_avg <- test %>%
  group_by(person_id) %>%
  summarise(across(where(is.numeric), ~mean(.x, na.rm = TRUE)))
