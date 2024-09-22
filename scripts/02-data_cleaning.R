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


#View(raw_bus_data)
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

#TODO: DO I NEED LINE? LOST BUS AND STREET LINE
raw_data_subway <- raw_data_subway |> select(-Time, -Bound, -Vehicle, -Gap)
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

raw_data_subway <- raw_data_subway |> select(Date, Day, vehicle, Location, Incident, Delay)
raw_data_subway
#View(raw_data_subway)

raw_data_streetcar <- raw_data_streetcar %>%
  mutate(line = as.numeric(NA))
raw_data_streetcar <- raw_data_streetcar |> select(-Vehicle, -Gap)
raw_data_streetcar <- raw_data_streetcar |> select(Date, Day, vehicle, Location, Incident, Delay)
raw_data_streetcar 

#View(raw_data_streetcar)

raw_data_bus
raw_data_bus <- raw_data_bus %>%
  mutate(line = as.numeric(NA))
raw_data_bus <- raw_data_bus |> select(-Direction, -Vehicle, -Gap)
raw_data_bus <- raw_data_bus |> select(Date, Time, Day, vehicle, Line, Location, Incident, `Min Delay`)
raw_data_bus <- raw_data_bus |> mutate(Line = as.character(Line))
raw_data_bus





#### Save data ####
write_csv(cleaned_data, "outputs/data/analysis_data.csv")
