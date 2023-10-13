# reset work space
rm(list = ls())

# Install libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)

# Inspect data
df <- mpg

# dplyr and tidyr in action

# pull() - extract columns as vector
df %>% pull(hwy)

# group_by () + mutate () 

## calculate average hwy per car manufacturer and car model
df <- df %>% 
  group_by(manufacturer, model) %>% 
  mutate(`mean hwy` = mean(hwy)) %>% 
  ungroup()


# case_when () 

## add variable "transmission type": automatic or manual 
df %>% count(trans)

df <- df %>% 
  mutate(trans_ = str_sub(string = trans, start = 1, end = 1)) %>% 
  mutate(`trans type` = case_when(trans_ == "a" ~ "automatic",
                                  trans_ == "m" ~ "manual",
                                  TRUE ~ "NA")) %>% 
  select(-trans_)


# row_number () - Ranks

## add a car rank / id not considering groups
df <- df %>% 
  mutate(`car id` = row_number())

## add car id considering groups (per manufacturer)
df <- df %>% 
  group_by(manufacturer) %>% 
  mutate(`car id 1` = row_number()) %>% 
  ungroup()
