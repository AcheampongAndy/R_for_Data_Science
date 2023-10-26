# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(ggplot2)
library(dplyr)
library(cowplot)

# some smaller plots
p1 <- ggplot(mpg, aes(x = cty, y = hwy)) + geom_jitter()
p2 <- ggplot(mpg, aes(x = displ, y = hwy)) + geom_jitter()
p3 <- ggplot(mpg, aes(x = cyl, y = hwy)) + geom_jitter()
p4 <- ggplot(mpg, aes(x = drv, y = cty)) + geom_jitter()
p5 <- ggplot(mpg, aes(x = trans, y = hwy)) + geom_jitter()
p6 <- ggplot(mpg, aes(x = class, y = hwy)) + geom_jitter()

# create sub plot
plot_grid(p1, p2, p3, p4)

## add labels
plot_grid(p1, p2, p3, p4, labels = "AUTO")

## or
plot_grid(p1, p2, p3, p4, labels = c("p1", "p2", "p3", "p4"))

## change the configuration of the plot
plot_grid(p1, p2, p3, p4, p5, p6, nrow = 2, ncol = 3)