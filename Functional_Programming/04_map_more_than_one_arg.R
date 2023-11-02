# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(tidyverse)

# map2() 

## distribution parameters
mu <- c(0, -4, 5, 8)
sig <- c(1, 2, 1, 3)

data <- map2(.x = mu,
             .y = sig,
             .f = rnorm,
             n = 1000) %>% 
  enframe() %>% 
  mutate(name = paste0("norm", 1:4)) %>% 
  unnest(cols = c(value))

data %>% count(name)

# visualize
data %>% 
  ggplot(aes(x = value,
             color = name,
             fill = name)) +
  geom_density(linewidth = 1.3,
               alpha = 0.25) +
  theme_minimal()


# pmap ()

## distribution parameters
n <- c(100, 100, 1500, 10000)
mu <- c(0, -4, 5, 8)
sig <- c(1, 2, 1, 3)

## put arguments inside of a tibble
args <- tibble(mean = mu,
               sd = sig,
               n = n)

## generate data
data <- args %>% pmap(.l = ., .f = rnorm) %>% 
  enframe() %>% 
  mutate(name = paste0("norm", 1:4)) %>% 
  unnest(cols = c(value))

data %>% count(name)

## visualize
data %>% 
  ggplot(aes(x = value,
             color = name,
             fill = name)) +
  geom_density(linewidth = 1.3,
               alpha = 0.25) +
  theme_minimal()


# invoke_map ()

## arguments
func <- c("rnorm", "runif", "rexp")

par <- list(
  list(mean = 1, sd = 3),
  list(min = 0, max = 5),
  list(rate = 0.5)
)

## generate the data
data <- invoke_map(.f = func, .x = par, n = 1000) %>% 
  enframe() %>% 
  mutate(name = func) %>% 
  unnest(cols = c(value))

data %>% count(name)

## visualize
data %>% 
  ggplot(aes(x = value,
             color = name, 
             fill = name)) +
  geom_density(linewidth = 1.3,
               alpha = 0.25) +
  theme_minimal()


# walk ()

## simple example with print
l <- list(1:3, c(2,4,6))

map(l, print)
walk(l, print)

## exporting plots

## create plots
plot <- mpg %>% 
  split(.$manufacturer) %>% 
  map(~ggplot(., aes(x = displ, y = hwy)) + 
        geom_point() + 
        ggtitle(paste0(.$manufacturer)))

## create directory for plot
path <- "./data/pwalk_plots"

if(!dir.exists(path)){
  dir.create(path)
}

## export plots
list(str_c(path, "/", names(plot), ".pdf"), plot) %>% 
  pwalk(., ggsave)
