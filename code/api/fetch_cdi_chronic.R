# Title: CDC  Data – U.S. Chronic Disease Indicators 2015,2024
# Author: Andrei Sales
# Website link: https://data.cdc.gov/Chronic-Disease-Indicators/U-S-Chronic-Disease-Indicators/hksd-2xuw/about_data

# Description
# Used mofidied fetch_api_template to extract Socrata datasets from CDC databases
# Data features but is not limited to: chronic illnesses, location, sample size used for estimate

# Sample Size:  309,215 individual cases from 2015-2024

# Data Description	                             API Field Name
# Chronic Disease(e.g Diabetes, Cancer)          "topic"
# Stratification dim. (e.g. “AgeGroup65+”)       "stratificationcategory1"
# Stratification subgroup (e.g. “Female”)        "stratificationcategorydescription1"
# State or territory abbreviation                "locationabbr"	                    
#....


library(readr)
library(here)

library(httr)
setwd(here())



# Fetch the data (using the Socrata helper or your updated generic function)

url <- "https://data.cdc.gov/resource/hksd-2xuw.json" 
# Note: while liit set to 10,000:
# 309,215 individual cases in this api

df_cdi_chronic <- fetch_api_socrata(
  url,
  params = list("$limit" = 10000)
)

write_csv(df_cdi_chronic,  "data/raw/cdi_chronic_2015_2022.csv")
