# Clear existing workspace 
rm(list=ls()) 

# Set working directory 
setwd("C:\\Datin\\PhD\\Chopsy behavioural data")

# install/load packages
install.packages("psych",dependencies = TRUE)	
install.packages("ggplot2", dependencies=TRUE)
install.packages("gmodels", dependencies=TRUE)
install.packages("dplyr", dependencies = TRUE)
install.packages("tidyverse", dependencies = TRUE)
install.packages("writexl", dependencies = TRUE)
install.packages("readxl", dependencies = TRUE)

library(psych)
library(ggplot2)
library(gmodels)
library(dplyr)
library(tidyverse)
library(writexl)
library(readxl)

# Read csv-format file 
ethnicity <- read.csv("Chopsy Behavioural Study Demographic Data Report PART 1.csv",stringsAsFactors = TRUE)

# Check data integrity
head(ethnicity)
tail (ethnicity)
dim(ethnicity)
names(ethnicity)
summary(ethnicity)

# tabulate data 
table(ethnicity$birth_country_participant)
table(ethnicity$birth_country_participant_other)
table(ethnicity$birth_country_mother)
table(ethnicity$birth_country_mother_other)
table(ethnicity$birth_country_father)
table(ethnicity$birth_country_father_other)

# Define ethnicity 'other'
#ethnicity_other <- ethnicity %>%
#mutate(case_when(ethnicity$birth_country_participant == "Other" ~ ethnicity$birth_country_participant_other,
#                 ethnicity$birth_country_mother == "Other" ~ ethnicity$birth_country_mother_other,
#                 ethnicity$birth_country_father == "Other" ~ ethnicity$birth_country_father_other))

# Define conditions for ethnicity classification
#condition_1 <- ifelse(ethnicity$birth_country_participant == "Netherlands",'TRUE',
#                         (ifelse(ethnicity$birth_country_participant == "Unknown", 'UNKNOWN', 'FALSE'))) #if participant born in NL output = TRUE, if not output = FALSE, if unknown output = UNKNOWN
#condition_2 <- ifelse(ethnicity$birth_country_mother == "Netherlands", 'TRUE',
#                      (ifelse(ethnicity$birth_country_mother == "Unknown", 'UNKNOWN', 'FALSE'))) #if participant's mother born in NL output = TRUE, if not output = FALSE, if unknown output = UNKNOWN
#condition_3 <- ifelse(ethnicity$birth_country_father == "Netherlands", 'TRUE',
#                      (ifelse(ethnicity$birth_country_father == "Unknown", 'UNKNOWN', 'FALSE'))) #if participant's father born in NL output = TRUE, if not output = FALSE, if unknown output = UNKNOWN

# Define conditions for ethnicity classification
condition_1 <- ifelse(ethnicity$birth_country_participant == "Netherlands",'TRUE','FALSE') #if participant born in NL output = TRUE, if not output = FALSE, if unknown output = UNKNOWN
condition_2 <- ifelse(ethnicity$birth_country_mother == "Netherlands", 'TRUE','FALSE') #if participant's mother born in NL output = TRUE, if not output = FALSE, if unknown output = UNKNOWN
condition_3 <- ifelse(ethnicity$birth_country_father == "Netherlands", 'TRUE','FALSE')#if participant's father born in NL output = TRUE, if not output = FALSE, if unknown output = UNKNOWN


# Define new variable 'country of origin' based on CBS NL classification         
ethnicity_classification <-ethnicity %>%
  mutate(country_of_origin = case_when(condition_1 == 'FALSE' ~ ethnicity$birth_country_participant, 
                                       condition_1 == 'TRUE' & condition_2 == 'FALSE' & condition_3 == 'FALSE' | condition_3 == 'TRUE'  ~ ethnicity$birth_country_mother, 
                                       condition_1 == 'TRUE' & condition_2 == 'TRUE' & condition_3 == 'FALSE' ~ ethnicity$birth_country_father,
                                       condition_1 == 'TRUE' & condition_2 =='TRUE' & condition_3 == 'TRUE' ~ ethnicity$birth_country_participant)) 

# NOTES
## 1) if participant is born outside NL, then country of origin = birth country of participant
## 2) if participant's birth country is unknown, then country of origin = birth country of mother
## 3) if participant is born in NL and both mother and father were born abroad, then country of origin = mother's birth country
## 4) if participant is born in NL and mother was born in NL, then country of origin = birth country of father
### mutate() allows you to create a new column within the existing data frame 'ethnicity'
### casewhen() allows you to vectorize multiple ifelse() statements 
### both functions require dplyr package 

table(ethnicity_classification$country_of_origin)
write_xlsx(ethnicity_classification,"C:\\Users\\Gebruiker\\OneDrive\\PhD\\Chopsy behavioural data\\ethnicity_classification.xlsx")

# Read csv-format file 
ethnicity_classification.xls <- read_excel("C:\\Users\\Gebruiker\\OneDrive\\PhD\\Chopsy behavioural data\\ethnicity_classification.xlsx")
table(ethnicity_classification.xls$country_of_origin)








