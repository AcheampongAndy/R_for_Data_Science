# Clear work space
rm(list = ls())
graphics.off()

# load libraries
library(ggplot2)
library(dplyr)
library(tibble)

## car data set mpg
ggplot() +
  geom_density(mpg, mapping = aes(x = hwy),
               color = "black", fill = "blue",
               alpha = 0.2) +
  geom_density(mpg, mapping = aes(x = cty),
               color = "black", fill = "red",
               alpha = 0.2) +
  xlab("Miles per gallon") +
  ylab("Density")

## how to export
ggsave("density.png", plot = last_plot(),
       width = 26, height = 21, dpi = 300, units = "cm")

# Area plot

## normal continues distribution (random numbers)
set.seed(123)
df.norm <- rnorm(100000, 0, 1) %>% 
  tibble(x = .)

## "bins" - statistics
df.norm %>% 
  ggplot(aes(x = x)) +
  geom_area(stat = "bin",
            binwidth = 0.1)

## commulative distribution
df.norm <- rnorm(n = 1000) %>% 
  tibble(x = .)

df.norm <- df.norm %>% 
  arrange(x) %>% 
  mutate(count = 1,
         y = cumsum(count),
         y = y / sum(count))

df.norm %>% 
  ggplot(aes(x = x,
             y = y)) +
  geom_area(fill = "blue",
            color = "black")

## add some standard deviations
df.norm %>% 
  ggplot(aes(x = x,
             y = y)) +
  geom_area(fill = "blue",
            color = "black") +
  geom_vline(xintercept = -2.5, linetype = "dashed", size = 1) +
  geom_vline(xintercept = -2, linetype = "dashed", size = 1) +
  geom_vline(xintercept = -1, linetype = "dashed", size = 1) +
  geom_vline(xintercept = 0, linetype = "dashed", size = 1) +
  geom_vline(xintercept = 1, linetype = "dashed", size = 1) +
  geom_vline(xintercept = 2, linetype = "dashed", size = 1) +
  geom_vline(xintercept = 3, linetype = "dashed", size = 1) 

## theoritical probabilities
tibble(x = seq(-3, 3, 1),
       y = pnorm(x, lower.tail = T))