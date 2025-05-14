# Title: Fetch WHO Physical Inactivity Data – National Health and Data Inquiry 2025
# Author: Sarina Etminan + Andrei Sales
# Data/API: Prevalence of insufficient activity amoung +18 peoples (age standardized)

# Description:
# Uses the WHO GHO API to fetch country-level physical inactivity prevalence (adults)
# and saves the raw dataset to data/raw/who_inactivity.csv


# Install necessary packages and include needed library
# install.packages("rgho")
library(rgho)
library(httr)
library(dplyr)



# Step 1: Fetch the WHO GHO object
codes<- get_gho_values(dimension ="GHO")
inactivity <- codes |> filter(grepl("insufficient physical activity", Title, ignore.case=TRUE))

code1 <- inactivity$Code[1]






# Step 2: Fetch all countries
df_all <- get_gho_data( code =code1) |> as.data.frame() |> mutate( YEAR= as.integer(YEAR), Value =ifelse(grepl("^[0-9.]+$", Value), as.numeric(Value),  NA_real_))
 
# gho_data contained non-numerics and other unexplained values; hence ("^[0-9.]+$")



# Step 3: Save the result
write.csv(df_all, "data/raw/who_inactivity_canada_latest.csv", row.names = FALSE)

# Optional: View the result
#print(df_all)
