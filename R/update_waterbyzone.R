# update waterbyzone with current forecast

#' update waterByZone with current forecast
#'
#' @param waterByZone a matrix with zone requests and rain forecast
#' @param yearDay the day of the year. January 1 = 0
#'
#' @return updated version of the waterByZone matrix
#' @export
#'
#' @examples
update_waterbyzone <- function(waterByZone, yearDay) {

  # get rain forecast -------------------------------------------------------

  pdx_forecast <- climate_forecast("Portland",
                                   start = Sys.Date(),
                                   end = Sys.Date() + 7,
                                   daily = "rain_sum")
  # update waterByZone matrix --------

  for (index in 1:nrow(pdx_forecast["daily_rain_sum"])) {
    waterByZone["rainfall", yearDay + index - 1] <-
      as.numeric(pdx_forecast[index, "daily_rain_sum"])
  }

  return(waterByZone)
}
