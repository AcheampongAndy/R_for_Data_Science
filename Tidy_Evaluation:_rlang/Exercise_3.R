# clear work space
rm(list = ls())
graphics.off()

# Create a function ”prepare diamonds data” that:
prepare_diamonds_data <- function(data = diamonds, n = 10000){
  require(rlang)
  require(dplyr)
  
  data %>% 
    sample_n(size = n, replace = F) %>% 
    mutate(volumn = x * y * z)
}

prepare_diamonds_data()