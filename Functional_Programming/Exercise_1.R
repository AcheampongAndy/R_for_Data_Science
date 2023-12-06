# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(tidyverse)
library(cowplot)

# read blue_print
blueprint_raw <- read_csv(file = "./data/simulations_blue_print.txt",
                          col_names = F) %>% 
  rename(type = X1)

## create vector
type <- blueprint_raw %>% pull(type)

## split columns
blueprint_raw <- blueprint_raw %>% 
  separate(col = 1, into = c("f", "arg1", "arg2", "arg3"), sep = ";")

## create vector for functions
f <- blueprint_raw %>% pull(f)

## create list of list for arguments
args <- list()

for(row in 1:nrow(blueprint_raw)){
  args.row.text <- ""
  for(column in 2:ncol(blueprint_raw)){
    if(blueprint_raw[row, column] != ""){
      args.row.text <- str_c(args.row.text, blueprint_raw[row, column], sep = ",")
    }
  }
  args.row.text <- str_remove(args.row.text, pattern = "^,|,$")
  args.row.text <- paste0("list(", args.row.text, ")")
  eval(parse(text = paste0("args.row.list = ", args.row.text)))
  args <- c(args, list(args.row.list))
}

# do the simulation
set.seed(123)
data.sim <- invoke_map(.f = f,
                       .x = args) %>% 
  enframe() %>% 
  mutate(type = type,
         f = f) %>% 
  unnest(cols = c(value)) %>% 
  select(f, type, value)