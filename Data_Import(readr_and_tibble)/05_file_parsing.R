# clear work space
rm(list = ls())

# load libraries
library(readr)
library(dplyr)

# file parsing

# guess parser heuristic
guess_parser(c("T", "F"))
guess_parser(c("T", "F", "string"))

# parse each column in mpg table
read_tsv(file = "./data/mpg.tsv",
         col_types = cols(
           manufacturer = col_factor(),	
           model	= col_factor(),
           displ	= col_double(),
           year	  = col_integer(),
           cyl	  = col_integer(),
           trans	= col_character(),
           drv	  = col_character(),
           cty	  = col_number(),
           hwy	  = col_number(),
           fl	    = col_character(),
           class  = col_character()
         ))

# import table 
# - do not specify column type at import
# - change column type inside R
read_tsv(file = "./data/mpg.tsv") %>% 
  mutate_at(.vars = c("year", "cyl"), .funs = as.integer) %>% 
  mutate_at(.vars = c("manufacturer", "model"), .funs = as.factor) %>% 
  mutate_at(.vars = c("year", "cyl"), .funs = as.integer) %>% 
  mutate_at(.vars = c("trans", "fl", "class", "drv"), .funs = as.character) %>% 
  mutate_at(.vars = c("displ", "cty", "hwy"), .funs = as.double)
