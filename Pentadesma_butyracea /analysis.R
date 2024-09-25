# Load necessary libraries
library(readxl)  # For reading Excel files
library(tidyverse)  # For data manipulation and visualization

# Read the data from an Excel file
data <- read_excel("/home/acheampong/Music/R_for_Data_Science/Pentadesma_butyracea /data.xlsx")

# View the data (for inspection purposes)
View(data)

# Pivot the data from wide to long format, reshaping the day columns to 'days' and 'diameter'
data1 <- data %>% pivot_longer(
  cols = starts_with('day'),
  names_to = 'days',  
  values_to = 'diameter',
  values_drop_na = FALSE
)

# Renaming the values in the days column into its intended values
data1 <- data1 %>% mutate(days1 = case_when(
  str_starts(days, 'day0') ~ 'day0',
  str_starts(days, 'day3') ~ 'day3',
  str_starts(days, 'day6') ~ 'day6',
  str_starts(days, 'day9') ~ 'day9',
  str_starts(days, 'day12') ~ 'day12',
  str_starts(days, 'day14') ~ 'day14',
  .default = days
))

# Drop the old 'days' column and rename 'days1' to 'days'
data1 <- data1 %>% select(-days) %>% rename(days = days1)

# Group the data by 'id' and 'days', calculate the mean diameter, and keep all columns
main_data <- data1 %>% group_by(id, days) %>% 
  mutate(mean_diameter = mean(diameter)) %>% 
  select(-diameter) %>% 
  distinct(mean_diameter, .keep_all = T)

# Reshape the weight data from wide to long format, renaming columns and adjusting values
main_data <- main_data %>% pivot_longer(
  cols = c(starts_with('WEIGHT')),
  names_to = "weight_day",
  values_to = 'weight'
)

# Renaming the values in  'weight_day' column into specific day groups
main_data <- main_data %>%
  mutate(weight_day = case_when(
    str_detect(weight_day, 'day 0') ~ 'day0',
    str_detect(weight_day, 'day 7') ~ 'day7',
    str_detect(weight_day, 'day 14') ~ 'day14',
    TRUE ~ weight_day
  ))

# Convert 'weight_day' and 'days' columns to factors for ordered levels
main_data <- main_data %>% 
  mutate(weight_day = factor(weight_day, levels = c("day0", "day7", "day14")),
         days = factor(days, levels = c('day0', 'day3', 'day6', 'day9', 'day12', 'day14')))

# Summarize the mean weight by 'treatments' and 'weight_day'
weight_data <- main_data %>%
  group_by(treatments, weight_day) %>% 
  summarise(mean_wight = mean(weight)) %>%
  arrange(treatments, weight_day)

# Plot the effect of treatment on weight over time
ggplot(weight_data, aes(x = weight_day, y = mean_wight, color = treatments, group = treatments)) +
  geom_line() + 
  geom_point() +  
  labs(title = "Effect of Treatment on Weight Over Time",
       x = "Days",
       y = "Weight") +
  theme_minimal() +
  theme(legend.position = "top")

# Summarize the mean wound diameter by 'treatments' and 'days'
tr_data <- main_data %>% group_by(treatments, days) %>% 
  summarise(mean_diameter = mean(mean_diameter))

# Plot the effect of treatment on wound diameter over time
ggplot(tr_data, aes(x = days, y = mean_diameter, color = treatments, group = treatments)) +
  geom_line() +
  geom_point() +
  labs(title = "Effect of Treatment on Wound Diameter Over Time",
       x = "Days",
       y = "Diameter") +
  theme_minimal() +
  theme(legend.position = "top")

# test the effect of treatment on the wound
anova_model <- aov(mean_diameter ~ treatments, data = main_data)
summary(anova_model)

# Perform Tukey's Honest Significant Difference (HSD) test for pairwise comparisons
TukeyHSD(anova_model)

# Install the 'nlme' package for repeated measures ANOVA
#install.packages("nlme")
library(nlme)

# Fit a repeated measures ANOVA model, 
# to test the effect of treatment, days and both on the wound by
# considering 'id' as a random effect
repeated_model <- lme(mean_diameter ~ treatments * days, random = ~1|id, data = main_data)
anova(repeated_model)

# Extract residuals from the repeated measures model
res <- residuals(repeated_model)

# Plot a histogram of the residuals to assess their distribution
hist(res, breaks = 20, main = "Histogram of Residuals", xlab = "Residuals")

# Create a Q-Q plot to check for normality of the residuals
qqnorm(res)
qqline(res, col = "red")

# test the effect of treatments on weight
model2 <- aov(weight ~ treatments, data = main_data)
summary(model2)

# Subset data for group 1 (Silver Sulfadiazine treatment) and select mean diameter
data0 <- main_data %>% filter(groups == 1) %>% 
  select(mean_diameter)
Silver_sulfadiazine <- data0$mean_diameter

# Subset data for groups 3 and 4 (Pentadesma butyracea cream treatment) and select mean diameter
data7 <- main_data %>% filter(groups == 3 | groups == 4) %>% 
  select(mean_diameter)
Pentadesma_butyracea_cream <- data7$mean_diameter

# Perform a t-test to compare if Pentadesma is more effective than Silver on the wound
t.test(Silver_sulfadiazine, Pentadesma_butyracea_cream, 
       paired = FALSE,
       alternative = 'less',
       var.equal = FALSE)
