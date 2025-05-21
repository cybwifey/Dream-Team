# Title: Clean NHANES XPT Files (Muscle Strength + Cardiovascular Fitness)
# Author: Sarina Etminan
# Description:
#   - Uses clean_xpt_data() to process downloaded NHANES XPT files
#   - Saves cleaned versions as CSVs in data/processed/

library(here)
library(haven)
library(janitor)
library(tidyverse)

# Define the cleaner function
clean_xpt_data <- function(file_path, drop_empty_rows = TRUE) {
  message("Reading XPT: ", file_path)

  df <- read_xpt(file_path)

  df <- df %>%
    janitor::clean_names() %>%
    select(where(~!all(is.na(.))))

  if (drop_empty_rows) {
    df <- df %>% filter(if_any(everything(), ~ !is.na(.)))
  }

  df <- df %>% mutate(across(where(is.character), str_trim))

  return(as.data.frame(df))
}

# File paths
raw_dir <- here("data/raw")
processed_dir <- here("data/processed")

# Ensure output directory exists
if (!dir.exists(processed_dir)) {
  dir.create(processed_dir, recursive = TRUE)
}

# Clean and save MSX (Muscle Strength)
msx_clean <- clean_xpt_data(file.path(raw_dir, "msx_muscle_strength.XPT"))
write_csv(msx_clean, file.path(processed_dir, "nhanes_muscle_strength_cleaned.csv"))

# Clean and save CVX (Cardiovascular Fitness)
cvx_clean <- clean_xpt_data(file.path(raw_dir, "cvx_cardio_fitness.XPT"))
write_csv(cvx_clean, file.path(processed_dir, "nhanes_cardiovascular_fitness_cleaned.csv"))

message("Muscle strength and cardio datasets cleaned and saved.")
