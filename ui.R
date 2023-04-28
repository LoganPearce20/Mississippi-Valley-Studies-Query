library(tidyverse)
library(dplyr)
library(lubridate)
library(shiny)
library(dplyr)
library(magrittr)
library(shinythemes)
library(viridis)

# Read in files
df_mvsc_data <- read.csv("data/df_mvsc_data.csv")
df_blackhawk <- read.csv("data/df_blackhawk.csv")
df_crow <- read.csv("data/df_crow.csv")
df_duck <- read.csv("data/df_duck.csv")
df_kickapoo <- read.csv("data/df_kickapoo.csv")
df_ri <- read.csv("data/df_ri.csv")
df_rock_river <- read.csv("data/df_rock_river.csv")
df_walnut <- read.csv("data/df_walnut.csv")

# set column names for input selections 
column_names<-colnames(df_mvsc_data)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
    theme = shinytheme("cyborg"),
    # Sets text elements of data.table since the RStudio browser 
    # uses old version of the web kit 
    # took from michaels work on march madness
    tags$script(HTML({"
    $(document).ready(function() {
      var isRStudio = /rstudio/.test(navigator.userAgent.toLowerCase());
      if (isRStudio) {
        $('<style>.dataTables_wrapper .dataTables_info { color: white !important; }</style>').appendTo('head');
      }
    });
  "})),
    
    # Custom CSS for the DataTable to change font color
    # I learned CSS for this...
    # took from michaels work on march madness
    tags$style(HTML({"
    .dataTables_wrapper {
      color: white;
    }
    table.dataTable thead th,
    table.dataTable tfoot th,
    .dataTables_filter label,
    .dataTables_length label{
      color: white;
      font-weight: bold;
    }
    .dataTables_wrapper .dataTables_info {  # Updated selector with higher specificity
    color: white;
    font-weight: bold;
    }
    .dataTables_paginate .paginate_button {
      background-color: #3c3c3c;
      color: white;
      border: none;
    }
    .dataTables_paginate .paginate_button.current,
    .dataTables_paginate .paginate_button:hover {
      background-color: #565656;
      color: white;
      border: none;
    }
    .dataTables_paginate .paginate_button.disabled {
      background-color: #3c3c3c;
      color: #999999;
      border: none;
      cursor: not-allowed;
    }
    table.dataTable thead tr {
      background-color: #3c3c3c;
    }
  "})),
    # Application title
    titlePanel("Mississippi Valley Studies Center"),

    # Sidebar with select inputs for watershed, chemical, environment, and invertibrate type
    sidebarLayout(
      sidebarPanel(
         selectizeInput("Watershed",
                        'Choose a Watershed:',
                        choices = distinct(df_mvsc_data, df_mvsc_data$Watershed)),
         selectizeInput("chemical",
                        "Choose a chemical:",
                        choices = colnames(select(df_mvsc_data, Chloride, Arsenic, Mercury, Lead)),
                        selected = "Chloride"),
         selectizeInput("invertibrate_type",
                        "Choose an invertibrate type:",
                        choices = colnames(select(df_mvsc_data, FFG_Pred, FFG_Graze, FFG_Collect_Gath, FFG_Collect_Filt, FFG_Shredder)),
                        selected = "Forest"),
         selectizeInput("environment",
                        "Choose an environment:",
                        choices = colnames(select(df_mvsc_data, Wetland, Forest, Grass, Agricultural)),
                        selected = "Wetland"),
      ),
        # Show a plot of the generated distribution
      mainPanel(
        fluidRow(
          # Set tabs for more asthetic presentation of graphs 
          tabsetPanel(
            tabPanel("Invertibrates present within the watersheds",htmlOutput("comment4"), plotOutput("total_inv"), htmlOutput("comment5"), plotOutput("type_of_inv")),
            tabPanel("Environments present within the watersheds",htmlOutput("comment6"), plotOutput("environments_by_site")),
            tabPanel("Oxygen levels present within the watersheds",htmlOutput("comment7"), plotOutput("oxygen_by_site")),
            tabPanel("Chemicals present and their effects on the watersheds",htmlOutput("comment1"), plotOutput("invertibrate_chemical"),htmlOutput("comment2"), plotOutput("environment_chemical"), htmlOutput("comment3"), plotOutput("oxygen_chemical")),
     )
)))))
