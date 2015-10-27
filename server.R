library(shiny)
library(dygraphs)
library(parallel)
library(zoo)

allData=do.call(rbind, 
    mclapply(1:25, function(t) {
        f=sprintf("Data/counts-201004%02d.KP.csv",t)
        if (file.exists(f)) {
            data=read.csv(f, header=FALSE, col.names = c('Time', 'Symbol', 'Trades', 'Volume'), colClasses = c("character",'NULL',NA,NA))
            if (nrow(data)==0) {
                return(NULL)
            }
            data=aggregate(data[,-1],by=list(Time=data$Time),FUN=sum)
            data$Date=sprintf("201004%02d",t)
        }
        else {
            data=NULL
        }
        return(data)},
        mc.cores=10)
    )

if (!is.null(allData)) {
    data=read.zoo(allData,index.column = c('Date','Time'), format = "%Y%m%d %H:%M:%S", tz="")
} else {
    data=NULL
}

shinyServer(function(input, output) {
    output$tradeplot <- renderDygraph({
        if (input$trades==TRUE) {
            if (!is.null(data)) {
                return(dygraph(data$Trades, ylab = "Trades") %>% dyRangeSelector() %>% dyOptions(logscale=input$log))
            }
        }
        return(NULL)
    })
    
    output$volumeplot <- renderDygraph({
        if (input$volume==TRUE) {
            if (!is.null(data)) {
                return(dygraph(data$Volume, ylab = "Volume") %>% dyRangeSelector() %>% dyOptions(logscale=input$log))
            }
        }
        return(NULL)
    })
})