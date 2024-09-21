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
raw_bus_data <- read_csv("inputs/data/bus_data.csv")
raw_streetcar_data <- read_csv("inputs/data/streetcar_data.csv")
raw_subway_data <-read_csv("inputs/data/subway_data.csv")
subway_codes <- read_csv("inputs/data/subway-delay-codes.csv")

View(subway_codes)
View(raw_bus_data)
View(raw_streetcar_data)
View(raw_subway_data)
str(raw_bus_data)



raw_subway_data <- raw_subway_data %>%
  mutate(Incident = case_when(
    grepl("^EU|^ER", Incident) ~ "Mechanical",
    grepl("^PU|^PR", Incident) ~ "Rail/Switches",
    grepl("^SU|^SR", Incident) ~ "Security",
    grepl("^TU|^TR", Incident) ~ "Operations",
    grepl("^MR|^MU", Incident) ~ "General Delay",
    Incident == "PREL" ~ "Overhead",
    TRUE ~ "Other"
  ))

#Directly Taken from Luca Carnegie
#Check out his Repo here: https://github.com/lcarnegie/TTCTransitAnalysis.git

raw_data_subway <- rename(raw_data_subway, Location = Station)
raw_data_subway <- raw_data_subway |> mutate(
  Line =
    case_match(
      Line,
      "YU" ~ "1",
      "BD" ~ "2", 
      "SRT" ~ "3", 
      "SHP" ~ "4",
      "YU / BD" ~ "1",
      "BD/YU" ~ "2", 
      "BLOOR DANFORTH & YONGE" ~ "2",
      "YUS/BD" ~ "1",
      "BD LINE 2" ~ "2", 
      "999" ~ "NA",
      "YUS" ~ "1",
      "YU & BD" ~ "1",
      "77 SWANSEA" ~ "NA"
    )
)





#### Save data ####
write_csv(cleaned_data, "outputs/data/analysis_data.csv")
