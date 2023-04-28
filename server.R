library(tidyverse)
library(dplyr)
library(lubridate)
library(shiny)
library(dplyr)
library(magrittr)
library(shinythemes)
library(viridis)

#Read in files
df_mvsc_data <- read.csv("data/df_mvsc_data.csv")
df_blackhawk <- read.csv("data/df_blackhawk.csv")
df_crow <- read.csv("data/df_crow.csv")
df_duck <- read.csv("data/df_duck.csv")
df_kickapoo <- read.csv("data/df_kickapoo.csv")
df_ri <- read.csv("data/df_ri.csv")
df_rock_river <- read.csv("data/df_rock_river.csv")
df_walnut <- read.csv("data/df_walnut.csv")

#Set theme for all plots in shiny
plot_theme <- ggdark::dark_theme_gray(base_size = 14) + 
  theme(plot.title = element_text(),
        plot.background = element_rect(fill = "grey10"),
        panel.background = element_blank(),
        panel.grid.major = element_line(color = "grey30", size = 0.2),
        panel.grid.minor = element_line(color = "grey30", size = 0.2),
        legend.background = element_blank(),
        axis.ticks = element_blank(),
        legend.key = element_blank())

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
# Allow users to filter through the different watersheds for comparison
df_filter_watershed <- reactive({
    subset(df_mvsc_data, Watershed == input$Watershed)
  })
output$comment1 <- renderText({
  "Reactive to watershed and chemical inputs"
})
# compare presence of chemicals and their affects on the invertibrate population
output$invertibrate_chemical <- renderPlot({
  chemical_string <- str_to_title(gsub("\\.", " ", input$chemical))
  
  ggplot(df_filter_watershed(), aes_string(x = "Tot_inv_abun", y = input$chemical)) +
    geom_smooth() +
    ylab("invertibrate Count") +
    ggtitle(input$Watershed, "Presence of Chemicals and their affects on the invertibrate population") +
    xlab(input$chemical) +
    plot_theme
  
})
output$comment2 <- renderText({
  "Reactive to watershed, environment, and chemical inputs"
})
# compare environmental makeup and it's effects on the presence of chemicals
output$environment_chemical <- renderPlot({
  chemical_string <- str_to_title(gsub("\\.", " ", input$chemical))
  environment_string <- str_to_title(gsub("\\.", " ", input$environment))
  
  ggplot(df_filter_watershed(), aes_string(x = input$chemical, y = input$environment)) +
    geom_smooth() +
    ylab(input$environment) +
    ggtitle(input$Watershed, "Environmental makeup and it's effects on the presence of chemicals") +
    xlab(input$chemical) +
    plot_theme
  
})
output$comment3 <- renderText({
  "Reactive to watershed and chemical inputs"
})
# compare chemical presence and it's effects on mean oxygen saturation levels
output$oxygen_chemical <- renderPlot({
  chemical_string <- str_to_title(gsub("\\.", " ", input$chemical))
  
  ggplot(df_filter_watershed(), aes_string(x = input$chemical, y = "DO_per")) +
    geom_smooth() +
    ylab("DO_Per") +
    ggtitle(input$Watershed, "Chemical presence effects on mean oxygen saturation levels") +
    xlab(input$chemical) +
    plot_theme
  
})
output$comment4 <- renderText({
  "Reactive to watershed input"
})
# count of the total invertibrates present at each site within the watershed
output$total_inv <- renderPlot({
    ggplot(df_filter_watershed(), aes_string(x = "Site", y = "Tot_inv_abun", fill = "Site")) +
    geom_col() +
    ylab("Total invertibrates Present") +
    xlab("site") +
    ggtitle(input$Watershed,"Total number of invertibrates observed at each site") +
    plot_theme
})
output$comment5 <- renderText({
  "Reactive to watershed and invertibrate type inputs"
})
# build upon the previous code and break the invertibrates down to their type and then compare their populations again
output$type_of_inv <- renderPlot({
  invert_type_string <- str_to_title(gsub("\\.", " ", input$invertibrate_type))
  
  ggplot(df_filter_watershed(), aes_string(x = "Site", y = input$invertibrate_type, fill = "Site")) +
    geom_col() +
    ggtitle(input$Watershed,"Total number of each type of invertibrate observed at each site") +
    ylab(input$invertibrate_type) +
    xlab("Site") +
    plot_theme
})
output$comment6 <- renderText({
  "(Reactive to watershed, environment, and invertibrate type inputs) The recorded environments effect on the type of invertibrate present at each site"
})
# compare the dominant environments recorded at each site and it's effect on the invertibrate types present
output$environments_by_site <- renderPlot({
  invert_type_string <- str_to_title(gsub("\\.", " ", input$environment))
  
  ggplot(df_filter_watershed(), aes_string(x = "Site", y = input$environment, fill = "Site")) +
    geom_col() +
    ggtitle(input$Watershed,input$environment) +
    ylab(input$invertibrate_type) +
    xlab("Site") +
    plot_theme
})
output$comment7 <- renderText({
  "Reactive to watershed inputs"
})
# compare the mean saturated oxygen levels at each site within the watersheds
output$oxygen_by_site <- renderPlot({
  
  ggplot(df_filter_watershed(), aes_string(x = "Site", y = "DO_per", fill = "Site")) +
    geom_col() +
    ggtitle(input$Watershed,"Mean saturated oxygen levels") +
    ylab("Mean saturated oxygen levels recorded at each site") +
    xlab("Site") +
    plot_theme
})
})
