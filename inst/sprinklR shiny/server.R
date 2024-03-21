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

  output$lastReboot <- renderText({paste("Last Reboot: ", waterByZone$last_reboot)})
  output$lastHeartbeat <- renderText({paste("Last Heartbeat: ",waterByZone$modified)})
  output$location <- renderText({paste("I am: ",waterByZone$iam)})
  dayOfYear <- as.POSIXlt(Sys.Date())$yday + 1
  output$yearDay <- renderText(paste("Day of Year: ", dayOfYear))

  getStartDayOfYear <- function() {
    startDayOfYear <- dayOfYear - input$displayRange
    return(ifelse(startDayOfYear < 0, 0, startDayOfYear))
  }

  getEndDayOfYear <- function() {
    endDayOfYear <- dayOfYear + input$displayRange
    return(ifelse(endDayOfYear > 366, 366, endDayOfYear))
  }

  trimDisplayRange <- function() {
    # trim waterByZone according to input$displayRange
    startDayOfYear <- getStartDayOfYear()
    endDayOfYear <- getEndDayOfYear()

    trimmedWBZ <- rbind(waterByZone$wbz_rainfall,
                        waterByZone$wbz_NeededZone1,
                        waterByZone$wbz_NeededZone2,
                        waterByZone$wbz_WateredZone1,
                        waterByZone$wbz_WateredZone2,
                        waterByZone$wbz_SecondsWateredZone1,
                        waterByZone$wbz_SecondsWateredZone2,
                        waterByZone$wbz_evapotranspiration)

    rownames(trimmedWBZ) <- names(waterByZone)[c(3,4,5,6,7,8,9,10)]
    colnames(trimmedWBZ) <- c(1:366)

    return(trimmedWBZ[ , startDayOfYear:endDayOfYear])
  }



  output$mmOfWater <- renderPlot({
    trimmedWBZ <- trimDisplayRange()
    startDayOfYear <- getStartDayOfYear()
    endDayOfYear <- getEndDayOfYear()

    # draw the barplot
    barplot(
      height = trimmedWBZ["wbz_NeededZone1", ],
      ylab = 'mm of water',
      main = 'Sprinkler System Status',
      xlim = c(0, (2 * input$displayRange)),
      space = 0,
      density = 20,
      angle = 135,
      col = 'cyan',
      border = NA
    )
    barplot(
      height = trimmedWBZ["wbz_NeededZone2", ],
      col = 'magenta',
      space = 0,
      angle = 45,
      density = 20,
      border = NA,
      add = TRUE
    )
    lines(trimmedWBZ["wbz_rainfall", ], col = "red")
    lines(trimmedWBZ["wbz_evapotranspiration", ], col = "blue")
    lines(trimmedWBZ["wbz_WateredZone1", ], lty = "twodash", col = "brown")
    lines(trimmedWBZ["wbz_WateredZone2", ], lty = "twodash", col = "darkgoldenrod1")

    axis(
      side = 1,
      at = floor(seq(
        from = getStartDayOfYear(),
        to = getEndDayOfYear(),
        length.out = 13
      )),
      labels = c(month.abb, " ")
    )

  })

  output$secondsOfWater <- renderPlot({
    plot(x = waterByZone$wbz_SecondsWateredZone1,
    #plot(x = waterByZone["secondsWateredInFront",]
         ylab = 'seconds of water',
         xlab = NA,
         xaxt = "n",
         type = "l",
         col = "brown"
          )
    lines(x = waterByZone$wbz_SecondsWateredZone2,
           col = "darkgoldenrod1"
     )
    axis(
      side = 1,
      at = floor(seq(
        from = getStartDayOfYear(),
        to = getEndDayOfYear(),
        length.out = 13
      )),
      labels = c(month.abb, " ")
    )


  })


}
