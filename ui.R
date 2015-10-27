library(shiny)
library(dygraphs)

shinyUI(fluidPage(
    titlePanel("Stock Vis"),
    
    sidebarLayout(
        sidebarPanel(
            helpText("Total trades and volume"),

            br(),

            checkboxInput("trades", "Trades", value = FALSE),
            
            checkboxInput("volume", "volume", value = FALSE)
            ),
        
        mainPanel(dygraphOutput("plot"),
                  helpText(textOutput("plotHelp"), align='center'))
    )
))
