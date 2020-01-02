library(shiny)
library(shinydashboard)
library(tidyverse)
library(DT)
library(plotly)


# Define UI for application that draws a histogram
dashboardPage(
    dashboardHeader(title = "Anpefi's running data (2011-2019)"),
    dashboardSidebar(
        selectInput("type",
            h3("Type:"),
            choices = c("Races","Training","All"),
            selected = "Races"
        ),
        sliderInput(
            "dist",
            h3("Run distance:"),
            min = 2,
            max = 50,
            value = c(2, 50)
        ),
        dateRangeInput(
            "dateSlider",
            h3("Date range:"),
            start = "2011-01-01",
            end = "2019-12-31",
            min = "2011-01-01",
            max = "2019-12-31",
            weekstart = 1
        ),
        hr(),
        h5("Made by Andrés Pérez Figueroa"),
        HTML("<a href=\"https://github.com/anpefi/ddp-w4-project\">Link to the Github code source</a>")
        
    ), 
    dashboardBody(
        fluidRow(
            box(title = "About", width = 12,
                h4("This Shiny app is part of an assigment for the Coursera's developing Data Products"),
                h4("Here, I use my own data about my weight and my activities as
                   a runner, which I have been collecting for 9 years (from 2011
                   to 2019). With the controls in the sidebar you can filter the 
                   activities by type (Racing, training, or all together), by 
                   distance in Km (using the slider to select the range) or by dates 
                   (between January 1, 2011 and on December 31, 2019). Once filtered, 
                   in the main panel you can observe a few summary statistics, 
                   a table with the selected activities and the values for different 
                   variables. To the right you will have a chart with the relationship 
                   between my weight (Kg) and pace (time/   Km), together with a linear 
                   regression model that attempts to predict the pace according to my weight.")
            )
        ),
        hr(),
        fluidRow(
            box(title = "SUMMARY", width = 3, tableOutput("summaryTable")),
            box(title = "Pace vs. Weight", width = 9,
            h4("With the current filter, the linear model estimation is that an increment in 1 Kg of weight, will increase in ", textOutput("coeff",inline = T), " seconds the pace."),
            plotlyOutput("weightPlot"), 
            h3(textOutput("lmodel"))
            )
        ),
        fluidRow(box(title=h2("Selected activities"), width = 12, 
                    h3("Variables"),
                    h5("Date: date of the activity"),
                    h5("Course: In races, name of the race. In training, id of the route"),
                    h5("Distance; Distance of the activity in Km"),
                    h5("Duration: Duration of the activity in hours:minutes:seconds"),
                    h5("Pace: Aerage pace of the activity, time spent per kilometer"),
                    h5("OverallPlace: In races, the place at the finish"),
                    h5("FieldSize: In races, the total number of finishers"),
                    h5("Weight: weight, in Kg, measured the day of the activity"),
                     dataTableOutput("racesTable")))
    )
   
)
