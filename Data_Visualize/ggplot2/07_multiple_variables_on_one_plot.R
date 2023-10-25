# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(ggplot2)
library(dplyr)
library(tibble)

# facet

## facet_wrap ()
mpg %>% 
  ggplot(aes(x = cty,
             y = hwy)) +
  geom_jitter() +
  facet_wrap(vars(class),
             scales = "free")

## facet_grid ()
mpg %>% 
  ggplot(aes(x = cty,
             y = hwy)) +
  geom_jitter() +
  facet_grid(class ~ drv,
             scales = "free")

# Add multiple features

## 2 continues var + point size = cont
mpg %>% 
  ggplot(aes(x = cty,
             y = hwy,
             size = cyl)) +
  geom_jitter() +
  scale_size(range = c(1,2))

## 2 continues var + point color = cont
mpg %>% 
  ggplot(aes(x = cty,
             y = hwy,
             color = cyl)) +
  geom_jitter()


## 2 continues var + point color = categ
mpg %>% 
  ggplot(aes(x = cty,
             y = hwy,
             color = class)) +
  geom_jitter()

## 2 continues var + point shape = categ
mpg %>% 
  ggplot(aes(x = cty,
             y = hwy,
             shape = class)) +
  geom_jitter(size = 2)

## finale plot
set.seed(123)
df.diamonds <- diamonds %>%  sample_n(10000)

df.diamonds %>% 
  ggplot(aes(x = carat,
             y = price, 
             color = cut)) +
  geom_jitter() +
  facet_grid(color ~ clarity,
             scales = "free",
             labeller = "label_both")
