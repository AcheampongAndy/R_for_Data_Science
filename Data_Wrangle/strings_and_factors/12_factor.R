# clear work space
rm(list = ls())

# load libraries
library(forcats)
library(ggplot2)
library(dplyr)

# lets create factor variables
df <- mpg %>%
  mutate_at(.vars = c("manufacturer", "model", "trans", "class"),
            .funs = as_factor)

# check factor levels
df$manufacturer %>% levels()

# fct_count () - count factor values

## check car manufacturer
df %>% .$manufacturer %>% fct_count()


# fct_unique () - get unique values
df %>% .$manufacturer %>% fct_unique()
