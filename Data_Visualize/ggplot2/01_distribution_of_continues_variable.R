# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(ggplot2)
library(dplyr)
library(tibble)

# Histogram

## generate some random data - Uniform continuous distribution
set.seed(123)

df.unif <- runif(100000, 0, 1) %>% 
  # convert to tibble 
  tibble(x = .)

## plot...
ggplot(data = df.unif,
       mapping = aes(x = x)) +
  geom_histogram()

# or
df.unif %>% 
  ggplot(aes(x = x)) +
  geom_histogram(bins = 45,
                 color = "black",
                 fill = "deepskyblue")

## normal continues distribution (random numbers)
df.norm <- rnorm(100000, 0, 1) %>% 
  tibble(x = .)

## plot...
df.norm %>% 
  ggplot(aes(x = x)) +
  geom_histogram(bins = 45,
                 color = "black",
                 fill = "deepskyblue")

## car data set
mpg %>% 
  ggplot(aes(x = hwy)) +
  geom_histogram(bins = 45,
                 color = "black",
                 fill = "deepskyblue") +
  xlab("Highway mile per gallon") +
  ylab("Number of Cars (frequency)") +
  ggtitle("Distribution of variable highway")

# Density plot

df.norm %>% 
  ggplot(aes(x = x)) +
  geom_density(adjust = 0.05)

## line parameter
df.norm %>% 
  ggplot(aes(x = x)) +
  geom_density(adjust = 0.5,
               size = 1.2,
               linetype = "dashed")

# visualize normally distributed variables (diff, distr. parms)
df.norm1 <- rnorm(100000, 0, 1) %>% tibble(x = .)
df.norm2 <- rnorm(100000, 1, 2) %>% tibble(x = .)
df.norm3 <- rnorm(100000, -2, 3) %>% tibble(x = .)

ggplot() +
  #first density
  geom_density(df.norm1, mapping = aes(x = x),
               color = "black", fill = "blue",
               alpha = 0.2) +
  # second density
  geom_density(df.norm2, mapping = aes(x = x),
               color = "black", fill = "red",
               alpha = 0.2) +
  # third density
  geom_density(df.norm3, mapping = aes(x = x),
               color = "black", fill = "green",
               alpha = 0.2)