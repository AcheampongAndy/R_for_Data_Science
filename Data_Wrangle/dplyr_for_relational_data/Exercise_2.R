# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(tidyverse)
library(nycflights13)

# adding planes & airlines table to flights
df <- flights %>% 
  left_join(x = .,
            y = planes %>% rename(planes_year = year),
            by = "tailnum") %>% 
  left_join(x = .,
            y = airlines %>% rename(carrier_name = name),
            by = "carrier") %>% 
  left_join(x = .,
            y = weather, 
            by = c("origin", "year", "month", "day", "hour"))

## scatter plot
df %>% 
  mutate(delay = case_when(arr_delay > 30 ~ T,
                           T ~ F)) %>% 
  sample_n(size = 50000) %>% 
  ggplot(aes(x = visib,
             y = precip,
             size = wind_speed,
             color = arr_delay)) +
  geom_jitter() +
  scale_size_area(max_size = 10) +
  scale_color_viridis_c(option = "magma") +
  facet_wrap(. ~ delay)