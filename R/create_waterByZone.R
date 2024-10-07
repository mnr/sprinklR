# create the watering matrix and save to disk if necessary

#' create_waterByZone
#'
#' Sets up an initial matrix to track weather and watering
#'
#' creates waterByZone.RDS on local file system
#' 1 inch (25.4 mm) of water per week
#' Watering split over two sessions per week
#' Last frost: March 15
#' First frost: November 25
#'
#' @param forceWrite logical, default = TRUE. Overwrite the existing waterByZone?
#'
#' @return void
#' @export
#'
#' @examples
create_waterByZone <- function(forceWrite = TRUE) {
  if (forceWrite) {
    # calculate last and first frost
    last_frost <- as.POSIXlt("2024-03-15")$yday + 1 # March 15
    first_frost <- as.POSIXlt("2024-11-01")$yday + 1 # November 1

    # how much to water in each zone
    mmWaterPerWeek <-  25.4 # one inch per week = 25.4 mm
    desiredIrrigationFront <- c(rep(0, last_frost),
                        rep_len(c(0,0,mmWaterPerWeek/2,0,mmWaterPerWeek/2,0,0), first_frost - last_frost),
                        rep(0, 366 - first_frost))
    desiredIrrigationRear <- c(rep(0, last_frost),
                                rep_len(c(0,mmWaterPerWeek/2,0,0,0,mmWaterPerWeek/2,0), first_frost - last_frost),
                                rep(0, 366 - first_frost))


    # preserve rainfall history if it exists -------
    # does waterByZone already exist?
    if (file.exists("waterByZone.RDS")) {
      # if yes, load it in.
      waterByZone <- readRDS("waterByZone.RDS")
      rainfallVector <- waterByZone["rainfall",] # retrieve rainfall
      mmWateredFront <- waterByZone["wateredInFront",]
      mmWateredRear <- waterByZone["wateredInRear",]
      secondsWateredFront <- waterByZone["secondsWateredInFront",]
      secondsWateredRear <- waterByZone["secondsWateredInRear",] # retrieve seconds watered front and rear
      evapotranspiration <- waterByZone["evapotranspiration",]

    } else {
      # if no, define fresh versions of these rows
      rainfallVector <- c(rep(0, 366))
      secondsWateredFront <- rep(0,366)
      secondsWateredRear <- rep(0,366)
      mmWateredFront <- rep(0,366)
      mmWateredRear <- rep(0,366)
      evapotranspiration <- rep(0,366)
    }

    waterByZone <- matrix(
      data = c(
        rainfallVector,
        desiredIrrigationFront,
        desiredIrrigationRear,
        mmWateredFront,
        mmWateredRear,
        secondsWateredFront,
        secondsWateredRear,
        evapotranspiration
      ),
      byrow = TRUE,
      nrow = 7,
      dimnames = list(
        c(
          "rainfall",
          "neededInFront",
          "neededInRear",
          "wateredInFront",
          "wateredInRear",
          "secondsWateredInFront",
          "secondsWateredInRear",
          "evapotranspiration"
        )
      )
    )

    saveRDS(waterByZone, "waterByZone.RDS")
  }
}
