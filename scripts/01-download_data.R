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


# Function to extract data for a given package and resource names
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

# Subway delay data
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

# Bus delay data
bus_package_id <- "e271cdae-8788-4980-96ce-6a5c95bc6618"
bus_resource_names <- c("ttc-bus-delay-data-2014",
                        "ttc-bus-delay-data-2015",
                        "ttc-bus-delay-data-2016",
                        "ttc-bus-delay-data-2017",
                        "ttc-bus-delay-data-2018",
                        "ttc-bus-delay-data-2019",
                        "ttc-bus-delay-data-2020",
                        "ttc-bus-delay-data-2021",
                        "ttc-bus-delay-data-2022",
                        "ttc-bus-delay-data-2023",
                        "ttc-bus-delay-data-2024")

# Streetcar delay data
streetcar_package_id <- "b68cb71b-44a7-4394-97e2-5d2f41462a5d"
streetcar_resource_names <- c("ttc-streetcar-delay-data-2014",
                              "ttc-streetcar-delay-data-2015",
                              "ttc-streetcar-delay-data-2016",
                              "ttc-streetcar-delay-data-2017",
                              "ttc-streetcar-delay-data-2018",
                              "ttc-streetcar-delay-data-2019",
                              "ttc-streetcar-delay-data-2020",
                              "ttc-streetcar-delay-data-2021",
                              "ttc-streetcar-delay-data-2022",
                              "ttc-streetcar-delay-data-2023",
                              "ttc-streetcar-delay-data-2024")

# Extract data for subway, bus, and streetcar
subway_data_list <- extract_data(subway_package_id, subway_resource_names)
bus_data_list <- extract_data(bus_package_id, bus_resource_names)
streetcar_data_list <- extract_data(streetcar_package_id, streetcar_resource_names)

#View(subway_data_list[["ttc-subway-delay-data-2024"]])
#View(bus_data_list[["ttc-bus-delay-data-2021"]])
#View(streetcar_data_list[["ttc-streetcar-delay-data-2019"]])


#In the bus as street car datasets columns 2 and 3 change data type and what
#they represent over time. So they must be removed in order to collapse the data
remove_columns <- function(data_list, columns_to_remove) {
  # Initialize an empty list to store the modified data frames
  modified_data_list <- list()
  
  # Helper function to remove columns from a data frame
  remove_cols_from_df <- function(df, cols_to_remove) {
    if (is.numeric(cols_to_remove)) {
      # Remove columns by index
      num_cols <- ncol(df)
      cols_to_remove_actual <- cols_to_remove[cols_to_remove <= num_cols]
      df <- df[ , -cols_to_remove_actual, drop = FALSE]
    }
    else {
      stop("columns_to_remove should be numeric indices.")
    }
    return(df)
  }
  
  # Loop over each dataset in the provided data list
  for (dataset_name in names(data_list)) {
    data <- data_list[[dataset_name]]
    
    # Check if the data is a list of data frames (e.g., monthly data)
    if (is.list(data) && !is.data.frame(data)) {
      # Apply the helper function to each data frame in the list
      modified_monthly_data <- lapply(data, remove_cols_from_df, cols_to_remove = columns_to_remove)
      
      # Store the list of modified monthly data frames in the modified data list
      modified_data_list[[dataset_name]] <- modified_monthly_data
    } else {
      # For single data frames
      data_df <- data  # Ensure we're working with a data frame
      
      # Remove the specified columns
      data_df <- remove_cols_from_df(data_df, columns_to_remove)
      
      # Store the modified data frame in the list
      modified_data_list[[dataset_name]] <- data_df
    }
  }
  
  # Return the list of modified data frames
  return(modified_data_list)
}



columns_to_remove_indices <- c(2, 3)

bus_data_trimmed <- remove_columns(bus_data_list, columns_to_remove_indices)
streetcar_data_trimmed <- remove_columns(streetcar_data_list, columns_to_remove_indices)

#Extra column in April of 2019 Streetcar data
temp_df <- streetcar_data_trimmed[["ttc-streetcar-delay-data-2019"]][["Apr 2019"]]
temp_df <- temp_df[, -4]
streetcar_data_trimmed[["ttc-streetcar-delay-data-2019"]][["Apr 2019"]] <- temp_df

#Extra column in April of 2019 Bus data
temp_df <- bus_data_trimmed[["ttc-bus-delay-data-2019"]][["Apr 2019"]]
temp_df <- temp_df[, -4]
bus_data_trimmed[["ttc-bus-delay-data-2019"]][["Apr 2019"]] <- temp_df

#Extra column in Dec of 2021 Bus data
temp_df <- bus_data_trimmed[["ttc-bus-delay-data-2021"]][["Dec 21"]]
temp_df <- temp_df[, -9]
bus_data_trimmed[["ttc-bus-delay-data-2021"]][["Dec 21"]] <- temp_df

#View(bus_data_trimmed)
#View(streetcar_data_trimmed)






#### Save data ####
# [...UPDATE THIS...]
# change the_raw_data to whatever name you assigned when you downloaded it.
#write_csv(the_raw_data, "inputs/data/raw_data.csv") 


