# Title: Import and Process NHANES Fitness Data (Muscle Strength + VO₂ Max)
# Author: Sarina Etminan
# Project: National Health and Data Inquiry 2025
# Description:
#   - Loads and cleans NHANES XPT files for muscle strength and cardiovascular fitness
#   - Outputs processed CSVs for downstream modeling

# Website: https://wwwn.cdc.gov/Nchs/Nhanes/Search/DataPage.aspx?Component=Examination&CycleBeginYear=1999
#   - Muscle strength data url: https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/1999/DataFiles/MSX.xpt
#   - Cardiovascular fitness data url: https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/1999/DataFiles/CVX.xpt

library(here)

# Define download list with updated URLs
files_to_download <- list(
  "msx_muscle_strength.XPT" = "https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/1999/DataFiles/MSX.xpt",
  "cvx_cardio_fitness.XPT" = "https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/1999/DataFiles/CVX.xpt"
)


# Define directory for raw data
raw_dir <- here("data/raw")


# Download each file
for (filename in names(files_to_download)) {
  dest <- file.path(raw_dir, filename)
  url <- files_to_download[[filename]]


  if (!file.exists(dest)) {
    message("⬇Downloading ", filename)
    download.file(url, destfile = dest, mode = "wb")
  } else {
    message("Already exists: ", filename)
  }
}