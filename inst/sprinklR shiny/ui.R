#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

#Define UI for application

fluidPage(# Application title
  titlePanel("Irrigation Status"),

  #Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("displayRange","Range of Days",
                  min = 7, max = 366/2, value = 7,
                  round = TRUE),
      p("Documentation located at https://niemannross.com/link/irrigation")

    ), # end of sidebarPanel
    mainPanel(
      tabsetPanel(
        type = "pills",
        tabPanel("MM of Water",
                 plotOutput("mmOfWater")),
        tabPanel("Seconds", plotOutput("secondsOfWater")),
        tabPanel("Status",
                 textOutput("lastHeartbeat"),
                 textOutput("lastReboot"),
                 textOutput("location"),
                 textOutput("yearDay"),
                 htmlOutput("logfile")
                 ),
        tabPanel("Raw Data", tableOutput("rawData"))
      )
    ) # end of main panel
  ) # end of sidebarLayout
  ) # end of fluidPage
