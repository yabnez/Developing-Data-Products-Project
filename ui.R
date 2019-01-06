#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.

library(shiny)
# Define UI for application that draws a chart
shinyUI(fluidPage(
  titlePanel("Analysis of wholesale market in Kyoto"),
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("sliderMonth", "Choose month, or zero for all month", 0, 12, value = 0),
      selectInput("selectVF", "Select both/vegetable/fruit", c("both"="both", "vegetable"="vege","fruit"="fruit")),
      selectInput("selectPL", "Select all or other specific region", 
                  c("all"="all", "domestic"="domestic","import"="import",
                    "Kyoto"="kyoto", "USA"="USA", "China"="china")),
      checkboxInput("showModel", "Show/Hide Linear Model", value = TRUE),
      checkboxInput("showBox", "Show/Hide Boxplot", value = TRUE),
      checkboxInput("showSum", "Show/Hide Linear model summary", value = TRUE),
      textOutput("stat")
    ),
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("plot1"),
      plotOutput("plot2")
    ))
))