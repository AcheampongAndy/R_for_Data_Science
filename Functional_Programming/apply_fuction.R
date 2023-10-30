# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(purrr)
library(tidyverse)
library(hflights)

# map ()

# Example 1
df <- hflights %>% 
  select(ActualElapsedTime, AirTime, Distance, TaxiIn, TaxiOut)

df <- as_tibble(df)

df %>% map(.x = ., .f = mean, na.rm =T)

df %>% map(min, na.rm = T)

df %>% map(max, na.rm = T)

df %>% map(sd, na.rm = T)

# Example 2

# for mpg
numeric_cols <- map(.x = mpg, .f = is.numeric) %>% 
  unlist() %>% 
  tibble(column = names(.),
         numeric = .) %>% 
  filter(numeric == T) %>% 
  pull(column)

# for hflight
numeric_cols <- map(.x = hflights, .f = is.numeric) %>% 
  unlist() %>% 
  tibble(column = names(.),
         numeric = .) %>% 
  filter(numeric == T) %>% 
  pull(column)