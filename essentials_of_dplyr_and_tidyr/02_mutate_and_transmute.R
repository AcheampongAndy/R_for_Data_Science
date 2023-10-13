# reset work space

rm(list = ls())
graphics.off()

# loading libraries

library(dplyr)
library(ggplot2)

# Inspect data
df <- mpg

# mutate - create a new variable

## create variable: average between highway and mile per gallon

df <- mutate(df, 
             `avg mile per gallon` = (cty + hwy) / 2)

## "car" - "cyl" / "trans"

df <- mutate(df,
             car = paste(manufacturer, model, sep = " "),
             `cyl / trans` = paste(cyl, " cylinders", " /", trans, " transmission", sep = " "))

# transmute - create new variable and drop other variables

df1 <- transmute(df, 
                 `avg mile per gallon` = (cty + hwy) / 2)

df2 <- transmute(df, 
                 car = paste(manufacturer, model, sep = " "),
                 `cyl / trans` = paste(cyl, " cylinders", " /", trans, " transmission", sep = " "))
