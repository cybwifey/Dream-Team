# Title: API Fetch Template – National Health and Data Inquiry 2025
# Author: Sarina Etminan

# Description:
# A basic API template using httr and jsonlite to make GET requests,
# check the response status, and convert nested JSON data to a tidy tibble.

# Load required libraries (ONLY once, outside the function)
library(httr)
library(jsonlite)
library(tidyverse)

# Define the API fetch function
fetch_api_data <- function(url) {
  # Make the GET request
  response <- GET(url)

  # Check response status
  if (status_code(response) == 200) {
    data_raw <- content(response, as = "text", encoding = "UTF-8")
    data_json <- fromJSON(data_raw, flatten = TRUE)
    return(as_tibble(data_json))
  } else {
    stop("❌ Failed to fetch data: HTTP ", status_code(response))
  }
}

# Using the function in different scripts 
# source("code/functions/fetch_api_data.R")

# Then call it
# df_vo2 <- fetch_api_data("https://api.example.org/data?country=CAN&indicator=VO2MAX")


