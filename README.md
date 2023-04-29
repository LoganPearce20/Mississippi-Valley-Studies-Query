# Mississippi-Valley-Studies-Query
## Introduction
This is a shiny application built for the Mississippi Valley Studies Center that explores field data that they have collected at various watersheds in the Quad Cities

## Shiny App URL
A working version of this app has been published and hosted through Shinyapps.io, and is accessible via the link below.
http://loganpearce20.shinyapps.io/Mississippi-Valley-Studies-Query

## R Script Directory
* mvsc-query.R ~ Data cleaning and dataframe creation
* ui.R ~ creation of ui for shiny app
* server.R ~ creation of server and all visualizations present within the shinyApp

## Reading in Data
```r
df_mvsc_data <- data.table::fread("data/Site Assessment Master with Meta data.csv", data.table = F)
```

## Selecting Data Columns for Analysis
```r
df_mvsc_data <- df_mvsc_data[, c(1:2, 90:146)]
```

## Filtering Each Watershed to Create Individual Dataframes (Code repeated for each watershed)
```r
df_blackhawk <- df_mvsc_data %>%
  filter(Watershed == "Blackhawk") %>%
  arrange(Site)
```

## Write Dataframes as .csv 
```r
write_csv(df_mvsc_data, "data/df_mvsc_data.csv")
write_csv(df_blackhawk, "data/df_blackhawk.csv")
write_csv(df_crow, "data/df_crow.csv")
write_csv(df_duck, "data/df_duck.csv")
write_csv(df_kickapoo, "data/df_kickapoo.csv")
write_csv(df_ri, "data/df_ri.csv")
write_csv(df_rock_river, "data/df_rock_river.csv")
write_csv(df_walnut, "data/df_walnut.csv")
```

# Creation of UI
* Read in .csv files
```r
df_mvsc_data <- read.csv("data/df_mvsc_data.csv")
df_blackhawk <- read.csv("data/df_blackhawk.csv")
df_crow <- read.csv("data/df_crow.csv")
df_duck <- read.csv("data/df_duck.csv")
df_kickapoo <- read.csv("data/df_kickapoo.csv")
df_ri <- read.csv("data/df_ri.csv")
df_rock_river <- read.csv("data/df_rock_river.csv")
df_walnut <- read.csv("data/df_walnut.csv")
```
* Setting the theme for the shinyApp
```r
theme = shinytheme("cyborg")
```
* Allows users to make choices that determine the data the plots are using
```r
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
  ```
  * Create tabs to make the shinyApp more user friendly
  ```r
   mainPanel(
        fluidRow(
          # Set tabs for more asthetic presentation of graphs 
          tabsetPanel(
            tabPanel("Invertibrates present within the watersheds",htmlOutput("comment4"), plotOutput("total_inv"), htmlOutput("comment5"), plotOutput("type_of_inv")),
            tabPanel("Environments present within the watersheds",htmlOutput("comment6"), plotOutput("environments_by_site")),
            tabPanel("Oxygen levels present within the watersheds",htmlOutput("comment7"), plotOutput("oxygen_by_site")),
            tabPanel("Chemicals present and their effects on the watersheds",htmlOutput("comment1"), plotOutput("invertibrate_chemical"),htmlOutput("comment2"), plotOutput("environment_chemical"), htmlOutput("comment3"), plotOutput("oxygen_chemical")),
     )
```
# Creation of Server for ShinyApp
* Read in .csv files
```r
df_mvsc_data <- read.csv("data/df_mvsc_data.csv")
df_blackhawk <- read.csv("data/df_blackhawk.csv")
df_crow <- read.csv("data/df_crow.csv")
df_duck <- read.csv("data/df_duck.csv")
df_kickapoo <- read.csv("data/df_kickapoo.csv")
df_ri <- read.csv("data/df_ri.csv")
df_rock_river <- read.csv("data/df_rock_river.csv")
df_walnut <- read.csv("data/df_walnut.csv")
```
* Set theme for all plots within the shiny
```r
plot_theme <- ggdark::dark_theme_gray(base_size = 14) + 
  theme(plot.title = element_text(),
        plot.background = element_rect(fill = "grey10"),
        panel.background = element_blank(),
        panel.grid.major = element_line(color = "grey30", size = 0.2),
        panel.grid.minor = element_line(color = "grey30", size = 0.2),
        legend.background = element_blank(),
        axis.ticks = element_blank(),
        legend.key = element_blank())
```
## Visualization Creation
### Bar Chart's
* Create reactive for charts that allows the user to select the watersheds
```r
df_filter_watershed <- reactive({
    subset(df_mvsc_data, Watershed == input$Watershed)
```
* Create comments for each visualization
```r
output$comment1 <- renderText({
  "Reactive to watershed and chemical inputs"
```
* Create a bar chart that shows the total number of invertibrates found in each watershed
```r
output$total_inv <- renderPlot({
    ggplot(df_filter_watershed(), aes_string(x = "Site", y = "Tot_inv_abun", fill = "Site")) +
    geom_col() +
    ylab("Total invertibrates Present") +
    xlab("site") +
    ggtitle(input$Watershed,"Total number of invertibrates observed at each site") +
    plot_theme
})
```
* Create a bar chart to show the dominate environmental makeup of each watershed's sites
```r
output$environments_by_site <- renderPlot({
  invert_type_string <- str_to_title(gsub("\\.", " ", input$environment))
  
  ggplot(df_filter_watershed(), aes_string(x = "Site", y = input$environment, fill = "Site")) +
    geom_col() +
    ggtitle(input$Watershed,input$environment) +
    ylab(input$invertibrate_type) +
    xlab("Site") +
    plot_theme
})
```
* Create a bar chart to show mean saturated oxygen levels present at each watersheds sites based on their overall environmental makeup
```r
output$oxygen_by_site <- renderPlot({
  
  ggplot(df_filter_watershed(), aes_string(x = "Site", y = "DO_per", fill = "Site")) +
    geom_col() +
    ggtitle(input$Watershed,"Mean saturated oxygen levels") +
    ylab("Mean saturated oxygen levels recorded at each site") +
    xlab("Site") +
    plot_theme
})
```
### Line Charts
* Create line charts to analyze the previous charts findings and how they are affected by the presence of various chemicals
```r
output$invertibrate_chemical <- renderPlot({
  chemical_string <- str_to_title(gsub("\\.", " ", input$chemical))
  
  ggplot(df_filter_watershed(), aes_string(x = "Tot_inv_abun", y = input$chemical)) +
    geom_smooth() +
    ylab("invertibrate Count") +
    ggtitle(input$Watershed, "Presence of Chemicals and their affects on the invertibrate population") +
    xlab(input$chemical) +
    plot_theme
  
})
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
output$oxygen_chemical <- renderPlot({
  chemical_string <- str_to_title(gsub("\\.", " ", input$chemical))
  
  ggplot(df_filter_watershed(), aes_string(x = input$chemical, y = "DO_per")) +
    geom_smooth() +
    ylab("DO_Per") +
    ggtitle(input$Watershed, "Chemical presence effects on mean oxygen saturation levels") +
    xlab(input$chemical) +
    plot_theme
  
})
```
