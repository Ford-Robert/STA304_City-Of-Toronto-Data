#### Preamble ####
# Purpose: Simulates Delay data for the; Subway, Bus, and Streetcar
# Author: Robert Ford
# Date: 16 September 2024
# Contact: robert.ford@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# Any other information needed?


#### Workspace setup ####
library(dplyr)
library(lubridate)

#### Simulate data ####
set.seed(304)

incident_types <- c('Mechanical', 'General Delay', 'Emergency Services', 'Investigation', 'Signal Issue', 'Medical Emergency')
vehicles <- c('Bus', 'Streetcar', 'Subway')

# Simulate data
data_sim <- tibble(
  Incident = sample(incident_types, 50, replace = TRUE),
  Delay = sample(5:60, 50, replace = TRUE),
  Vehicle = sample(vehicles, 50, replace = TRUE),         
  Date = sample(seq(as.Date('2014-01-01'), as.Date('2024-12-31'), by="day"), 50, replace = TRUE)  # Random dates between 2014 and 2024
)

print(head(data_sim, 5))




