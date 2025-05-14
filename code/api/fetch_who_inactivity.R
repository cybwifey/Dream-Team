# Title: Fetch WHO Physical Inactivity Data – National Health and Data Inquiry 2025
# Author: Sarina Etminan
# Data/API: Prevalence of insufficient activity amoung +18 peoples (age standardized)

# Description:
# Uses the WHO GHO API to fetch country-level physical inactivity prevalence (adults)
# and saves the raw dataset to data/raw/who_inactivity.csv


# Install necessary packages and include needed library
# install.packages("rgho")
library(rgho)
library(httr)



# Step 1: Fetch the WHO GHO object
gho_obj <- get_gho_data(code = "NCD_PAA")


# Step 2: Convert to a regular data frame
df_inactivity <- as.data.frame(gho_obj)

# Step 3: Filter for Canada
df_canada <- subset(df_inactivity, Country == "Canada")

# Step 4: Get the most recent year
latest_year <- max(as.numeric(df_canada$Year), na.rm = TRUE)
df_latest <- subset(df_canada, Year == latest_year)

# Step 5: Save the result
write.csv(df_latest, "data/raw/who_inactivity_canada_latest.csv", row.names = FALSE)

# Optional: View the result
print(df_latest)
