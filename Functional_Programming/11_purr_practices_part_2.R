# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(tidyverse)

## export multiple files
directory <- "./data/mpg_export"

if(!dir.exists(directory)){
  dir.create(directory)
}

df.export <- mpg %>% 
  group_by(manufacturer, model) %>% 
  mutate(car_id = row_number()) %>% 
  ungroup() %>% 
  # add path to the file
  mutate(path = paste0(directory, "/",
                       manufacturer, "_",
                       str_remove_all(model, pattern =  " "), "_",
                       car_id, ".csv")) %>% 
  # nest data
  select(-car_id) %>% 
  group_by(path) %>% 
  nest() %>% 
  ungroup()

## create a list of data and file path for pmap to export files
list(x = df.export$data,
     file = df.export$path) %>% 
  pmap(.l = .,
       .f = write_csv) %>% 
  quietly()

# draw multiple plot per one table
df.plot <- mpg %>% 
  group_by(manufacturer) %>% 
  nest() %>% 
  # draw the plot
  mutate(plot = map(.x = data,
                    .f = ~ggplot(., aes(x = displ,
                                        y = hwy,
                                        color = as.factor(cyl))) +
                      geom_jitter(size = 3) +
                      scale_color_viridis_d(option = "magma")
                      ))

## show a single plot
df.plot %>% pull(plot) %>% pluck(1)

## create directory
directory = "./data/mpg_plot_export"
if(!dir.exists(directory)){
  dir.create(directory)
}

## add a path to each plot
df.plot <- df.plot %>% 
  mutate(plot_path = paste0(directory, "/",
                            manufacturer, ".png"))

## export plot
list(plot = df.plot$plot,
     filename = df.plot$plot_path) %>% 
  pmap(.l = .,
       .f = ggsave) %>% 
  quietly()
