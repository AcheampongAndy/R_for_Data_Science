# clear work space
rm(list = ls())

# load libraries
library(tidyverse)

# create nested data
df <- mpg %>% 
  filter(manufacturer %in% c("jeep", "land rover", "lincoln")) %>% 
  select(manufacturer, model, displ, cyl, hwy)

df.n <- df %>% 
  group_by(manufacturer) %>% 
  nest()

## unnest
df1 <- df.n %>% 
  unnest(cols = c("data")) %>% 
  ungroup()

## operations that goes with nesting
df.n$data %>% map(.x = ., .f = ~length(.$model))
df.n$data %>% map(.x = ., .f = ~mean(.$hwy))

## nesting a larger data frame
mpg %>% 
  group_by(manufacturer) %>% 
  nest()

diamonds %>% 
  group_by(cut, color) %>% 
  nest() %>% 
  mutate(`avg price` = map(data, .f = ~mean(.$price)),
         `num diamonds` = map(data, .f = ~length(.$price))) %>% 
  mutate(`avg price` = unlist(`avg price`),
         `num diamonds` = unlist(`num diamonds`))
