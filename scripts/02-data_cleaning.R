#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 6 April 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(tidyverse)

#### Clean data ####
raw_bus_data <- read_csv("inputs/data/bus_data.csv")
raw_streetcar_data <- read_csv("inputs/data/streetcar_data.csv")
raw_subway_data <-read_csv("inputs/data/subway_data.csv")

View(raw_bus_data)
View(raw_streetcar_data)
View(raw_subway_data)
str(raw_bus_data)




#### Save data ####
write_csv(cleaned_data, "outputs/data/analysis_data.csv")
