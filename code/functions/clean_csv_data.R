# Title: CSV Cleaning – National Health and Data Inquiry 2025
# Author: Sarina Etminan

# Description:
# Generic function that cleans untidy data:
#   - Reads a CSV
#   - Removes all empty columns
#   - Optionally drops rows with all NA
#   - Converts variable names to snake_case
#   - Standardizes all character encodings
#   - Handles common gotchas like weird spaces or missing headers


# Include necessary libraries
library(tidyverse)
library(janitor)

# Clean a raw CSV Dataset
clean_csv_data <- function(file_path, drop_empty_rows = TRUE) {
    # Read the CSV file
    df <- read_csv(file_path, show_col_types = FALSE)

    # Debugging message
    message("File loaded: ", file_path)

    # Clean coloums names
    df <- df %>%
      janitor::clean_names() %>%
      select(where(~!all(is.na(.))))

    # Drop rows where everything is NA
    if (drop_empty_rows) {
        df <- df %>% filter(if_any(everything(), ~ !is.na(.)))
    }

    # Trim white spaces in character coloumns
    df <- df %>% mutate(across(where(is.character), str_trim))

    return(as.data.frame(df)) # Returns a clean data frame
}