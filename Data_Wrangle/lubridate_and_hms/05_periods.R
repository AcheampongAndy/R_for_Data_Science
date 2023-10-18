# clear environment
rm(list = ls())

# load libraries
library(lubridate)
library(dplyr)

# Periods ()

## convert age to period
birth_day <- dmy("25-11-2000")
age <- today() - birth_day
as.period(age)

## convert years to seconds
period_to_seconds(years(1))

## convert seconds to any period
seconds_to_period(36000)

## convert using period and unit
period(36000, units = "minute")


# Periods - Arithmatics
seconds(10) + minutes(1) # add seconds to minutes
years(1) + weeks(25) # add year to weeks

# Inconsistent time line behavour

## DST
dt <- ymd_hms("2016-03-12 13:00:00", tz = "America/New_York")
leap_year(dt)
dt + days(1)