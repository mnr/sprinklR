#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(jsonlite)

# Define server logic required to draw a histogram
function(input, output, session) {
  waterByZone = fromJSON("https://niemannross.com/sprinklR/heartbeat_data.json")
  output$statusString <- renderText({paste("Last Reboot:",waterByZone$last_reboot,
                                           " at ", waterByZone$iam)})
  output$statusString2 <- renderText({paste("Last heartbeat:",waterByZone$modified)})

    # output$last_heartbeat <-

  output$distPlot <- renderPlot({
    # draw the barplot
    barplot(
      height = waterByZone$wbz_NeededZone1,
      ylab = 'mm of water',
      main = 'Sprinkler System Status',
      xlim = c(0, 366),
      space = 0,
      density = 20,
      angle = 135,
      col = 'green',
      border = NA
    )
    barplot(
      height = waterByZone$wbz_NeededZone2,
      col = 'blue',
      border = NA,
      space = 0,
      angle = 45,
      density = 20,
      border = NA,
      add = TRUE
    )
    lines(waterByZone$wbz_rainfall, col = "red")
    lines(waterByZone$wbz_evapotranspiration, col = "blue")

    axis(
      side = 1,
      at = floor(seq(
        from = 0,
        to = 366,
        length.out = 13
      )),
      labels = c(month.abb, " ")
    )

  })

}
