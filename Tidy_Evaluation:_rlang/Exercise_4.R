# clear work space
rm(list = ls())

# Create a function ”explore diamonds” that:

source('Exercise_3.R')

explore_diamonds <- function(data = prepare_diamonds_data(),
                             title = "Diamonds price",
                             x_title = 'Carat',
                             y_title = 'Price in USD'){
  require(dplyr)
  require(ggplot2)
  
  my_theme <- theme(
    plot.title = element_text(size = 20, face = 'bold', hjust = 0.5),
    axis.title = element_text(size = 16, face = 'italic', hjust = 0.5),
    axis.text = element_text(size = 14),
    legend.title = element_text(size = 14, face = 'bold')
  )
  
  data %>% 
    ggplot(aes(  x   = carat,
                 y   = price,
               size  = volumn,
               color = color)) +
    geom_jitter() +
    ggtitle(title) +
    xlab(x_title) +
    ylab(y_title) +
    theme_minimal() +
    my_theme
}
explore_diamonds()