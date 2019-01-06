#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.

library(shiny)
library(ggplot2)
library(ggsci)

# Define server logic required to draw a chart
shinyServer(function(input, output) {
  if (!exists("vegi.clean")) {
    vegi <- read.csv("./WholesaleKyoto.csv")
    vegi.clean <- vegi[!is.na(vegi$month),]
    vegi.clean <- vegi.clean[vegi.clean$average.price!="#DIV/0!",]
    vegi.clean$quantity<- as.numeric(gsub(",", "", vegi.clean$quantity))
    vegi.clean$amount.yen<- as.numeric(gsub(",", "", vegi.clean$amount.yen))
    vegi.clean$average.price<- as.numeric(gsub(",", "", vegi.clean$average.price))
    vegi.clean <- vegi.clean[vegi.clean$quantity>1,]
  }
  pref <- as.character(unique(vegi.clean$place))
  domestic <- pref[1:which(pref=="Okinawa")]
  import <- pref[which(pref=="Okinawa")+1:length(pref)]

  preparation <- reactive ({
    if (input$sliderMonth==0) {
      vegi2 <- vegi.clean
    } else {
      vegi2 <- vegi.clean[vegi.clean$month==input$sliderMonth,]
    }
    vegi2 <- switch(input$selectVF, "both"=vegi2,
                    "vegi" =vegi2[vegi2$type=="vegitable",],
                    "fruit"=vegi2[vegi2$type=="fruit",])
    vegi2 <- switch(input$selectPL, "all"=vegi2,
                    "domestic"=vegi2["%in%"(vegi2$place, domestic),],
                    "import"  =vegi2["%in%"(vegi2$place, import),],
                    "kyoto"   =vegi2[vegi2$place=="Kyoto",],
                    "USA"     =vegi2[vegi2$place=="USA",],
                    "china"   =vegi2[vegi2$place=="China",])
  })
  output$plot1 <- renderPlot({
    # type
    vegi2 <- preparation()
    g <- ggplot(vegi2, aes(x=quantity, y=average.price, color=type, size=amount.yen))
    g <- g + geom_point(alpha=0.4) + theme_bw()
    g <- g + xlab("Quantity (pcs)") + ylab("Average price (yen)")
    g <- g + theme(legend.position = c(0.99, 0.50), legend.justification = c(1, 0))
    g <- g + scale_color_nejm()
    g <- g + scale_x_log10(breaks=10^(1:9), labels=10^(1:9))
    g <- g + scale_y_log10(breaks=c(0,10,50,100,500,1000,5000,10000,50000),
                           labels=c(0,10,50,100,500,1000,5000,10000,50000))
    if (input$showModel)
      g <- g + stat_smooth(method = "lm", colour = "black", size = 1)
    print(g)
  })
  output$plot2 <- renderPlot({
    if (input$showBox) {
      vegi2 <- preparation()
      g <- ggplot(vegi2, aes(x=quantity, y=average.price, color=type))
      g <- g + geom_boxplot(outlier.shape = NA) + theme_bw()
      g <- g + xlab("Quantity (pcs)") + ylab("Average price (yen)")
      g <- g + theme(legend.position = c(0.95, 0.80), legend.justification = c(1, 0))
      g <- g + scale_color_nejm()
      g <- g + scale_x_log10(breaks=10^(1:9), labels=10^(1:9))
      g <- g + scale_y_log10(breaks=c(0,10,50,100,500,1000,5000,10000,50000),
                             labels=c(0,10,50,100,500,1000,5000,10000,50000))
      g <- g + geom_jitter(size = 0.2)
      print(g)
    }
  })
  
  output$stat <- renderText({
    if (input$showSum) {
      vegi2 <- preparation()
      model <- lm(average.price ~ quantity, vegi2)
      append("Adjusted R-squared: ", 
             as.character(round(as.numeric(summary(model)["adj.r.squared"]), 5)))
    }
  })
})