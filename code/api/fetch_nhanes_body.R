# Title: NHANES Data – National Health and Data Inquiry 2025
# Author: Sarina Etminan
# Website link: https://wwwn.cdc.gov/nchs/nhanes/default.aspx

# Description:
# Using the nhanesA package to pull data from CDC's NHANES portal
# Pulls Body measurements

# Data Description	                    File Code for nhanes()
# Balance	                            "BAX_L"
# Blood Pressure - Oscillometric	    "BPXO_L"
# Body Measures (includes BMI, etc.)	"BMX_L"
# Liver Ultrasound	                    "LUX_L"



# Install the necessary package if needed:
# install.packages("nhanesA")

# Necessary libraries
library(nhanesA)
library(tidyverse)

# Load body measurement data
df_body <- nhanes("BMX_L")

# This dataset usually contains:
    # BMXWT: Body weight
    # BMXHT: Height
    # BMXBMI: Calculated BMI
    # BMXWAIST: Waist circumference
    # SEQN: Participant ID

# Preview this data
glimpse(df_body)

# Save raw data to folder
write_csv(df_body, "data/raw/nhanes_body