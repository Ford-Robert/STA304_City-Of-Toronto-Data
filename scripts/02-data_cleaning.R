#### Preamble ####
# Purpose: Cleans the raw bus, streetcar, and subway data
# Author: Robert Ford
# Date: 21 September
# Contact: robert.ford@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# Any other information needed

#### Workspace setup ####
library(tidyverse)
library(readxl)

#### Clean data ####
raw_data_bus <- read_csv("inputs/data/bus_data.csv")
raw_data_streetcar <- read_csv("inputs/data/streetcar_data.csv")
raw_data_subway <-read_csv("inputs/data/subway_data.csv")
#subway_codes <- read_csv("inputs/data/subway-delay-codes.csv")


View(raw_data_bus)
#View(raw_streetcar_data)
#View(raw_data_subway)
#str(raw_bus_data)



raw_data_subway <- raw_data_subway %>%
  mutate(Incident = case_when(
    grepl("^EU|^ER", Incident) ~ "Mechanical",
    grepl("^PU|^PR", Incident) ~ "Rail/Switches",
    grepl("^SU|^SR", Incident) ~ "Security",
    grepl("^TU|^TR", Incident) ~ "Operations",
    grepl("^MR|^MU", Incident) ~ "General Delay",
    Incident == "PREL" ~ "Overhead",
    TRUE ~ "Other"
  ))

#Taken, with few modifications, from Luca Carnegie
#Check out his Repo here: https://github.com/lcarnegie/TTCTransitAnalysis.git

#Add vehicle column 

raw_data_subway$vehicle <- "Subway"
raw_data_streetcar$vehicle <- "Streetcar"
raw_data_bus$vehicle <- "Bus"

raw_data_subway <- raw_data_subway |> select(-Time, -Bound, -Vehicle, -Gap)
raw_data_subway <- rename(raw_data_subway, Location = Station)

raw_data_subway <- raw_data_subway |> select(Date, Day, vehicle, Location, Incident, Delay)
raw_data_subway


raw_data_streetcar <- raw_data_streetcar |> select(-Vehicle, -Gap)
raw_data_streetcar <- raw_data_streetcar |> select(Date, Day, vehicle, Location, Incident, Delay)
raw_data_streetcar 

raw_data_bus <- raw_data_bus |> select(-Direction, -Vehicle, -Gap)
raw_data_bus <- raw_data_bus |> select(Date, Day, vehicle, Location, Incident, Delay)




#View(raw_data_subway)
#View(raw_data_streetcar)
#View(raw_data_bus)


#Combine the three datasets 
combined_data <- bind_rows(raw_data_bus, raw_data_streetcar, raw_data_subway)




unique_incidents <- combined_data %>%
  group_by(Incident) %>%
  slice(1) %>%
  ungroup()

#View(unique_incidents)


#Fix some categories
combined_data <- combined_data |> mutate(
  Incident =
    case_match(
      Incident,
      "Cleaning" ~ "Cleaning", 
      "Cleaning - Disinfection" ~ "Cleaning",
      "Cleaning - Unsanitary" ~ "Cleaning",
      "Collision - TTC" ~ "Collision",
      "Collision - TTC Involved" ~ "Collision",
      "Diversion" ~ "Diversion",
      "Emergency Services" ~ "Emergency Services",
      "General Delay" ~ "General Delay",
      "Held By" ~ "Held By",
      "Investigation" ~ "Investigation",
      "Late" ~ "Late",
      "Late Entering Service" ~ "Late Entering Service",
      "Late Entering Service - Mechanical" ~ "Late Entering Service",
      "Late Leaving Garage" ~ "Late Leaving Garage",
      "Late Leaving Garage - Management" ~ "Late Leaving Garage",
      "Late Leaving Garage - Mechanical" ~ "Late Leaving Garage",
      "Late Leaving Garage - Operations" ~ "Late Leaving Garage",
      "Late Leaving Garage - Operator" ~ "Late Leaving Garage",
      "Late Leaving Garage - Vision" ~ "Late Leaving Garage",
      "Management" ~ "Management",
      "Mechanical" ~ "Mechanical",
      "Operations" ~ "Operations",
      "Operations - Operator" ~ "Operations",
      "Overhead" ~ "Overhead",
      "Overhead - Pantograph" ~ "Overhead",
      "Rail/Switches" ~ "Rail/Switches",
      "Road Block - Non-TTC Collision" ~ "Collision",
      "Road Blocked - NON-TTC Collision" ~ "Collision",
      "Roadblock by Collision - Non-TTC" ~ "Collision",
      "Security" ~ "Security",
      "Securitty" ~ "Security",  # Handling the typo
      "Utilized Off Route" ~ "Diversion",
      "Utilizing Off Route" ~ "Diversion",
      "Vision" ~ "Vision",
      "e" ~ "Other",  # Handling unknown category
      "NA" ~ "N/A",
      .default = Incident  # Retain unmatched values
    )
)
View(combined_data)


#From Test we need to Remove some rows that are corrupted
# I first remove any rows that contain an NA, though this data may be accurate
# I want my analysis to focus on the complete record


#### Save data ####
write_csv(combined_data, "outputs/data/cleaned_dataset.csv")

