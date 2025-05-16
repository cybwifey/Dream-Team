# Title: API Fetch Template (Socrata JSON) – National Health and Data Inquiry 2025
# Author: Andrei Sales

# Description: 
# Modified fetch_api_template.R to handle Socrata endponts
# Socrata endpoints return a plain array of records, not data wrapped in "value" field


# install.packages("httr")   # Avoid installing packages on script
library(httr)               # allows us to use GET()

install.packages("jsonlite")
library(jsonlite)
library(tidyverse) # Tidyverse includes dplyr, you dont need both


# Define the API fetch function
fetch_api_socrata <- function(url, params = list()) {

  message("Fetching data from: ", url)

  # Perform GET with optional query parameters
  response <- GET(url, query = params)

  # Check status
  if (status_code(response) != 200) {
    stop(" Failed to fetch data: HTTP ", status_code(response))
  }

  # Parse JSON
  data_raw  <- content(response, as = "text", encoding = "UTF-8")
  data_json <- fromJSON(data_raw, flatten = TRUE)

  # Convert to tibble
  # If it's a named list of columns, wrap in as_tibble(); if it's an unnamed list, treat as list of rows
  if (inherits(data_json, "data.frame")) {
    return(as_tibble(data_json))
  } else if (is.list(data_json) && length(data_json) && is.list(data_json[[1]])) {
    return(as_tibble(bind_rows(data_json)))
  } else {
    warning("Unexpected JSON structure")
    return(as_tibble(data_json))
  }
}