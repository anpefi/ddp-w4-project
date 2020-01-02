library(shiny)
library(shinydashboard)
library(tidyverse)
library(lubridate)
library(DT)
library(plotly)


data <- read_csv("data/running_data.csv")
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    getRaces <- reactive({
        if (input$type=="Races") stype <- "Race"
        if (input$type=="All") stype <- c("Default","Race" ,"Fartlek","Long","Easy","Tempo","Interval","treadmill","Hill","Warm up")
        if (input$type=="Training") stype <- c("Default","Fartlek","Long","Easy","Tempo","Interval","treadmill","Hill","Warm up")
          data %>% 
            filter(is.element(Type, stype), between(Distance, input$dist[1],input$dist[2]),
                   between(Date,ymd(input$dateSlider[1]), ymd(input$dateSlider[2]))
                   ) %>%
            select(Date,Course,Distance,Duration,Pace,OverallPlace,FieldSize,Weight)
    })
    
    getSummary <- reactive({
        getRaces() %>% summarise(n=n(),'Mean Duration'=hms::as_hms(round(mean(Duration))), 
                                 'Best Duration'=hms::as_hms(min(Duration)),
                                 'Worst Duration' = hms::as_hms(max(Duration)),
                                 'Mean Pace'=hms::as_hms(round(mean(Pace))), 
                                 'Best Pace'=hms::as_hms(min(Pace)),
                                 'Worst Pace' = hms::as_hms(max(Pace))
                                 )
    })
    
    getWeightPlot <- reactive({
        
        getRaces() %>% ggplot(aes(x=Weight,y=Pace,color=Distance)) + geom_point() +
            geom_smooth(method = "lm") + labs(x="Weight (Kg)", y="Pace (h:m:s/Km)")
    })
    
    getLmodel <- reactive({
        model <- lm(as.numeric(seconds(Pace)) ~ Weight, getRaces()) %>% summary
        model$coefficients
    })
    
    output$racesTable <- renderDataTable({ getRaces() })
    output$summaryTable <- renderTable({ t(getSummary()) },rownames = T, colnames = F)
    output$weightPlot <- renderPlotly({getWeightPlot()})
   
    output$lmodel <- renderText({md <- getLmodel()
    tmd <- paste0("lm: Pace(seconds) = ",md[1,1]," + ",md[2,1],"*weight;  p-value = ",md[2,4])
    tmd})
    output$coeff <- renderText({getLmodel()[2,1]})

})
