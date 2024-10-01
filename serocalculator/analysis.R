# Load necessary libraries
library(serocalculator)
library(dplyr)
library(ggplot2)

# Paths to the cross-sectional data
main_path = "/home/acheampong/Music/R_for_Data_Science/serocalculator/Ghana_sero_2024_STA_26_8_24_NEW.csv"

# Import and prepare cross-sectional data
main_data <- read.csv(main_path)

# Further processing of cleaned data
main_data <- main_data %>% group_by(Participant_id, antigen_iso) %>% 
  mutate(value = mean(result_adj)) %>% 
  distinct(value, .keep_all = TRUE) %>% 
  arrange(Participant_id)

sub_data <- main_data %>% mutate(age = Months / 12,
                     ageCat = case_when(
                       Age_group == 1 ~ "<5",
                       Age_group == 2 ~ "5-15",
                       Age_group == 3 ~ "16+",
                       TRUE ~ as.character(Age_group)
                     )) %>% 
  select(Participant_id, Cluster, Catchment_Area, age, ageCat, antigen_iso, value) %>% 
  rename(id = Participant_id, cluster = Cluster, catchment = Catchment_Area)

# Save the cleaned cross-sectional subset data as an RDS file
saveRDS(sub_data, file = "/home/acheampong/Music/R_for_Data_Science/serocalculator/sub_data.rds")

# Define the path to the saved subset data
sub_path = "/home/acheampong/Music/R_for_Data_Science/serocalculator/sub_data.rds"

# Load the cleaned cross-sectional subset data using serocalculator's `load_pop_data` function
sub_data <- load_pop_data(sub_path)

# path to longitudinal antibody parameters from the OSF
curve_path = "/home/acheampong/Music/R_for_Data_Science/serocalculator/SEES_mcmc_unstratified_df.rds"

# Import longitudinal antibody parameters from OSF
curve_data <- load_curve_params(curve_path) %>% 
  filter(antigen_iso %in% c('HlyE_IgA', 'HlyE_IgG'))

# path to biological noise parameters data
noise_path = "/home/acheampong/Music/R_for_Data_Science/serocalculator/SEES_NoiseParam.rds"

# load biological noise parameters data
noise_data <- load_noise_params(noise_path)

# Estimate Overall Seroincidence
## To determine the seroincidence of Salmonella Typhi using anti-HlyE IgA & IgG antibodies.
est_over_all <- est.incidence(
  pop_data = sub_data,
  curve_param = curve_data,
  noise_param = noise_data %>% filter(Country == "Ghana"),
  antigen_isos = c("HlyE_IgG", "HlyE_IgA")
)

summary(est_over_all)

# Stratified Seroincidence
## To determine the association of seroincidence of S. Typhi among the catchment population.
est_catchment = est.incidence.by(
  strata = c("catchment"),
  pop_data = sub_data,
  curve_params = curve_data, 
  noise_params = noise_data %>% filter(Country == "Ghana"),
  antigen_isos = c("HlyE_IgG", "HlyE_IgA"),
  num_cores = 8)


summary(est_catchment)

#color pallette for catchment
catchment.pal <- c('#EA6552', '#8F4B86', '#0099B4FF', '#5BC862', '#FFD700')

#Save summary(est2) as a dataframe and sort by incidence rate
est_catchmentdf <- summary(est_catchment) %>%
  arrange(incidence.rate)

#Create barplot with a white background and vertical bars
ggplot(est_catchmentdf, aes(x=reorder(catchment, incidence.rate), y=incidence.rate*1000, fill=catchment)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  geom_errorbar(aes(ymin=CI.lwr*1000, ymax=CI.upr*1000, width=.2)) + 
  labs(
    title= "Salmonella Typhi Seroincidence by Catchment",
    x="Country",
    y="Seroincidence rate per 1000 person-years"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(size=11, angle=45, hjust=1),
        axis.text.y = element_text(size=11)) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_fill_manual(values = catchment.pal)

## To estimate the age-specific seroincidence of S. typhi among participants.
est_age_specific = est.incidence.by(
  strata = c("ageCat"),
  pop_data = sub_data,
  curve_params = curve_data, 
  noise_params = noise_data %>% filter(Country == "Ghana"),
  antigen_isos = c("HlyE_IgG", "HlyE_IgA"),
  num_cores = 8)


summary(est_age_specific)

#color pallette for Age Specific
ageCat.pal <- c('#EA6552', '#8F4B86', '#0099B4FF')

#Save summary(est2) as a dataframe and sort by incidence rate
est_age_specificdf <- summary(est_age_specific) %>%
  arrange(incidence.rate)

#Create barplot with a white background and vertical bars
ggplot(est_age_specificdf, aes(x=reorder(ageCat, incidence.rate), y=incidence.rate*1000, fill=ageCat)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  geom_errorbar(aes(ymin=CI.lwr*1000, ymax=CI.upr*1000, width=.2)) + 
  labs(
    title= "Salmonella Typhi Seroincidence by Age Specific",
    x="Country",
    y="Seroincidence rate per 1000 person-years"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(size=11, angle=45, hjust=1),
        axis.text.y = element_text(size=11)) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_fill_manual(values = ageCat.pal)