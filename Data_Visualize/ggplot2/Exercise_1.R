# clear work space
rm(list = ls())
graphics.off()

# load libraries
library(ggplot2)
library(dplyr)
library(tibble)
library(hflights)
library(forcats)


## find top 4 carriers (total number of flights)

df <- hflights %>%
  # group by the UniqueCarrier variable
  group_by(UniqueCarrier) %>% 
  # calculate total number of flight  per carrier
  mutate(total_flight = n()) %>% 
  ungroup() %>% 
  # rank carriers
  # to reverse the rank divide it by one
  mutate(rank = dense_rank(1 / total_flight)) %>% 
  # filter the top UniqueCarriers
  filter(rank <= 4) %>% 
  # Select columns Carrier and distance
  select(Carrier = UniqueCarrier, distance = Distance) %>%
  # convert carrier to a factor variable
  mutate(Carrier = as.factor(Carrier),
         Carrier = fct_infreq(Carrier))


# draw density plot for variable ”distance”

df %>% 
ggplot(aes(distance, fill = Carrier)) +
  # use transparency for fill colors
  geom_density(alpha = 0.5,
               color = "black") +
  # scale fill colors with ”Viridis” color palette
  scale_fill_viridis_d() +
  # remove the outliers: distance < 2000
  scale_x_continuous(breaks = seq(0, 2000, 250),
                     limits = c(0, 2000)) +
  # scaling the density to fit expected
  scale_y_continuous(breaks = seq(0, 0.0029, 0.0001),
                     limits = c(0, 0.0028)) +
  # renaming the x lab
  xlab("Distance of flight (in miles)") +
  # renaming the y lab
  ylab("Density") +
  # giving the plot a title
  ggtitle("Distribution of flight distances - top 4 performing carriers")


# export your final plot

  ggsave("density.png", plot = last_plot(),
         units = "cm",
         width = 26, height = 21)
  
  