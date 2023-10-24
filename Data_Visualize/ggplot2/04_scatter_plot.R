# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(ggplot2)
library(dplyr)
library(tibble)

## Scatter plot
mpg %>% 
  ggplot(aes(x = cty,
             y = hwy)) +
  geom_point(color = "red",
             shape = 17,
             size = 2)

## add regression line
mpg %>% 
  ggplot(aes(x = cty,
             y = hwy)) +
  geom_point() +
  geom_smooth(method = "lm",
              se = F)

## add scales to the axis
mpg %>% 
  ggplot(aes(x = cty,
             y = hwy)) +
  geom_point() +
  scale_x_continuous(breaks = seq(0, 50, 2.5),
                     limits = c(0, 50)) +
  scale_y_continuous(breaks = seq(0, 50, 2.5),
                     limits = c(0, 50))

## Diamond data set
set.seed(123)

df.diamonds <- diamonds %>%  sample_n(10000)

df.diamonds %>% 
  ggplot(aes(x = carat,
             y = price)) +
  geom_point()

## alter y - axis - transform nonlinear trend to linear trend
# square root trans. & log10() trans
df.diamonds %>% 
  ggplot(aes(x = carat,
             y = price)) +
  geom_point()+
  scale_y_sqrt()

df.diamonds %>% 
  ggplot(aes(x = carat,
             y = price)) +
  geom_point()+
  scale_y_log10()

## add smoothng line - auto detect
df.diamonds %>% 
  ggplot(aes(x = carat,
             y = price)) +
  geom_point() +
  geom_smooth()