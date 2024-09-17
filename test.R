#### Preamble ####
# Purpose: Downloads and saves the data from open data toronto. Specifically:
# - TTC streetcar delay data from 2014-2024
# - TTC bus delay data from 2014-2024
# - TTC subway delay data from 2017-2024
# Author: Robert Ford
# Date: 16 September 2024
# Contact: robert.ford@mail.utoronto.ca
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#install.packages("opendatatoronto")
#install.packages("tidyverse")
#install.packages("dplyr")


#### Workspace setup ####
library(tidyverse)
library(readxl)

#### Download data ####

library(opendatatoronto)
library(dplyr)

# Function to filter resources by name
filter_resources <- function(package_id, resource_names) {
  resources <- list_package_resources(package_id)
  relevant_resources <- resources %>%
    filter(name %in% resource_names)
  return(relevant_resources)
}

# Function to download and combine resources
download_and_combine_resources <- function(relevant_resources) {
  combined_data <- lapply(relevant_resources$id, function(resource_id) {
    resource_data <- relevant_resources %>%
      filter(id == resource_id) %>% 
      get_resource()
    
    data <- resource_data %>%
      opendatatoronto::get_resource() %>%
      as.data.frame()
    
    return(data)
  }) %>% bind_rows()
  
  return(combined_data)
}
# General function to process delay data
process_delay_data <- function(package_id, resource_names) {
  relevant_resources <- filter_resources(package_id, resource_names)
  combined_data <- download_and_combine_resources(relevant_resources)
  return(combined_data)
}

# Subway delay data example
subway_package_id <- "996cfe8d-fb35-40ce-b569-698d51fc683b"
subway_resource_names <- c("ttc-subway-delay-jan-2014-april-2017",
                           "ttc-subway-delay-may-december-2017",
                           "ttc-subway-delay-data-2018",
                           "ttc-subway-delay-data-2019",
                           "ttc-subway-delay-data-2020",
                           "ttc-subway-delay-data-2021",
                           "ttc-subway-delay-data-2022",
                           "ttc-subway-delay-data-2023",
                           "ttc-subway-delay-data-2024")

# Step 1: Filter resources based on names
relevant_resources <- filter_resources(subway_package_id, subway_resource_names)
View(relevant_resources)

# Step 2: Download and combine the resources
subway_data <- download_and_combine_resources(relevant_resources)
View(subway_data)

# View the combined data
View(subway_data)

