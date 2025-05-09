# Title: NHANES Flag Cleaner – National Health and Data Inquiry 2025
# Author: Sarina Etminan

# Description:
# Cleans all known malformed NHANES fields with unexpected labels or numeric strings.
# - Converts Yes/No/True/False to binary 1/0
# - Removes known label artifacts and numeric misclassifications
# - Forces all non-conforming values to NA

library(tidyverse)

clean_nhanes_flags <- function(df) {
  flagged_cols <- c(
  "diq175k", "diq175l", "diq175s", "diq175t",
  "mcq240v", "mcq240j", "mcq240k", "mcq240bb", "mcq240q",
  "mcq230b", "mcq230c", 
  "mcq240t"
)


  artifact_pattern <- "Bladder|Bone|Skin|Medication|Prostate|Non-melanoma|Gestational|Hypoglycemic|Extreme hunger|Frequent urination|Melanoma"

  df <- df %>%
    mutate(across(all_of(flagged_cols), ~ case_when(
      str_detect(., artifact_pattern)        ~ NA_character_,
      str_detect(., "^[0-9]+$")              ~ NA_character_,
      . %in% c("Yes", "TRUE", "True", "1")   ~ "1",
      . %in% c("No",