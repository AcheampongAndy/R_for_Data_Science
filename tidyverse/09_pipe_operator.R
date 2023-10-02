# clear work space
rm(list = ls())

# load libraries
library(dplyr)
library(ggplot2)

# Inspect data
df <- mpg

# pipe operator %>%
#      chain dplyr function using pipe operator
#      every step is executed in single pipe line 

## count number of cars where manufacturer is "audi"
df %>% 
  filter(manufacturer == "audi") %>% 
  count()

## filter rows for manufacturer "dodge" or "Chevrolet"  and 
## select columns of manufacturer, model, year, and class
df1 <- df %>% 
  filter(manufacturer == "dodge" | manufacturer == "chevrolet") %>% 
  select(manufacturer, model, year, class)

## calculate avg., hwy and count number of car for each 
## manufacturer, model, class, transmission type
## also filter results where average hwy is greater than 30
## and show results on descending order base on average hwy
df %>% 
  group_by(manufacturer, model, class, trans) %>% 
  summarise(`mean hwy` = mean(hwy),
            cars = n()) %>% 
  ungroup() %>% 
  filter(`mean hwy` > 30) %>% 
  arrange(desc(`mean hwy`))
