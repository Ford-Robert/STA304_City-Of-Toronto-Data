#### Preamble ####
# Purpose: Tests of Cleaned and Combined TTC data
# Author: Robert Ford
# Date: 24 September 2024
# Contact: robert.ford@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# Any other information needed?
# Taken, with few modifications, from Luca Carnegie
# Check out his Repo here: https://github.com/lcarnegie/TTCTransitAnalysis.git


#### Workspace setup ####
library(tidyverse)
dataset <- read_csv("outputs/data/cleaned_dataset.csv")

# Load necessary libraries
library(dplyr)
library(testthat)

# Assume df is your data frame
df <- dataset

test_that("Data frame has correct columns", {
  expected_cols <- c("Date", "Day", "vehicle", "Location", "Incident", "Delay")
  expect_equal(colnames(df), expected_cols)
})

# Test that there are no missing Delay values
test_that("No missing values in Delay column", {
  expect_equal(sum(is.na(df$Delay)), 0)
})

# Test that the Date column is within the expected range and Delay is non-negative
test_that("Date and Delay values are within reasonable range", {
  min_date <- as.Date("2014-01-01")
  max_date <- as.Date("2024-12-31")
  
  # Check that the Date is within the range
  expect_true(all(df$Date >= min_date & df$Date <= max_date))
  
  # Check that Delay is non-negative
  expect_true(all(df$Delay >= 0))
})

num_delays_over_1000 <- sum(df$Delay > 1000)
print(num_delays_over_1000)

# Test that categorical columns have expected levels
test_that("Categorical columns have expected levels", {
  expect_true(all(df$Day %in% c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")))
  expect_true(all(df$vehicle %in% c("Subway", "Bus", "Streetcar")))
})
