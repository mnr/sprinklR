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
                  round = TRUE)
    #   radioButtons(
    #   "showZones",
    #   h3("Show Zones"),
    #   choices = list(
    #     "All Zones" = 1,
    #     "Zone 1" = 2,
    #     "Zone 2" = 3
    #   ),
    #   selected = 1
    # )
    ), # end of sidebarPanel
    mainPanel(
      tabsetPanel(
        type = "pills",
        tabPanel("MM of Water",
                 plotOutput("mmOfWater"),
                 textOutput("yearDay")),
        tabPanel("Seconds", plotOutput("secondsOfWater")),
        tabPanel("Status",
                 textOutput("lastHeartbeat"),
                 textOutput("lastReboot"),
                 textOutput("location")
                 )
      )
    ) # end of main panel
  ) # end of sidebarLayout
  ) # end of fluidPage
