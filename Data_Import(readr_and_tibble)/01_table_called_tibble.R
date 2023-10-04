# reset work sapce
rm(list = ls())

# load libraries
library(tibble)
library(ggplot2)

# some built in tibble
ggplot2::diamonds
class(ggplot2::diamonds)

ggplot2::economics
class(ggplot2::economics)

# hflight data set
hflights::hflights
class(hflights::hflights)
