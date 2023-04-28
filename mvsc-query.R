library(tidyverse)
library(dplyr)
library(tidyverse)
library(lubridate)
library(shiny)
library(dplyr)
library(magrittr)
library(readxl)

rm(list = ls())

# Read in data 
df_mvsc_data <- data.table::fread("data/Site Assessment Master with Meta data.csv", data.table = F)

#Selecting the columns that Dr. Risner called the meat and potatoes of the dataset
df_mvsc_data <- df_mvsc_data[, c(1:2, 90:146)]

#filter data for each site
df_blackhawk <- df_mvsc_data %>%
  filter(Watershed == "Blackhawk") %>%
  arrange(Site)

df_crow <- df_mvsc_data %>%
  filter(Watershed == "Crow") %>%
  arrange(Site)

df_duck <- df_mvsc_data %>%
  filter(Watershed == "Duck") %>%
  arrange(Site)

df_kickapoo <- df_mvsc_data %>%
  filter(Watershed == "Kickapoo") %>%
  arrange(Site)

df_ri <- df_mvsc_data %>%
  filter(Watershed == "Rock Island") %>%
  arrange(Site)

df_rock_river <- df_mvsc_data %>%
  filter(Watershed == "Rock River") %>%
  arrange(Site)

df_walnut <- df_mvsc_data %>%
  filter(Watershed == "Walnut") %>%
  arrange(Site)

# Write csv's back into data folder
write_csv(df_mvsc_data, "data/df_mvsc_data.csv")
write_csv(df_blackhawk, "data/df_blackhawk.csv")
write_csv(df_crow, "data/df_crow.csv")
write_csv(df_duck, "data/df_duck.csv")
write_csv(df_kickapoo, "data/df_kickapoo.csv")
write_csv(df_ri, "data/df_ri.csv")
write_csv(df_rock_river, "data/df_rock_river.csv")
write_csv(df_walnut, "data/df_walnut.csv")
