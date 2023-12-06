# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(tidyverse)

# load data
gapminder <- read_csv("./data/gampminder.csv")

# plots
plots <- gapminder %>% 
  group_by(continent) %>% 
  nest() %>% 
  mutate(plot = map(.x = data,
                    .f = ~ggplot(., aes(x = year,
                                        y = lifeExp,
                                        color = country,
                                        group = country)) +
                      geom_line(show.legend = F) +
                      scale_color_viridis_d() +
                      scale_y_continuous(limits = c(0, 100)) +
                      ggtitle(paste0("Continent - ", continent)) +
                      xlab("Year") +
                      ylab("Life expectancy") +
                      theme_minimal()
                    ))

# draw subplots
plot_grid(plotlist = plots %>% pull(plot))
