# edit the watering matrix and save to disk if necessary

#' edit_waterByZone
#'
#' @param waterByZone The object containing the waterByZone matrix
#'
#' @return an updated waterByZone object
#' @export
#'
#' @examples
# edit_waterByZone <- function(waterByZone) {
#     # calculate last and first frost
#     last_frost <- as.POSIXlt("2024-05-15")$yday + 1 # May 15
#     first_frost <- as.POSIXlt("2024-9-15")$yday + 1 # September 15
#
#     # how much to water in each zone
#     mmWaterPerWeek <-  25.4 # one inch per week = 25.4 mm
#     waterByZone["neededInFront",] <- c(rep(0, last_frost),
#                         rep_len(c(0,0,mmWaterPerWeek/2,0,mmWaterPerWeek/2,0,0), first_frost - last_frost),
#                         rep(0, 366 - first_frost))
#     waterByZone["neededInRear",] <- c(rep(0, last_frost),
#                                 rep_len(c(0,mmWaterPerWeek/2,0,0,0,mmWaterPerWeek/2,0), first_frost - last_frost),
#                                 rep(0, 366 - first_frost))
#
#     return(waterByZone)
#   }


edit_waterByZone <- function() {
  whereIsWBZ <- "/home/mnr/sprinklR/waterByZone.RDS"
  # obtain waterByZone
  waterByZone <- readRDS(whereIsWBZ)

  # prompt for values
  # last frost
  previouslast_frost <- as.Date(paste("1976",
                                      min(
                                        head(
                                          which(waterByZone["neededInFront", ] > 0), n = 1),
                                        head(
                                          which(waterByZone["neededInRear", ] > 0), n = 1)
                                        )
                                      ),
                                format = "%Y %j")
  print(paste("Currently, irrigation starts on",
        format(as.POSIXlt(previouslast_frost), format = "%B %e")))
  last_frost_date <- readline("Enter the date irrigation should start (yyyy-mm-dd): ")
  last_frost <- as.POSIXlt(last_frost_date)$yday + 1

  # first frost
  previousfirst_frost <- as.Date(paste("1976",
                                       max(
                                         tail(
                                           which(waterByZone["neededInFront", ] > 0), n = 1),
                                         tail(
                                           which(waterByZone["neededInRear", ] > 0), n = 1)
                                         )
                                       ),
                                 format = "%Y %j")
  print(paste("Currently, irrigation ends on",
        format(as.POSIXlt(previousfirst_frost), format = "%B %e")))

  first_frost_date <- readline("Enter the date irrigation should end (yyyy-mm-dd): ")
  first_frost <- as.POSIXlt(first_frost_date)$yday + 1

  # water per week in front
  print(paste("Currently, the front zone receives",
        waterByZone["neededInFront",
              which(waterByZone["neededInFront", ] > 0)[1]
              ] * 2,
        "mm of water per week"))

  mmWaterPerWeekFront <- as.numeric(readline("How many mm of water per week in front zone: "))

  # water per week in rear
  print(paste("Currently, the rear zone receives",
        waterByZone["neededInRear",
                    which(waterByZone["neededInRear", ] > 0)[1]
        ] * 2,
        "mm of water per week"))

  mmWaterPerWeekRear <- as.numeric(readline("How many mm of water per week in rear zone: "))

  # confirm this is correct
  print(paste("Irrigation will start on",format(as.POSIXlt(last_frost_date), format = "%B %e")))
  print(paste("Irrigation will end on",format(as.POSIXlt(first_frost_date), format = "%B %e")))
  print(paste("The front zone will receive",mmWaterPerWeekFront,"mm",
        "(",round(mmWaterPerWeekFront/25.4,digits = 2),"inches) of water per week") )
  print(paste("The rear zone will receive",mmWaterPerWeekRear,"mm",
        "(",round(mmWaterPerWeekRear/25.4,digits = 2),"inches) of water per week"))


  if (askYesNo("Are these values correct? ")) {
    waterByZone["neededInFront", ] <- c(
      rep(0, last_frost),
      rep_len(
        c(mmWaterPerWeek / 2, 0,0,0, mmWaterPerWeek / 2, 0, 0),
        first_frost - last_frost
      ),
      rep(0, 366 - first_frost)
    )
    waterByZone["neededInRear", ] <- c(
      rep(0, last_frost),
      rep_len(
        c(0, mmWaterPerWeek / 2, 0, 0, 0, mmWaterPerWeek / 2, 0),
        first_frost - last_frost
      ),
      rep(0, 366 - first_frost)
    )
    # save the updated waterbyzone
    ##### saveRDS(waterByZone, whereIsWBZ)
    print("saving the results is currently disabled for testing")
  } else {
    print("To correct these values, please restart edit_waterByZone()")
  }

}
