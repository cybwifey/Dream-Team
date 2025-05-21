# Title: CSV Cleaning – National Health and Data Inquiry 2025
# Author: Sarina Etminan

# Description:
# Generic function to clean untidy data:
#   - Reads a CSV
#   - Removes empty columns
#   - Optionally drops rows with all NA
#   - Converts variable names to snake_case
#   - Standardizes encoding
#   - Trims whitespace from strings
#   - Alerts for common issues (e.g. missing headers, duplicates)

library(tidyverse)
library(janitor)

clean_csv_data <- function(file_path, drop_empty_rows = TRUE) {
    message("Reading: ", file_path)

    # Read file with encoding handling
    df <- read_csv(file_path, locale = locale(encoding = "UTF-8"), show_col_types = FALSE)

    # Clean and standardize column names
    df <- df %>%
      janitor::clean_names() %>%
      select(where(~!all(is.na(.))))  # Drop empty columns

    # Drop all-NA rows
    if (drop_empty_rows) {
        df <- df %>% filter(if_any(everything(), ~ !is.na(.)))
    }

    # Trim whitespace in character columns
    df <- df %>% mutate(across(where(is.character), str_trim))

    # Check for missing or duplicate column names
    if (anyDuplicated(names(df))) {
        warning("⚠️ Duplicate column names found.")
    }
    if (any(names(df) == "")) {
        warning("⚠️ Empty column headers found.")
    }

    return(as.data.frame(df))
}




# Batch of CSV cleaners

# Function to clean all CSVs in a raw folder and save them to a processed folder
clean_folder_csvs <- function(input_subdir = "data/raw", output_subdir = "data/processed") {
  # Build absolute paths using here()
  input_dir <- here::here(input_subdir)
  output_dir <- here::here(output_subdir)

  # Create output directory if it doesn't exist
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  # Get all CSV files in the input directory
  csv_files <- list.files(input_dir, pattern = "\\.csv$", full.names = TRUE)

  message("🧹 Cleaning ", length(csv_files), " file(s)...")

  # Iterate and clean each file
  for (file_path in csv_files) {
    cleaned_df <- clean_csv_data(file_path)
    file_name <- basename(file_path)
    output_path <- file.path(output_dir, file_name)

    # Save cleaned CSV
    write_csv(cleaned_df, output_path)
    message("✅ Cleaned and saved: ", output_path)
  }

  message("🎉 All files cleaned and saved to ", output_dir)
}