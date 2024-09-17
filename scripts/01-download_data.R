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

install.packages("opendatatoronto")
install.packages("tidyverse")
install.packages("dplyr")

#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)
library(dplyr)

#### Download data ####

library(opendatatoronto)
library(dplyr)



# get package

package <- show_package("996cfe8d-fb35-40ce-b569-698d51fc683b")

package




#### Save data ####
# [...UPDATE THIS...]
# change the_raw_data to whatever name you assigned when you downloaded it.
#write_csv(the_raw_data, "inputs/data/raw_data.csv") 

         
