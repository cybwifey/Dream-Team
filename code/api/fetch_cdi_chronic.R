# Title: CDI  Data – U.S. Chronic Disease Indicators 2015,2024
# Author: Andrei Sales
# Website link: https://data.cdc.gov/Chronic-Disease-Indicators/U-S-Chronic-Disease-Indicators/hksd-2xuw/about_data


library(httr)
library(jsonlite)
library(readr)
library(tidyverse)
library(here)


# Fetch the data (using the Socrata helper or your updated generic function)
source(here("code", "functions", "fetch_api_socrata.R"))  # Ensure fetcher function is loaded

url <- "https://data.cdc.gov/resource/hksd-2xuw.json" 

#309,215 individual cases in this api
message(" Downloading CDI chronic disease data...")
df_cdi_chronic <- fetch_api_socrata(
  url,
  params = list("$limit" = 10000)
)

output_path <- here("data", "raw", "cdi_chronic_2015_2022.csv")
write_csv(df_cdi_chronic, output_path)
message("Data saved to: ", output_path)