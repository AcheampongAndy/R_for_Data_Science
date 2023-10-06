# clear work space
rm(list = ls())

# load libraries
library(readxl)
library(rio)
library(data.table)


# import excel file

## readxl
read_excel(path = "./data/mpg.xlsx")
read_excel(path = "./data/mpg.xlsx", sheet = "Sheet 1")
read_excel(path = "./data/mpg.xlsx", range = "A1:C10")


## rio
rio::import(file = "./data/mpg.xlsx")
rio::import(file = "./data/mpg.xlsx", sheet = "Sheet 1")
rio::import(file = "./data/mpg.xlsx", range = "A1:C10")


# import larger files using fread
df.f <- fread(file = "./data/mpg_maxi.csv", sep = ",")

# check with time
system.time(
  df.1 <- read.csv(file = "./data/mpg_maxi.csv")
)

system.time(
  df.2 <- read_csv(file = "./data/mpg_maxi.csv")
)

system.time(
  df.3 <- fread(file = "./data/mpg_maxi.csv", sep = ",")
)
