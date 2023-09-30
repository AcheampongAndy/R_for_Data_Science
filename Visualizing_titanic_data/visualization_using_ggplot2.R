library(ggplot2)

#Load titanic dataset for analysis
titan = read.csv("/home/acheampong/Downloads/titanic.csv", stringsAsFactors = FALSE)
View(titan)

# Set Up Factor variables
titan$Survived = as.factor(titan$Survived)
titan$Pclass = as.factor(titan$Pclass)
titan$Sex = as.factor(titan$Sex)
titan$Embarked = as.factor(titan$Embarked)

# First question - What was the survival rate?
# As Survived is the factor (ie. categorical variable),
# a bar chart is a great visualization to use
ggplot(titan, aes(x = Survived)) +
  geom_bar()

# If you really want the percentages
prop.table(table(titan$Survived))

# Add some customizations for lables and themes
ggplot(titan, aes(x = Survived)) +
  theme_bw() +
  geom_bar() +
  labs(y = "Passenger Count",
       title = "Titanic Survival Rate")

#
# Second Question - What was the survival rate per gender?
#
# we can use color to look at the two aspects (i.e., dimensions)
# of the data simultaneously
#
ggplot(titan, aes(x = Sex, fill = Survived)) +
  theme_bw() +
  geom_bar() +
  labs(y = "Passenger Count", 
       title = "Titanic Survival Rate by Gender")
#
#Third question - What was the survival rate by class of ticket?
#
ggplot(titan, aes(x = Pclass, fill = Survived)) +
  theme_bw() +
  geom_bar() +
  labs(x = "Passenger Count", 
       title = "Titanic Survival Rate by Ticket Class")
prop.table(table(titan$Survived, titan$Pclass))
#
# Fourth question - What was the survival rate by class of ticket
#                  and gender?
# we can leverage facets to further segment the data and enable 
# "visual drill-down" into the data
#
ggplot(titan, aes(x = Sex, fill = Survived)) +
  theme_bw() +
  facet_wrap(~ Pclass) +
  geom_bar() +
  labs(y = "Passenger Count",
       title = "Titanic Survival Rate by Pclass and Gender")
prop.table(table(titan$Survived, titan$Pclass, titan$Sex))
#
# Next we will move on to visualizing continuous (i.e., numeric)
# data using ggplot2. We will explore the visualizations of single
# numeric variables (i.e., columns) and also illustrate how 
# ggplot enables visual drill downs on numeric data.
#

#
# Fifth question - What is the distributions of passenger ages?
# The histogram is a stable of visualizing numeric data as it very 
# powerfully communicate the distribution of variable (i.e., columns)
#
ggplot(titan, aes(x = Age)) +
  theme_bw() +
  geom_histogram(binwidth = 5) +
  labs(y = "Passenger Count",
       x = "Age (binwidth = 5)",
       title = "Titanic Age Distribution")

#
# Sixth question - What are survival rates by age?
#
ggplot(titan, aes(x = Age, fill = Survived)) +
  theme_bw() +
  geom_histogram(binwidth = 5) +
  labs(y = "Passenger Count",
       x = "Age (binwidth = 5)",
       title = "Titanic Survival Rate by Age")
#
# Another great visualization for this question is the box-and-wiskey
# plot
#
ggplot(titan, aes(x = Survived, y = Age)) +
  theme_bw() +
  geom_boxplot() +
  labs( x = "Survived",
        y = "Age",
        title = "Titanic Survival Rate by Age"
  )
#
# Seventh Question - What is the survival rate by age when segmented by
#                    gender and class of ticket?
ggplot(titan, aes(x = Age, fill = Survived)) +
  theme_bw() +
  facet_wrap(Sex ~ Pclass) +
  geom_density(alpha = 0.5) +
  labs(y = "Age",
       x = "Survived",
       title = "Titanic Survival Rate by Age, Pclass and Sex")
#
# We can also use histogram
#
ggplot(titan, aes(x = Age, fill = Survived)) +
  theme_bw() +
  facet_wrap(Sex ~ Pclass) +
  geom_histogram(binwidth = 5) +
  labs(y = "Age",
       x = "Survived",
       title = "Titanic Survival Rate by Age, Pclass and Sex")
