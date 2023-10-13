# restore work space
rm(list = ls())

# load libraries
library(dplyr)
library(tidyr)
library(stringr)
library(hflights)
library(lubridate)
library(ggplot2)

# Inspect data
df <- hflights


# Exercise 4

## for each carrier and month, calculate total number of flights
## then normalize total number of flights 
## (divide each value with maximum total number of
## flights, you must get values between 0 and 1!)
## so each row is represented with carrier, and each column 
## is represented with month,normalized total number 
## of flights are values in table cells
df.table <- df %>% 
  group_by(UniqueCarrier, Month) %>% 
  count() %>% 
  ungroup() %>% 
  group_by(Month) %>% 
  mutate(n = n / max(n)) %>% 
  ungroup() %>% 
  pivot_wider( names_from = Month, 
               values_from = n,
               values_fill = 0)


## visualising heat map
df %>% 
  group_by(UniqueCarrier, Month) %>% 
  count() %>% 
  ungroup() %>% 
  group_by(Month) %>% 
  mutate(n = n / max(n)) %>% 
  ungroup() %>% 
  mutate(Month = as.factor(Month)) %>% 
  ggplot(aes(x = UniqueCarrier,
             y = Month,
             fill = n)) +
  geom_tile() +
  scale_fill_viridis_c(option = "magma") +
  theme_minimal()