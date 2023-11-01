# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(tidyverse)
library(hflights)

# data set
df <- hflights %>% 
  select(ActualElapsedTime, AirTime, Distance, TaxiIn, TaxiOut)

df <- as_tibble(df)

# map_dbl () - double numeric vector
df %>% map_dbl(mean, na.rm = T)
df %>% map_dbl(max, na.rm = T) 
df %>% map_dbl(min, na.rm = T) 
df %>% map_dbl(sd, na.rm = T) 

# create summary table
df %>% 
  colnames() %>% 
  tibble(variables = .,
         mean = df %>% map_dbl(., mean, na.rm = T),
         sd = df %>% map_dbl(., sd, na.rm = T))

# map_int () - integer vector

## simple list
list <- list(a = 1,
             b = "word", 
             c = 1:10,
             d = mpg)

list %>% map_int(length)

# map_dfc () - data frame column bind

## summaries
df %>% map_dfc(mean, na.rm = T)
