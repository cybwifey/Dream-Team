# Title: Run CSV Batch Cleaning
# Purpose: This script loads the CSV cleaning functions and runs them on all raw data files.

# Load required packages and functions
library(here)

# Source the cleaning function
source(here("code/functions/clean_csv_data.R"))

# Run the batch cleaner on raw folder
clean_folder_csvs(
  input_subdir = "data/raw",
  output_subdir = "data/processed"
)
