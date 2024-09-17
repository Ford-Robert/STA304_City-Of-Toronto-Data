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

library(opendatatoronto)
library(dplyr)

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

extract_data <- function(package_id, resource_names) {
  # List all resources from the package
  resources <- list_package_resources(package_id)
  
  # Filter resources based on the provided names
  selected_resources <- resources %>%
    filter(name %in% resource_names)
  
  # Create a named list to store each dataset separately
  extracted_data <- setNames(lapply(selected_resources$id, get_resource), 
                             selected_resources$name)
  
  return(extracted_data)
}

# Extract the data (each dataset is stored separately in the list)
subway_data_list <- extract_data(subway_package_id, subway_resource_names)

# View individual data frames (example for one dataset)
View(subway_data_list[["ttc-subway-delay-data-2023"]])

#### Save data ####
# [...UPDATE THIS...]
# change the_raw_data to whatever name you assigned when you downloaded it.
#write_csv(the_raw_data, "inputs/data/raw_data.csv") 

         
