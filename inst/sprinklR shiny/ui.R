#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


# Define UI for application that draws a histogram
fluidPage(
  # Application title
  titlePanel("Irrigation Status"),

  #Sidebar with a slider input for number of bins
  sidebarLayout(sidebarPanel(
    radioButtons("showZones", h3("Show Zones"),
                 choices = list("All Zones" = 1, "Zone 1" = 2,
                                "Zone 2" = 3),selected = 1)

      ), # end of sidebarPanel
    mainPanel(
      plotOutput("distPlot"),
      hr(),
      textOutput("statusString")
    ) #end of mainPanel
 ) # end of sidebarLayout
) # end of fluidPage
