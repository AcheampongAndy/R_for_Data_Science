# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(ggplot2)
library(dplyr)

# Line chart
economics %>% 
  ggplot(aes(x = date,
             y = unemploy)) +
  geom_line()

## multiple time series - wide table format
economics %>% 
  ggplot(aes(x = date)) +
  geom_line(aes(y = unemploy)) +
  geom_line(aes(y = pce, color = "red"))

## multiple time series - long table format
economics_long %>% 
  ggplot(aes(x = date,
             y = value,
             color = variable,
             group = variable)) +
  geom_line()

economics_long %>% 
  filter(variable != "pop") %>% 
  ggplot(aes(x = date,
             y = value,
             color = variable)) +
  geom_line() +
  # scale the date
  scale_x_date(date_breaks = "5 years", date_labels = "%Y")