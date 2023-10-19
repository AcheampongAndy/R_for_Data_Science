# clear work space
rm(list = ls())

# load libraries
library(lubridate)
library(dplyr)
library(stringr)

## we would like to check which are the leap years between 
## year 1 and year 3000
start_year <- 1
end_year <- 3000

yearsData <- seq.Date(from = as.Date(paste0(start_year, "-01-01")),
                  to = as.Date(paste0(end_year, "-01-01")),
                  by = "years")

# convert sequence to tibble: add column year
yearsData <- tibble(dates = yearsData,
                    year = year(yearsData))

# check if difference between 2 rows in your tibble is 1 year!
diff_years <- diff(yearsData$year)
is_difference_one_year <- all(diff_years == 1)

# to tibble add flag leap year - use lubricate
yearsData <- yearsData %>% 
  mutate(`leap year` = leap_year(yearsData$dates)) %>% 
  mutate(`leap year` = ifelse(`leap year` == T, "Yes", "No"))

## How many leap years are all together?
leapYears <- yearsData %>% 
  mutate(`leap year` = leap_year(yearsData$dates)) %>% 
  mutate(`leap year` = ifelse(`leap year` == T, "Yes", "No")) %>% 
  group_by(`leap year`) %>% 
  summarise(count = n())

## Which are the leap years?
which_leapYears <- yearsData %>% 
  mutate(`leap year` = leap_year(yearsData$dates)) %>% 
  mutate(`leap year` = ifelse(`leap year` == T, "Yes", "No")) %>% 
  filter(`leap year` == "Yes") %>% 
  select(year)

## count leap years per century
leap_year_centory <- yearsData %>% 
  group_by(century = floor(year / 100)) %>%
  filter(`leap year` == "Yes") %>% 
  summarise(`leap years` = length(century))

## Do all centuries have the same number of leap years?
yearsData %>% 
  group_by(century = floor(year / 100)) %>%
  filter(`leap year` == "Yes") %>% 
  summarise(`leap years` = length(century)) %>% 
  distinct(`leap years`)