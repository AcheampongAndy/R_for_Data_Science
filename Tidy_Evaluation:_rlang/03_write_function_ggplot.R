# clear work space
rm(list = ls())
graphics.off()

# histogram
plot_histogram <- function(data, var){
  require(ggplot2)
  require(rlang)
  require(dplyr)
  
  var = enquo(var)
  
  data %>% 
    ggplot(aes(x = !!var)) +
    geom_histogram()
}

plot_histogram(mpg, hwy)

# scatter plot
plot_scatter <- function(data, x, y){
  require(ggplot2)
  require(rlang)
  require(dplyr)
  
  x_var = enquo(x)
  y_var = enquo(y)
  
  data %>% 
    ggplot(aes(x = !!x_var,
               y = !!y_var)) +
    geom_point()
}

plot_scatter(diamonds, carat, price)

# generic scatter plot and custome theme

## theme
theme_fonts <- theme(
  plot.title = element_text(size = 20, face = 'bold', hjust = 0.5),
  axis.title = element_text(size = 16, face = 'italic', hjust = 0.5),
  axis.text = element_text(size = 14)
)

plot_scatter <- function(data, x, y, color,
                         title='', x_title='', y_title=''){
  require(dplyr)
  require(ggplot2)
  require(rlang)
  
  x_var <- enquo(x)
  y_var <- enquo(y)
  color_var <- enquo(color)
  
  data %>% 
    ggplot(aes(x = !!x_var,
               y = !!y_var,
               color = !!color_var)) +
    geom_point() +
    ggtitle(title) +
    xlab(x_title) +
    ylab(y_title) +
    theme_minimal() +
    theme_fonts
}

plot_scatter(diamonds, carat, price, color = color, title = 'Diamond price',
             x_title = 'carrat',
             y_title = 'price in USD')
 