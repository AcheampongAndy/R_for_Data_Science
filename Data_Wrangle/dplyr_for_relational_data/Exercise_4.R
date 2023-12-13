# clear work space
rm(list = ls())

# load libraries
library(tidyverse)
library(nycflights13)

# load data
distance_per_date <- read_csv("./dplyr_for_relational_data/dist.csv", col_names = T)
dates_span <- read_csv("./dplyr_for_relational_data/data.csv", col_names = T)

# join tables
commulative_distance_per_date <- distance_per_date %>% 
  distinct(carrier_name) %>% 
  # cross join carrier name with date
  full_join(x = .,
            y = dates_span,
            by = character()) %>% 
  # bring back distance flown
  left_join(x = .,
            y = distance_per_date,
            by = c("carrier_name", "date")) %>% 
  # fill blanks with 0
  mutate(`distance flown` = replace_na(`distance flown`, 0)) %>% 
  # sort rows
  arrange(carrier_name, date) %>% 
  # add running total distance
  group_by(carrier_name) %>% 
  mutate(`distance flown cum` = cumsum(`distance flown`)) %>% 
  ungroup()

# plot
commulative_distance_per_date %>% 
  ggplot(aes(x = date,
             y = `distance flown cum`,
             group = carrier_name,
             color = carrier_name)) +
  geom_line(linewidth = 1.2) +
  scale_color_viridis_d(option = "inferno") +
  theme_minimal()