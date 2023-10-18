# clear environment
rm(list = ls())

# load libraries
library(lubridate)
library(dplyr)

# some basic arithmetic
today <- today()
now <- now()

## to get one day after today
today + 1

## to get one day before today
today - 1

# time is calculated in seconds

## to get one hour before the time in now
now - 3600

## to get one hour after the time in now
now + 3600

## how old are you
birth_day <- dmy("25-11-2000")
age <- today() - birth_day
age

# Duration

## convert age to duration
as.duration(age)

## constructor functions

x <- 1 # number of seconds

dyears(x) # number of seconds in one year
dmonths(x) # number of seconds in one month
dweeks(x) # number of seconds in one week


## duration arithmetic
dseconds(10) + dminutes(1) # add 10 seconds to 1 minute
dyears(1) - dweeks(27) # add 1 year to 27 weeks


# Inconsistent timeline behavior (duration)

## Daylight Savings Time (DST)
dt <- ymd_hms("2016-03-12 13:00:00", tz = "America/New_York")
dt
leap_year(dt)
dt + ddays(1)