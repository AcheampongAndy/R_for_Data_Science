# clear working environment
rm(list = ls())

# load libraries
library(lubridate)
library(dplyr)
library(tibble)

# For each string below use an adequate function and 
# parse string to date or date time object:

## ”2021-01-15 23:05:30”
lubridate::ymd_hms("2021-01-15 23:05:30")

## ”2030-01-01 05”
lubridate::ymd_h("2030-01-01 05")

## ”2000-28-02 10:15”
lubridate::ydm_hm("2000-28-02 10:15")

## ”1990-15-03 04”
lubridate::ydm_h("1990-15-03 04")

## ”05/30/1995 9:15:45”
lubridate::mdy_hms("05/30/1995 9:15:45")

## ”1 Nov 2040 01/02:00”
lubridate::dmy_hms("1 Nov 2040 01/02:00")

## ”30 Jun 2035 20:45:00”
lubridate::dmy_hms("30 Jun 2035 20:45:00")

## ”20000101”
lubridate::ymd("20000101")

## ”January 1st 2029”
lubridate::mdy("January 1st 2029")

## ”October 2nd 2028”
lubridate::mdy("October 2nd 2028")

## ”July 15th 2027”
lubridate::mdy("July 15th 2027")

## ”30th March 25”
lubridate::dmy("30th March 25")

## ”2015: Q2”
