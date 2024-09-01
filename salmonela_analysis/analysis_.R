#clear environment
rm(list = ls())
graphics.off()

# load libraries
library(tidyverse)
library(corrplot)
library(caret)
library(scales)

# load data
main_data <- read_csv(file.choose())

# inspect the data
View(main_data)

# converting categorical variables to factors
# ttr_positive: 1 = positive, 2 = negative
# tvib_positive: 1 = positive, 2 = negative
# stag_positive: 1 = positive, 2 = negative
# s_typhi: 1 = s_typhi detected, 2 = s_typhi not detected
# flow_speed: 1 = fast, 2 = slow, 3 = stagnant, 4 = dry
# depth_of_wastewater_sewage: 1 = shallow, 2 = medium, 3 = deeep, 4 = not sure
# width_of_wastewater_sewage: 1 = (<1m), 2 = (1-2m), 3 = (>2m)
# water_quality: 1 = yes, 2 = no
# not_recoverd: 1 = yes, 2 = no

main_data <- main_data %>% 
  mutate(
    s_typhi = factor(s_typhi, levels = c(1, 0), labels = c("postivie", "negative")),
    flow_speed = factor(flow_speed, levels = c(1, 2), 
                        labels = c("fast", "slow")),
    depth_of_wastewater_sewage = factor(depth_of_wastewater_sewage, levels = c(1, 2, 3), 
                                        labels = c("shallow", "medium", "deep")),
    width_of_wastewater_sewage = factor(width_of_wastewater_sewage, levels = c(1, 2, 3), 
                                        labels = c("<1m", "1-2m", ">2m")),
    not_recovered = factor(not_recovered, levels = c(1, 2), labels = c("yes", "no")),
    singleplex = factor(singleplex, levels = c(1, 2), labels = c("yes", "no"))
  )


main_data <- main_data %>% select(-site_name, -water_quality, -calibrate)


# View the update
View(main_data)


# Step 1: Create a mini dataset "group_data" from "main_data"
group_data <- main_data %>% 
  group_by(visit, s_typhi) %>% 
  summarise(S_typhi = n())

# Step 2: Create a month column based on visit
group_data <- group_data %>% 
  mutate(month_ = case_when(
    visit == 1 ~ "JUL",
    visit == 2 ~ "AUG-SEPT",
    visit == 3 ~ "OCT",
    visit == 4 ~ "NOV",
    visit == 5 ~ "DEC-JAN",
    visit == 6 ~ "JAN-FEB"
  ))

# Step 3: Filter only positive values
positive_data <- group_data %>%
  filter(s_typhi == "postivie")

# Step 4: Include rain fall values based on visit
positive_data <- positive_data %>% 
  mutate(rain_fall = case_when(
    visit == 1 ~ 120.9,
    visit == 2 ~ 141,
    visit == 3 ~ 99.6,
    visit == 4 ~ 88.3,
    visit == 5 ~ 39.1,
    visit == 6 ~ 38.8
  ))

# Step 5: Select the appropriate columns
positive_data <- positive_data %>% 
  select(month_, S_typhi, rain_fall)

# Step 6: Reshape the data into long format
positive_longer <- positive_data %>% 
  pivot_longer(c(S_typhi, rain_fall), names_to = 'bar', values_to = 'count')

# Step 7: Define the desired order of months
month_order <- c("JUL", "AUG-SEPT", "OCT", "NOV", "DEC-JAN", "JAN-FEB")

# Step 8: Convert month_ to a factor with specified levels
positive_longer$month_ <- factor(positive_longer$month_, levels = month_order)

