
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
  # output$logfile <- renderText({paste(waterByZone$logfile)})
  logPrint <- paste(waterByZone$logfile$V1,'<br/>')
  output$logfile <- renderUI({
    HTML(logPrint)
  })

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
      height = matrix(c(
                        trimmedWBZ["wbz_evapotranspiration", ],
                        trimmedWBZ["wbz_NeededZone1", ],
                        trimmedWBZ["wbz_NeededZone2", ]
                        ),
                 nrow = 3,
                 byrow = TRUE,
      ),
      ylab = 'Needed mm of water',
      main = 'Sprinkler System Status',
      xlim = c(1, (2*input$displayRange)),
      ylim = c(-5,30),
      space = 0,
      density = 20,
      angle = c(135,45),
      col = c('white','cyan','magenta'),
      border = NA,
      width = 1
    )

    lines(trimmedWBZ["wbz_rainfall", ], col = "red")

    lines(trimmedWBZ["wbz_evapotranspiration", ], col = "blue")

    lines(trimmedWBZ["wbz_WateredZone1", ], type = "p",  pch = 15, lwd = 2, col = "cyan")

    lines(trimmedWBZ["wbz_WateredZone2", ], type = "p",  pch = 17, lwd = 2, col = "magenta")

    # legend(x = "bottom",
    #        legend = c("Front Needs","Rear Needs","Rainfall", "Evapotranspiration", "Watered Zone 1", "Watered Zone 2"),
    #        col = c("cyan","magenta","red", "blue", "brown", "darkgoldenrod1"),
    #        lty = c("solid","solid","solid","solid","twodash","twodash"),
    #        #pch = c("solid","solid","solid","solid","twodash","twodash"),
    #        lwd = c(3,3,1,1,2,2))

   # todayLine <- (input$displayRange) + startDayOfYear
    todayLine <- dayOfYear - startDayOfYear + .5
    abline(v = todayLine)
    #text(x = todayLine + .1 + (strwidth("Today")/2),
    text(x = todayLine - .1,
         y = 18,
         labels = "Today",
         srt = 90)


  })

  legendimg <- download.file("https://niemannross.com/wp-content/uploads/2018/08/cropped-mnr-in-japan-smaller.jpg",
                             destfile = "tmpLegend")

  output$legendExplain <- renderImage({legendimg <- download.file("https://raw.githubusercontent.com/wiki/mnr/sprinklR/photos/sprinklrLegend.png",
                                                                  destfile = "tmpLegend")
                                        list(src = "tmpLegend", alt = "an image")},
                                      deleteFile = TRUE)

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
  output$rawData <- renderTable({
    trimDisplayRange(input$displayRange)},
    rownames = TRUE
  )



}
