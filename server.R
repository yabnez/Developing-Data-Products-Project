#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.

library(shiny)
library(ggplot2)
library(ggsci)

# Define server logic required to draw a chart
shinyServer(function(input, output) {
  if (!exists("vege.clean")) {
    vege <- read.csv("./WholesaleKyoto.csv")
    vege.clean <- vege[!is.na(vege$month),]
    vege.clean <- vege.clean[vege.clean$average.price!="#DIV/0!",]
    vege.clean$quantity<- as.numeric(gsub(",", "", vege.clean$quantity))
    vege.clean$amount.yen<- as.numeric(gsub(",", "", vege.clean$amount.yen))
    vege.clean$average.price<- as.numeric(gsub(",", "", vege.clean$average.price))
    vege.clean <- vege.clean[vege.clean$quantity>1,]
  }
  pref <- as.character(unique(vege.clean$place))
  domestic <- pref[1:which(pref=="Okinawa")]
  import <- pref[which(pref=="Okinawa")+1:length(pref)]

  preparation <- reactive ({
    if (input$sliderMonth==0) {
      vege2 <- vege.clean
    } else {
      vege2 <- vege.clean[vege.clean$month==input$sliderMonth,]
    }
    vege2 <- switch(input$selectVF, "both"=vege2,
                    "vege" =vege2[vege2$type=="vegetable",],
                    "fruit"=vege2[vege2$type=="fruit",])
    vege2 <- switch(input$selectPL, "all"=vege2,
                    "domestic"=vege2["%in%"(vege2$place, domestic),],
                    "import"  =vege2["%in%"(vege2$place, import),],
                    "kyoto"   =vege2[vege2$place=="Kyoto",],
                    "USA"     =vege2[vege2$place=="USA",],
                    "china"   =vege2[vege2$place=="China",])
  })
  output$plot1 <- renderPlot({
    # type
    vege2 <- preparation()
    g <- ggplot(vege2, aes(x=quantity, y=average.price, color=type, size=amount.yen))
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
      vege2 <- preparation()
      g <- ggplot(vege2, aes(x=quantity, y=average.price, color=type))
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
      vege2 <- preparation()
      model <- lm(average.price ~ quantity, vege2)
      append("Adjusted R-squared: ", 
             as.character(round(as.numeric(summary(model)["adj.r.squared"]), 5)))
    }
  })
})