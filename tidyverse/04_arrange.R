# reset work space
rm(list = ls())

# load libraries
library(dplyr)
library(ggplot2)

# Inspect data
df <- mpg

# arrange () - sort rows

## sort rows by year (ascending order)
arrange(df, year)

## sort rows by year (descending order)
arrange(df, desc(year))

## sort rows by year (ascending order) , cyl and displ
df.sort <- arrange(df, year, cyl, displ)
