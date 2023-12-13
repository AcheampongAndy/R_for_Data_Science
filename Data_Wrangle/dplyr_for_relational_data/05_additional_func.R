# clear work space
rm(list = ls())

# load libraries
library(tidyverse)
library(nycflights13)

# create a data set from flights
df <- flights %>% 
  filter(carrier == "AA") %>% 
  arrange(time_hour)

# check1
df <- df %>% 
  mutate(`origin prev flight` = lag(x = origin, n = 1)) %>% 
  mutate(`origin test` = case_when(origin == `origin prev flight` ~ T,
                                   T ~ F))
df %>% filter(`origin test`) %>% count()

# check2
df <- df %>% 
  mutate(`distance successive flight` = distance + lead(x = distance, n = 1)) %>% 
  mutate(`distance test` = case_when(`distance successive flight` >= 2000 ~ TRUE,
                                     TRUE ~ FALSE))

df %>% filter(`distance test`) %>% count()

# check 3
df <- df %>% 
  mutate(`distance running tot` = cumsum(distance))

df %>% 
  mutate(`flight id` = row_number()) %>% 
  filter(`distance running tot` >= 1000000) %>% 
  select(`flight id`, everything()) %>% 
  head(1) %>% 
  as.data.frame()

## rank flight
df <- df %>% 
  mutate(`rank flight` = dense_rank(distance))