# Step 9: Create the bar plot using ggplot2 with months in ascending order
ggplot(positive_longer, aes(x = month_, y = count, fill = bar)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Months", y = "Values", title = "S_typhi and rain fall association") +
  scale_fill_manual(values = c("blue", "red")) +
  theme_minimal()

# adding the rain_fall variable
main_data <- main_data %>% 
  mutate(rain_fall = case_when(
    visit == 1 ~ 120.9,
    visit == 2 ~ 141,
    visit == 3 ~ 99.6,
    visit == 4 ~ 88.3,
    visit == 5 ~ 39.1,
    visit == 6 ~ 38.8
  ))


# Exploratory Data Analysis (EDA):

#   1) Examine the summary statistics of the variables
main_data %>% summary()

#   2) Check for missing values in your data and handle them appropriately if needed
sum(is.na(main_data))

# 3) Explore the distribution of your dependent variable s_typhi
# Bar plot for s_typhi
main_data %>% 
  ggplot(aes(x = S_Typhi, fill = S_Typhi)) +
  geom_bar() +
  xlab("Samonella Typhi") +
  labs(title = "Distribution of Samonella Typhi")

# In the dataset, the class distribution of the dependent variable s_typhi is imbalanced, 
#with the "not_detected" class significantly more prevalent than the "detected" class.

#"detected": 229 occurrences
#"not_detected": 517 occurrences
#This imbalance can potentially lead to biased model performance, 
#as the model may be more inclined to predict the majority class ("not_detected") more frequently, 
#resulting in lower sensitivity or recall for the minority class ("detected").


# Correlation Analysis:
#   1) Examine correlation among independent variables for potential multicollinearity issues 

summary_stats <- main_data %>%
  group_by(s_typhi) %>%
  summarise(count = n()) %>%
  mutate(percentage = count / sum(count) * 100)

numeric_vars <- sapply(main_data, is.numeric)
cor_data <- main_data[, numeric_vars]
cor_matrix <- cor(cor_data)

# View the correlation matrix
print(cor_matrix)

# Plot the correlation matrix
corrplot(cor_matrix, method = "color", addCoef.col = "black", 
         tl.col = "black", tl.srt = 45, tl.cex = 0.8, cl.cex = 0.8)


# Find pairs of variables with high correlation
high_correlation_pairs <- findCorrelation(cor_matrix, cutoff = 0.7)

# Print pairs of variables with high correlation
print(high_correlation_pairs)
correlated_variables <- colnames(main_data[, numeric_vars])[high_correlation_pairs]

# variables with high correlations
correlated_variables

# removing total_dissolved_solids variable to see the effect
cor_data <- cor_data[, -9]

# finding the correlation
cor_matrix_2 <- cor(cor_data)

# Plot the correlation matrix
corrplot(cor_matrix_2, method = "color", addCoef.col = "black", 
         tl.col = "black", tl.srt = 45, tl.cex = 0.8, cl.cex = 0.8)

# removing total_dissolved_solids from the data
main_data <- main_data %>% 
  select(-total_dissolved_solids)


# To determine the association between environmental water physicochemical parameters
# and Salmonella detection
# Fit a logistic regression model
logistic_model <- glm(s_typhi ~ temp + orp + p_h + do + ec + tds + sal + ssg, 
                      data = main_data, family = "binomial")

# Display model summary
summary(logistic_model)


# To determine the distribution and association between S. Typhi detection, flow rate and
# other characteristics of water sources.
logistic_model_2 <- glm(s_typhi ~ flow_speed + width_of_wastewater_sewage +
                          depth_of_wastewater_sewage,
                        data = main_data, family = 'binomial')

summary(glm(s_typhi ~ rain_fall,
    data = main_data, family = 'binomial'))
# Display model summary
summary(logistic_model_2)


# To compare the correlation between the load of Salmonella Typhi and the
# physicochemical parameters of environmental samples.

# Selecting relevant variables
selected_variables <- c("temp", "orp", 
                        "p_h", "do", "ec",  'tds', 'sal')

# Subset the data
selected_data <- main_data[, selected_variables]

# Convert 's_typhi' to a numeric variable
selected_data$s_typhi_numeric <- as.numeric(selected_data$s_typhi) - 1

# Calculate the correlation matrix
cor_matrix_3 <- cor(selected_data[, c("temp", "orp", 
                                      "p_h", "do", "ec", 'tds', 'sal')])

# Plot the correlation matrix
corrplot(cor_matrix_3, method = "color", addCoef.col = "black", 
         tl.col = "black", tl.srt = 45, tl.cex = 0.8, cl.cex = 0.8)

