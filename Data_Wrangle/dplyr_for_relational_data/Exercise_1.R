# clear work space
rm(list = ls())

# load libraries
library(tidyverse)
library(nycflights13)

# inspecting tables
flights
planes
airlines

# adding planes & airlines table to flights
df <- flights %>% 
  left_join(x = .,
            y = planes %>% rename(planes_year = year),
            by = "tailnum") %>% 
  left_join(x = .,
            y = airlines %>% rename(carrier_name = name),
            by = "carrier")

# count number of different planes
carrier_path <- df %>% 
  group_by(carrier_name, manufacturer) %>% 
  summarise(`num of diff planes` = n_distinct(tailnum),
            `num of flights` = n()) %>%
  ungroup()

# bar plot
carrier_path %>% 
  ggplot(aes(x = manufacturer, 
             y = `num of diff planes`,
             fill = carrier_name)) +
  geom_bar(stat = "identity", color = "black") +
  scale_y_continuous(breaks = seq(0, 2000, 100)) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90))