# clear environment
rm(list = ls())
graphics.off()

# load libraries
library(ggplot2)
library(dplyr)
library(tibble)
library(forcats)

# bar plot

## "stack"
mpg %>%
  ggplot(aes(x = manufacturer,
             fill = class)) +
  geom_bar(position = "stack",
           color = "black") 

## "dodge"
mpg %>% 
  ggplot(aes(x = manufacturer,
             fill = class)) +
  geom_bar(position = "dodge") +
  scale_fill_viridis_d()

## "fill"
mpg %>% 
  ggplot(aes(x = manufacturer,
             fill = class)) +
  geom_bar(position = "fill")

# Scatter plot

## no color altered
set.seed(123)
df.diamonds <- diamonds %>%  sample_n(10000)

df.diamonds %>% 
  ggplot(aes(x = color, 
             y = cut)) +
  geom_jitter() # or geom_point(position = "jitter")

## colors altered
df.diamonds %>% 
  ggplot(aes(x = color, 
             y = cut,
             color = cut)) +
  geom_jitter(size = 2) +
  scale_fill_viridis_d()