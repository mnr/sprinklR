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

  meteo_request <- request("https://api.open-meteo.com/v1/forecast") |>
                   req_url_query(latitude = "45.5234") |>
                   req_url_query(longitude = "-122.6762") |>
                   req_url_query(daily = "rain_sum,precipitation_hours,precipitation_probability_max") |>
                   req_url_query(past_days ="5")
  meteo_response <- req_perform(meteo_request)
  resp_body_json(meteo_response)

  # update waterByZone matrix --------

  for (index in 1:nrow(pdx_forecast["daily_rain_sum"])) {
    waterByZone["rainfall", yearDay + index - 1] <-
      as.numeric(pdx_forecast[index, "daily_rain_sum"])
  }

  return(waterByZone)
}
