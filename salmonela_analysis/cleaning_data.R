# load libraries
library(tidyverse)
library(readxl)
library(janitor)
library(zoo)
library(tidystringdist)

# read data set
dt <- read_excel(file.choose(), na = c("", "NA"))

# inspect data
View(dt)
colnames(dt)

# creating a data frame
data_s <- dt %>% 
  select(Site_ID, Sample_ID, Cluster, Town, Type_of_Sampling,
         VISIT, Date_Sampling, Singleplex, SPC, HF183, S_Typhi, SiteName,
         FlowSpeed, 'Depth of wastewater/sewage', 'Width of wastewater/sewage',
         DeployDuration, NotRecovered, WaterQuality, Calibrate, Temp, ORP, pH,
         DO, EC, pH, DO, SSG, TDS, SAL) %>% 
  clean_names()

# check the names of the variable of interest
colnames(data_s)
View(data_s)


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
count_NA(data_s)

## dealing with missing values
data_s <- data_s %>% 
  mutate(hf183 = replace_na(hf183, 0))

## save the clean data set
write_csv(data_s, '/home/acheampong/Music/R_for_Data_Science/salmonela_analysis/clean1.csv')
