# edit the watering matrix and save to disk if necessary

#' edit_waterByZone
#'
#' @param waterByZone The object containing the waterByZone matrix
#'
#' @return an updated waterByZone object
#' @export
#'
#' @examples
edit_waterByZone <- function(waterByZone) {
    # calculate last and first frost
    last_frost <- as.POSIXlt("2024-03-15")$yday + 1 # March 15
    first_frost <- as.POSIXlt("2024-10-01")$yday + 1 # October 1

    # how much to water in each zone
    mmWaterPerWeek <-  25.4 # one inch per week = 25.4 mm
    waterByZone["neededInFront",] <- c(rep(0, last_frost),
                        rep_len(c(0,0,mmWaterPerWeek/2,0,mmWaterPerWeek/2,0,0), first_frost - last_frost),
                        rep(0, 366 - first_frost))
    waterByZone["neededInRear",] <- c(rep(0, last_frost),
                                rep_len(c(0,mmWaterPerWeek/2,0,0,0,mmWaterPerWeek/2,0), first_frost - last_frost),
                                rep(0, 366 - first_frost))

    return(waterByZone)
  }

