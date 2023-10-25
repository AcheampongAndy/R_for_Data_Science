# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(ggplot2)
library(dplyr)
library(tibble)

# box plot
mpg %>% 
  ggplot(aes(x = class,
             y = hwy)) +
  geom_boxplot()

## diamond data set
set.seed(123)
df.diamonds <- diamonds %>%  sample_n(10000)

df.diamonds %>% 
  ggplot(aes(x = color,
             y = price,
             fill = color)) +
  geom_boxplot() +
  scale_y_log10()

## tweak parameters box plot
mpg %>% 
  ggplot(aes(x = class,
             y = hwy)) +
  geom_boxplot(color = "blue",
               outlier.size = 2)

## violin plot
mpg %>% 
  ggplot(aes(x = class,
             y = hwy)) +
  geom_violin()

df.diamonds %>% 
  ggplot(aes(x = color,
             y = price,
             fill = color)) +
  geom_violin() +
  scale_y_log10()

## tweak parameters box plot
mpg %>% 
  ggplot(aes(x = class,
             y = hwy)) +
  geom_violin(fill = "black")

## modify theme
mpg %>% 
  ggplot(aes(x = class, 
             y = hwy)) +
  geom_boxplot() +
  theme_bw()

## Custom theme
mpg %>% 
  ggplot(aes(x = class, 
             y = hwy, 
             fill = class)) +
  geom_boxplot() +
  xlab("Class") +
  ylab("Highway consumption") +
  ggtitle("Car fuel consp. by class") +
  # theme layer
  theme(axis.title = element_text(size = 14,
                                  color = "black"),
        plot.title = element_text(size = 20, face = "bold"),
        legend.background = element_rect(fill = "grey",
                                         color = "black",
                                         linetype = "dashed"),
        plot.background = element_rect(fill = "white",
                                       color = "black"),
        panel.background = element_rect(fill = "grey",
                                        colour = "black",
                                        linetype = "dashed"))