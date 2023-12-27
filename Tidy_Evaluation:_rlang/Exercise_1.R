# clear work space
rm(list = ls())
graphics.off()

# Create a function 'count freq' that:
count_freq <- function(data, var_group){
  require(rlang)
  require(dplyr)
  
  x_var <- enquo(var_group)
  
  data %>% 
    group_by(!!x_var) %>% 
    summarise(freq = n()) %>% 
    ungroup() %>% 
    rename(x = 1,
           freq = 2)
}