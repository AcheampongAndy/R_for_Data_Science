# clear work space
rm(list = ls())

# load libraries
library(lubridate)
library(dplyr)
library(readr)

# import the .csv file pjm hourly est.csv
data_set <- readr::read_csv("./data/pjm_hourly_est.csv",
                      col_names = T,
                      col_types = cols(.default = "c"))

data_set <- data_set %>% 
  # keep only columns Datetime and PJME
  select(datetime = Datetime, pjme = PJME) %>% 
  # do not forget column parsing!
  mutate(datetime = ymd_hms(datetime),
         pjme = as.numeric(pjme)) %>% 
  # remove rows where PJME data is missing!
  filter(!is.na(pjme)) %>% 
  # sort rows based on date time column
  arrange(datetime)

# now add columns: date, month, year (lubridate)
data_set <-  data_set %>% 
  mutate(date = as_date(datetime),
         month = month(datetime),
         year = year(datetime))

# yearly consumption
data_year <- data_set %>% 
  select(datetime, pjme, year) %>% 
  group_by(year) %>% 
  # creating boundaries
  mutate(`int start` = min(datetime),
         `end start` = max(datetime)) %>%
  # create intervals
  mutate(interv = `int start` %--% `end start`) %>% 
  ungroup() %>% 
  # grouping by year and interval
  group_by(year, interv) %>% 
  # calculating total and average
  summarise(`pjme tot` = sum(pjme),
            `pjme avg` = mean(pjme))

# month consumption
data_month <- data_set %>% 
  select(datetime, pjme, month, year) %>% 
  # creating a year_month column for the month
  mutate(year_month = ym(paste(year, "-", month, sep = ""))) %>% 
  group_by(year_month) %>%
  # creating boundaries
  mutate(`int start` = min(datetime),
         `int end` = max(datetime)) %>% 
  # create interval
  mutate(interv = `int start` %--% `int end`) %>%
  ungroup() %>% 
  # grouping by year_month and interval
  group_by(year_month, interv) %>% 
  # calculate average and totals
  summarise(`total pjme` = sum(pjme, na.rm = T),
            `avg pjme` = mean(pjme, na.rm = T))

# day consumption
data_day <- data_set %>% 
  select(datetime, pjme, date) %>% 
  # group date
  group_by(date) %>%
  # creating boundaries
  mutate(`int start` = min(datetime),
         `int end` = max(datetime)) %>% 
  # create interval
  mutate(interv = `int start` %--% `int end`) %>%
  ungroup() %>% 
  # group by date and intervals
  group_by(date, interv) %>% 
  # calculate average and totals
  summarise(`total pjme` = sum(pjme, na.rm = T),
            `avg pjme` = mean(pjme, na.rm = T))