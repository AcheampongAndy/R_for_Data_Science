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

# Exercise 1

## How many rows and columns are in table hflights?
nrow(hflights); ncol(hflights)

## How many different carriers are listed in 
## the table (print a table with distinct carrier names)?
df %>% 
  group_by(UniqueCarrier) %>% 
  distinct() %>% 
  count() %>%
  arrange(n) %>% 
  ungroup()

## Which and how many airports were involved? 
## Consider both origin and destination airports!
df %>% 
  select(Origin, Dest) %>% 
  distinct() %>% 
  pivot_longer(cols = everything(),
               names_to = "Orig/Des",
               values_to = "airports") %>% 
  distinct(airports) %>% 
  arrange(airports)


## How many flights were cancelled?
df %>% 
  group_by(Cancelled) %>% 
  filter(Cancelled == 1) %>% 
  count() %>% 
  ungroup()