# clear work space
rm(list = ls())

# load libraries
library(readr)
library(ggplot2)
library(feather)

# write files

# write a csv files

## comma separated 
write_csv(x = mpg,
          file = "./data/mpg_w.csv",
          col_names = T)


## semicolon separated
write_csv2(x = mpg,
          file = "./data/mpg_w2.csv",
          col_names = T)

# write excel file
rio::export(x = mpg, 
            file = "./data/mpg_w.xlsx")


# write/read .rds file
write_rds(x = mpg,
          file = "./data/mpg_w.rds")

read_rds(file = "./data/mpg_w.rds")


# write/read feather file
write_feather(x = mpg,
              path = "./data/mpg_w.feather")
read_feather(path = "./data/mpg_w.feather")
