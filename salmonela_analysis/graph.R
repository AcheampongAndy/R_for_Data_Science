# Main graph

main_data1 <- main_data %>% group_by(s_typhi) %>% summarise(Count = n()) %>% 
  mutate(Percentage = Count / sum(Count) * 100)

# Main graph

main_data1 %>% 
  ggplot(aes(x = s_typhi,
             y = Count,
             fill = s_typhi)) + 
  geom_bar(stat = "identity") + 
  geom_text(aes(label = paste0(Count, " (", round(Percentage, 1), "%)")), 
            vjust = -0.5) +
  labs(title = expression("Prevalence of" ~ italic("S.") ~ "Typhi"),
       x = bquote(italic("S.") ~ " Typhi detection"),
       y = "Count",
       fill = bquote(italic("S.") ~ " Typhi")) +
  theme_bw() +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 12),
        axis.text.x = element_text(margin = margin(t =5, 
                                                   r=20, 
                                                   b=5, 
                                                   l=0)),
        plot.title = element_text(size = 16, 
                                  face = "bold",
                                  hjust = 0.5),
        legend.title = element_text(size = 12, colour = "black",
                                    face = "bold"),
        legend.text = element_text(size = 12, color = "black"))


# saving to active/current working directory 
ggsave(filename = "prevalence of S_Typhi.png",
       plot = last_plot(),
       units = "cm", width = 29, height = 21, dpi = 300)


# Graph for more type of sampling

sampleType <- main_data %>% 
  select(type_of_sampling) %>% 
  group_by(type_of_sampling) %>% 
  summarise(Count = n()) %>% 
  mutate(Percentage = Count / sum(Count) * 100) %>% 
  
  ##Plot
  sampleType %>% 
  ggplot(aes(x = type_of_sampling,
             y = Count,
             fill = type_of_sampling)) + 
  geom_bar(stat = "identity") + 
  geom_text(aes(label = paste0(Count, " (", round(Percentage, 1), "%)")), 
            vjust = -0.5) +
  labs(title = "Type of sampling",
       x = "Sampling Type",
       y = "Count", 
       fill = "Type of sampling" ) +
  theme_bw() +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 12),
        axis.text.x = element_text(margin = margin(t =5, 
                                                   r=20, 
                                                   b=5, 
                                                   l=0)),
        plot.title = element_text(size = 16, 
                                  face = "bold",
                                  hjust = 0.5),
        legend.title = element_text(size = 12, colour = "black",
                                    face = "bold"),
        legend.text = element_text(size = 12, color = "black"))

# saving to active/current working directory 
ggsave(filename = "Type of sampling.png",
       plot = last_plot(),
       units = "cm", width = 29, height = 21, dpi = 300)