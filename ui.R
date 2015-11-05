library(shiny)
library(dygraphs)

shinyUI(fluidPage(
    titlePanel("Market Vis"),
    
    sidebarLayout(
        sidebarPanel(
            helpText("Total amount of"),
            checkboxInput("trades", "Trades", value = FALSE),
            checkboxInput("volume", "volume", value = FALSE),
            br(),
            checkboxInput("log", "Log Y scale", value = FALSE),
            width=2
            ),
        
        mainPanel(
            conditionalPanel("input.trades == true",
                dygraphOutput("tradeplot")),
            br(),
            conditionalPanel("input.volume == true",
                dygraphOutput("volumeplot")),
            conditionalPanel("input.volume == true || input.trades == true",
                helpText("Drag to zoom in and double click to reset.", align='center'))
        )
    )
))
