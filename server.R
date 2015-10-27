library(shiny)
library(dygraphs)
library(parallel)
library(zoo)

progress <- shiny::Progress$new()
on.exit(progress$close())
progress$set(message = "Loading Data", value = 0.1)
files=sapply(1:25, function(t){sprintf("Data/counts-201004%02d.KP.csv",t)})
allData=do.call(rbind, 
    mclapply(1:25, function(t) {
        f=sprintf("Data/counts-201004%02d.KP.csv",t)
        if (file.exists(f)) {
            data=read.csv(f, header=FALSE, col.names = c('Time', 'Symbol', 'Trades', 'Volume'), colClasses = c("character",'NULL',NA,NA))
            data=aggregate(data[,-1],by=list(Time=data$Time),FUN=sum)
            data$Date=sprintf("201004%02d",t)
        }
        else {
            data=NULL
        }
        return(data)},
        mc.cores=10)
    )
progress$set(message = "Loading Data", value = 0.6)
if (!is.null(allData)) {
    data=read.zoo(allData,index.column = c('Date','Time'), format = "%Y%m%d %H:%M:%S", tz="")
} else {
    data=NULL
}
progress$set(message = "Loading Data", value = 1)

shinyServer(function(input, output) {
    output$plot <- renderDygraph({
        if (!is.null(data)) {
            graph=dygraph(data$Price, ylab = "Price") %>% dyRangeSelector() #%>% dyOptions(logscale=input$log)
            output$plotHelp = renderText("Drag to zoom in and double click to reset.")
        }
        else {
            graph=NULL
        }
        progress$set(message = "Rendering in Browser", value = 1)
        return(graph)
    })
})