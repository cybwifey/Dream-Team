# Title: CDI  Data – U.S. Chronic Disease Indicators 2015,2024
# Author: Andrei Sales
# Website link: https://data.cdc.gov/Chronic-Disease-Indicators/U-S-Chronic-Disease-Indicators/hksd-2xuw/about_data


library(readr)
library(here)

library(httr)
setwd(here())



# Fetch the data (using the Socrata helper or your updated generic function)

url <- "https://data.cdc.gov/resource/hksd-2xuw.json" 

#309,215 individual cases in this api
df_cdi_chronic <- fetch_api_socrata(
  url,
  params = list("$limit" = 10000)
)

write_csv(df_cdi_chronic,  "data/raw/cdi_chronic_2015_2022.csv")