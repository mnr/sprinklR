# howMuchToWater()

#' How Much To Water each day
#'
#' compares rainfall from yesterday, today, and tomorrow
#'    minus evapotranspiration
#'    against today's needed amount of water
#'
#' @param waterByZone matrix showing rainfall, needed and watered
#' @param yearDay day of the year. January 1 = 1
#'
#' @return updated WaterByZone
#' @export
#'
#' @examples
howMuchToWater <- function(waterByZone, yearDay) {
  # get the sum rainfall for yesterday, today, and tomorrow

  recentRainfall <-
    sum(waterByZone["rainfall", (yearDay - 1):(yearDay + 1)])
  recentEVOTRP <- sum(waterByZone["evapotranspiration", (yearDay - 1):(yearDay + 1)])

  # calculate needed water for front zone
  neededRain <- waterByZone["neededInFront", yearDay] - recentRainfall + recentEVOTRP
  waterByZone["wateredInFront", yearDay] <- ifelse(neededRain <= 0, 0, neededRain)

  # calculate needed water for rear zone
  neededRain <- waterByZone["neededInRear", yearDay] - recentRainfall + recentEVOTRP
  waterByZone["wateredInRear", yearDay] <- ifelse(neededRain <= 0, 0, neededRain)

  return(waterByZone)
}
