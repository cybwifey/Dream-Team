# Title: Fetch WHO Physical Inactivity Data – National Health and Data Inquiry 2025
# Author: Sarina Etminan
# Data/API: Prevalence of insufficient activity amoung +18 peoples (age standardized)

# Description:
# Uses the WHO GHO API to fetch country-level physical inactivity prevalence (adults)
# and saves the raw dataset to data/raw/who_inactivity.csv


# Load the reusable api template from the functions folder
source("code/functions/fetch_api_template.R") # libraries are included here already

# Build the URL properly
base_url <- "https://ghoapi.azureedge.net/api/GHO"
query <- "$filter=IndicatorCode eq 'NCD_PA_0000000001'"
full_url <- paste0(base_url, "?", URLencode(query, reserved = TRUE))

# Fetch the data
df_inactivity <- fetch_api_data(full_url)

# Save locally
write_csv(df_inactivity, "data/raw/who_inactivity.csv")