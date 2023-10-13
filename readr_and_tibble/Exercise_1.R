# clear environment
rm(list = ls())

# load libraries
library(tibble)
library(dplyr)
library(readr)
library(data.table)


# Exercise 1

# create a tibble called continents, using data from the table shown on Figure 1.

continents <- tibble(
  `Date (date published)` = as.Date("2017-11-10"),
  Continent = c("Africa", "Antarctica", "Asia", "Europe", "North America", "South America", "Australia"),
  `Area (km2)` = c(30370000, 14000000, 44579000, 10180000, 2470900, 17840000, 8600000),
  `Percent total landmass` = c(20.4, 9.2, 29.5, 6.8, 16.5, 12.0, 5.9),
  Population = c(1287920000, 4499, 4545133000, 742648000, 587615000, 428240000, 41264000),
  `Percent total pop.` = c(16.9, 0.1, 59.5, 9.7, 7.7, 5.6, 0.5)
)


# After you have created a tibble use it to calculate given table summaries:

## total area
## total population
## sum of percentage - total landmass
## sum of percentage - total population

continents %>% 
  summarise(totalArea = sum(`Area (km2)`),
            totalPopulation = sum(Population),
            totalLandmass = sum(`Percent total landmass`),
            totalPopulationPerct = sum(`Percent total pop.`))