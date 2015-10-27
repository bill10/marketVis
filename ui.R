library(shiny)
library(dygraphs)

shinyUI(fluidPage(
    titlePanel("Market Vis"),
    
    sidebarLayout(
        sidebarPanel(
            helpText("Market statistics"),
            helpText("Drag to zoom in and double click to reset."),
            checkboxInput("trades", "Trades", value = FALSE),
            checkboxInput("volume", "volume", value = FALSE),
            br(),
            checkboxInput("log", "Log Y scale", value = FALSE)
            ),
        
        mainPanel(
            conditionalPanel("input.trades == true",
                dygraphOutput("tradeplot")),
            conditionalPanel("input.volume == true",
                dygraphOutput("volumeplot"))
        )
    )
))
