# Title: Merge NHANES Core Data – National Health and Data Inquiry 2025
# Author: Sarina Etminan

# Description:
# This script loads, cleans, and merges core NHANES datasets pulled from the 2011–2012 cycle:
# - Demographics (DEMO_G)
# - Blood Pressure & Pulse (BPX_G)
# - Medical Conditions Questionnaire (MCQ_G)
# - Diabetes Questionnaire (DIQ_G)
# The result is a unified dataset joined by SEQN and saved to data/processed/.

# Load required libraries
library(tidyverse)
library(janitor)

# Load CSV cleaning function
source("code/functions/clean_csv_data.R")

# Define file paths
paths <- list(
  demo = "data/raw/nhanes_demographics_2011_2012.csv",
  bp   = "data/raw/nhanes_bp_pulse_2011_2012.csv",
  mcq  = "data/raw/nhanes_med_conditions_2011_2012.csv",
  diq  = "data/raw/nhanes_diabetes_2011_2012.csv"
)

# Clean each dataset
df_demo <- clean_csv_data(paths$demo)
df_bp   <- clean_csv_data(paths$bp)
df_mcq  <- clean_csv_data(paths$mcq)
df_diq  <- clean_csv_data(paths$diq)

# Merge datasets by SEQN (full join preserves rows across all tables)
merged_df <- df_demo %>%
  full_join(df_bp,  by = "seqn") %>%
  full_join(df_mcq, by = "seqn") %>%
  full_join(df_diq, by = "seqn")


# Clean NHANES label artifacts
source("code/functions/clean_nhanes_flags.R")
merged_df <- clean_nhanes_flags(merged_df)
write_csv(merged_df, "data/processed/nhanes_core_merged_201