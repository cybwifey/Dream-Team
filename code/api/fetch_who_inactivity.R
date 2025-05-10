# Title: Fetch WHO Physical Inactivity Data – National Health and Data Inquiry 2025
# Author: Sarina Etminan
# Data/API: Prevalence of insufficient activity amoung +18 peoples (age standardized)

# Description:
# Uses the WHO GHO API to fetch country-level physical inactivity prevalence (adults)
# and saves the raw dataset to data/raw/who_inactivity.csv


# Install necessary packages and include needed library
# install.packages("rgho")
library(rgho)

# Retrieve all available indicators
indicators <- get_gho_indicators()

# Search for indicators related to physical inactivity
physical_inactivity_indicators <- indicators[grep("physical inactivity", indicators$Title, ignore.case = TRUE), ]
print(physical_inactivity_indicators)

# Replace 'NCD_PA_0000000001' with the actual indicator code identified
data <- get_gho_data(indicator = "NCD_PA_0000000001")

# View the first few rows of the data
head(data)
