
library(shiny)
library(jsonlite)

# Define server logic required to draw a histogram
function(input, output, session) {
  waterByZone = fromJSON("https://niemannross.com/sprinklR/heartbeat_data.json")

  output$lastReboot <- renderText({paste("Last Reboot: ", waterByZone$last_reboot)})
  output$lastHeartbeat <- renderText({paste("Last Heartbeat: ",waterByZone$modified)})
  output$location <- renderText({paste("I am: ",waterByZone$iam)})
  dayOfYear <- as.POSIXlt(waterByZone$modified)$yday + 1
  # as.POSIXlt(Sys.Date())$yday + 1
  output$yearDay <- renderText(paste("Day of Year: ", dayOfYear))
  output$logfile <- renderText({paste("Logfile: ",waterByZone$logfile)})

  getStartDayOfYear <- function(dispRange) {
    startDayOfYear <- dayOfYear - dispRange
    return(ifelse(startDayOfYear < 0, 0, startDayOfYear))
  }

  getEndDayOfYear <- function(dispRange) {
    endDayOfYear <- dayOfYear + dispRange
    return(ifelse(endDayOfYear > 366, 366, endDayOfYear))
  }

  trimDisplayRange <- function(dispRange) {
    # trim waterByZone according to input$displayRange
    startDayOfYear <- getStartDayOfYear(dispRange)
    endDayOfYear <- getEndDayOfYear(dispRange)

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
    startDayOfYear <- getStartDayOfYear(input$displayRange)
    endDayOfYear <- getEndDayOfYear(input$displayRange)
    trimmedWBZ <- trimDisplayRange(input$displayRange)

    # draw the barplot
    barplot(
      height = trimmedWBZ["wbz_NeededZone1", ],
      ylab = 'mm of water',
      main = 'Sprinkler System Status',
      xlim = c(1, (2 * input$displayRange)),
      ylim = c(-10, 20),
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
    #text()

    lines(-(trimmedWBZ["wbz_evapotranspiration", ]), col = "blue")
    #text()

    lines(trimmedWBZ["wbz_WateredZone1", ], lty = "twodash", lwd = 2, col = "brown")
    #text()

    lines(trimmedWBZ["wbz_WateredZone2", ], lty = "twodash", lwd = 2, col = "darkgoldenrod1")
    #text()

    legend(x = "topright",
           legend = c("Rainfall", "Evapotranspiration", "Watered Zone 1", "Watered Zone 2"),
           col = c("red", "blue", "brown", "darkgoldenrod1"),
           lty = c("solid","solid","twodash","twodash"),
           lwd = c(1,1,2,2))

   # todayLine <- (input$displayRange) + startDayOfYear
    todayLine <- dayOfYear - startDayOfYear + .5
    abline(v = todayLine)
    #text(x = todayLine + .1 + (strwidth("Today")/2),
    text(x = todayLine - .1,
         y = 18,
         labels = "Today",
         srt = 90)


  })

  output$secondsOfWater <- renderPlot({
    startDayOfYear <- getStartDayOfYear(input$displayRange)
    endDayOfYear <- getEndDayOfYear(input$displayRange)
    trimmedWBZ <- trimDisplayRange(input$displayRange)

    barplot(
      height = trimmedWBZ["wbz_SecondsWateredZone1", ],
      ylab = 'seconds of water',
      #main = 'Sprinkler System Status',
      xlim = c(1, (2 * input$displayRange)),
      #ylim = c(0, 20),
      space = 0,
      density = 20,
      angle = 135,
      col = 'cyan',
      border = NA
    )
    barplot(
      height = trimmedWBZ["wbz_SecondsWateredZone2", ],
      col = 'magenta',
      space = 0,
      angle = 45,
      density = 20,
      border = NA,
      add = TRUE
    )


  })


}
