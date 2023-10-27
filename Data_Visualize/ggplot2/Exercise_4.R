# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(ggplot2)
library(stringr)
library(dplyr)
library(tibble)
library(readr)
library(cowplot)
library(lubridate)

# load data set
df <- read_csv("data/pjm_hourly_est.csv",
               col_names = T)

# clearn data
df <- df %>% 
  # keep only relevant columns
  select(datetime = Datetime,
         econs = PJME) %>%
  # column conversion
  mutate(datetime = ymd_hms(datetime),
         econs = as.numeric(econs)) %>% 
  # maintain only rows  with values
  filter(!is.na(econs)) %>%
  # sort datetime
  arrange(datetime) %>%
  # add columns
  mutate(date = as_date(datetime),
         year = year(datetime),
         week = isoweek(datetime), # week of the year
         # pad week to have two degits
         week = str_pad(week, width = 2, side = "left", pad = "0"),
         year_week = paste0(year, week), # merge week and year
         week_count = dense_rank(year_week))

# daily consumption
daily <- df %>% 
  group_by(date) %>% 
  summarise(daily_avg = mean(econs, na.rm = T)) %>% 
  ungroup()

# weekly consumption
weekly <- df %>% 
  group_by(week_count) %>% 
  summarise(weekly_avg = mean(econs, na.rm = T)) %>% 
  ungroup()

plot1 <- df %>% 
  ggplot(aes(x = datetime,
             y = econs)) +
  geom_line() +
  xlab("Time stamp - hour") +
  ylab("Megawatts (MW)") +
  ggtitle("Hourly energy consumption")

plot2 <- daily %>% 
  ggplot(aes(x = date,
             y = daily_avg)) +
  geom_line() +
  xlab("Date") +
  ylab("Megawatts (MW)") +
  ggtitle("Average daily energy consumption (smoothed)")

plot3 <- weekly %>% 
  ggplot(aes(x = week_count,
             y = weekly_avg)) +
  geom_line() +
  xlab("Week") +
  ylab("Megawatts (MW)") +
  ggtitle("Average weekly energy consumption (smoothed)")

plot_grid(plot1, plot2, plot3, nrow = 3)

# Export plot
ggsave(filename = "energy_consumption_time_series.png", 
       plot = last_plot(), 
       units = "cm", 
       width = 29, 
       height = 21, 
       dpi = 600)