# Title: Fetch Core NHANES Data – National Health and Data Inquiry 2025
# Author: Sarina Etminan

# Description: We are working with the 2011-2012 cycle here

# Install necessary packages if needed
# install.packages("nhanesA")

# Include necessary libraries
library(nhanesA)
library(tidyverse)

# Helper function to fetch + save NHANES tables
fetch_and_save_nhanes <- function(code, filename) {
  df <- nhanes(code)
  
  if (is.null(df)) {
    message("⚠️ Failed to fetch: ", code)
    return(NULL)
  }
  
  write_csv(df, paste0("data/raw/", filename, ".csv"))
  message("✅ Saved: ", filename)
  return(df)
}

# 1. Demographics (age, sex, SES)
df_demo <- fetch_and_save_nhanes("DEMO_G", "nhanes_demographics_2011_2012")

# Optional preview
glimpse(df_demo)

# 2. Blood Pressure & Pulse (resting HR)
df_bp <- fetch_and_save_nhanes("BPX_G", "nhanes_bp_pulse_2011_2012")

# 3. Medical Conditions (disease status)
df_mcq <- fetch_and_save_nhanes("MCQ_G", "nhanes_med_conditions_2011_2012")

# 4. Diabetes status
df_diq <- fetch_and_save_nhanes("DIQ_G", "nhanes_diabetes_2011_2012")