# clear working environment
rm(list = ls())

# load libraries
library(lubridate)
library(dplyr)

# Checking current time zone
Sys.timezone()

# Different time zone
OlsonNames() %>% length()

# force timezone
with_tz(now(), "US/Hawaii")