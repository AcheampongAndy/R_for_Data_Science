# clear work space
rm(list = ls())
graphics.off()

# Create a function ”draw bar plot” that:
source('Exercise_1.R')

draw_bar_plot <- function(data, x, y){
  require(rlang)
  require(dplyr)
  require(ggplot2)
  require(forcats)
  
  x_var <- enquo(x)
  y_var <- enquo(y)
  
  data %>% 
    arrange(desc(!!y_var)) %>%
    mutate(x_var = as.factor(!!x_var),
           x_var = fct_inorder(x_var)) %>% 
    ggplot(aes(x = x_var,
               y = !!y_var)) +
    geom_col()
}