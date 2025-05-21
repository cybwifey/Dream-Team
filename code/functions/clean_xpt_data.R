# Title: General XPT Cleaner – NHANES Data
# Author: Sarina Etminan

library(haven)
library(janitor)
library(tidyverse)

clean_xpt_data <- function(file_path, drop_empty_rows = TRUE) {
  message("Reading XPT: ", file_path)

  df <- read_xpt(file_path)

  df <- df %>%
    janitor::clean_names() %>%
    select(where(~!all(is.na(.))))

  if (drop_empty_rows) {
    df <- df %>% filter(if_any(everything(), ~ !is.na(.)))
  }

  df <- df %>% mutate(across(where(is.character), str_trim))

  return(as.data.frame(df))
}