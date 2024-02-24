# load libraries
library(tidyverse)
library(janitor)
library(zoo)
library(tidystringdist)

# read data set
dt <- read_csv(file.choose())

# inspect data
View(dt)
colnames(dt)

# creating a data frame
data_s_typhi <- dt %>% 
  select(Site_ID, SiteID_byMonth, SampleID_Method, TTR_Positive, TVIB_Positive, STAG_Positive,
         S_Typhi, Lon, Lat, FlowSpeed, Depth.of.wastewater.sewage, Width.of.wastewater.sewage,
         DeployDuration, NotRecovered, WaterQuality, Temperature, Oxygen_reduction_potential,
         pH, dissolved_oxygen, Electrical_conductivity, Total_dissolved_solids, Salinity) %>% 
  clean_names()

# check the names of the variable of interest
colnames(data_s_typhi)
View(data_s_typhi)

# 2) Initial data inspection
# Check
# missing values
# relevant data
# how data is coded

# functions for NA detection
count_NA <- function(df){
  require(tidyverse)
  require(cowplot)
  
  df_count_NA <- map(df, ~sum(is.na(.))) %>% 
    simplify() %>% 
    tibble(columns = names(.),
           NAs = .) %>% 
    mutate(`NAs %` = round(NAs / nrow(df) * 100,2))
  
  print(df_count_NA %>% as.data.frame())
  
  # plot absolute NA counts
  p1 <- df_count_NA %>% 
    ggplot(aes(x = columns,
           y = NAs)) +
    geom_col() +
    theme(axis.text.x = element_text(angle = 90))
  
  # plot relative NA counts
  p2 <- df_count_NA %>% 
    ggplot(aes(x = columns,
           y = `NAs %`)) + 
    geom_col() +
    scale_y_continuous(limits = c(0, 100)) +
    theme(axis.text.x = element_text(angle = 90))
  
  plot_grid(p1, p2, nrow = 2)
}

## missing values
count_NA(data_s_typhi)

## dealing with missing values
data_s_typhi <- data_s_typhi %>% 
  mutate(ttr_positive = replace_na(ttr_positive, 2))

data_s_typhi <- na.omit(data_s_typhi)