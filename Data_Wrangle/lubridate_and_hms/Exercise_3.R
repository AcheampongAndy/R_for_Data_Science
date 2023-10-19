# clear environment 
rm(list = ls())

# load libraries
library(lubridate)
library(dplyr)

date <- ymd("21 January 1", "21 January 18", "21 February 15",  
            "21 May 31", "21 June 18", "21 June 19", "21 July 4", 
            "21 July 5",  "21 September 6","21 October 11",  
            "21 November 11",  "21 November 25",  "21 December 24", 
            "21 December 25",  "21 December 31")

holiday <- c("New Year’s Day","Martin Luther King, Jr. Day",
             "President’s Day","Memorial Day","Juneteenth",
             "Juneteenth","Independence Day","Independence Day",
             "Labor Day","Columbus Day","Veterans Day",
             "Thanksgiving Day","Christmas Day","Christmas Day",
             "New Year’s Day")
holidays <- tibble(date = date, holiday = holiday)

# Calculations
holidays <- holidays %>% 
  mutate(`next holiday` = lead(date, n = 1)) %>% 
  mutate(`diff days` = as.period(`next holiday` - date),
         `diff weeks` = `diff days` / weeks(1))

# Is today a holiday?
holidays %>% 
  select(date) %>% 
  # creating a column containing today's date
  mutate(today = Sys.Date(),
         # extract both month and day from the dates
         today = format(today, "%m-%d"),
         date = format(date, "%m-%d")) %>% 
  # compare if some are equal then indeed today is holiday
  filter(today == date) %>% 
  nrow()