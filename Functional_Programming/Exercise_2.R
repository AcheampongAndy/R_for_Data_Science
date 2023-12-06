# clear work space
rm(list = ls())

# load libraries
library(tidyverse)

# load data
data.sim <- read_csv("./data/data_sim.csv", col_names = T)

## create subplots inside tibble
plots <- data.sim %>% 
  group_by(f) %>% 
  nest() %>% 
  mutate(plot = map(.x = data,
                    .f = ~ggplot(., aes(x = value,
                                        fill = type)) +
                      geom_density(alpha = 0.3) +
                      scale_fill_viridis_d() +
                      ggtitle(paste0(f)) +
                      xlab("") +
                      theme_minimal()
                      ))

## draw subplots
plot_grid(plotlist = plots %>% pull(plot), nrow = 3)
