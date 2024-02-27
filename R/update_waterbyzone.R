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
#'
update_waterbyzone <- function(waterByZone, yearDay) {

  # get rain forecast -------------------------------------------------------
# https://open-meteo.com/
  meteo_response <- request("https://api.open-meteo.com/v1/forecast") |>
    req_url_query(latitude = "45.5234") |>
    req_url_query(longitude = "-122.6762") |>
    req_url_query(current="precipitation") |>
    req_url_query(daily = "precipitation_sum,precipitation_probability_max") |>
    req_perform() |>
    resp_body_json()
  meteo_response$current$precipitation
  meteo_response$daily$precipitation_sum[[1]]

  # update waterByZone matrix --------

  for (index in 1:nrow(pdx_forecast["daily_rain_sum"])) {
    waterByZone["rainfall", yearDay + index - 1] <-
      as.numeric(pdx_forecast[index, "daily_rain_sum"])
  }

  return(waterByZone)
}

# return values from meteo
# > meteo_response
# $latitude
# [1] 45.52874
#
# $longitude
# [1] -122.6962
#
# $generationtime_ms
# [1] 0.05698204
#
# $utc_offset_seconds
# [1] 0
#
# $timezone
# [1] "GMT"
#
# $timezone_abbreviation
# [1] "GMT"
#
# $elevation
# [1] 13
#
# $current_units
# $current_units$time
# [1] "iso8601"
#
# $current_units$interval
# [1] "seconds"
#
# $current_units$precipitation
# [1] "mm"
#
#
# $current
# $current$time
# [1] "2024-02-23T05:45"
#
# $current$interval
# [1] 900
#
# $current$precipitation
# [1] 0
#
#
# $daily_units
# $daily_units$time
# [1] "iso8601"
#
# $daily_units$precipitation_sum
# [1] "mm"
#
# $daily_units$precipitation_probability_max
# [1] "%"
#
#
# $daily
# $daily$time
# $daily$time[[1]]
# [1] "2024-02-23"
#
# $daily$time[[2]]
# [1] "2024-02-24"
#
# $daily$time[[3]]
# [1] "2024-02-25"
#
# $daily$time[[4]]
# [1] "2024-02-26"
#
# $daily$time[[5]]
# [1] "2024-02-27"
#
# $daily$time[[6]]
# [1] "2024-02-28"
#
# $daily$time[[7]]
# [1] "2024-02-29"
#
#
# $daily$precipitation_sum
# $daily$precipitation_sum[[1]]
# [1] 0
#
# $daily$precipitation_sum[[2]]
# [1] 0
#
# $daily$precipitation_sum[[3]]
# [1] 0.3
#
# $daily$precipitation_sum[[4]]
# [1] 16.4
#
# $daily$precipitation_sum[[5]]
# [1] 2
#
# $daily$precipitation_sum[[6]]
# [1] 16.9
#
# $daily$precipitation_sum[[7]]
# [1] 15.9
#
#
# $daily$precipitation_probability_max
# $daily$precipitation_probability_max[[1]]
# [1] 0
#
# $daily$precipitation_probability_max[[2]]
# [1] 0
#
# $daily$precipitation_probability_max[[3]]
# [1] 55
#
# $daily$precipitation_probability_max[[4]]
# [1] 100
#
# $daily$precipitation_probability_max[[5]]
# [1] 100
#
# $daily$precipitation_probability_max[[6]]
# [1] 97
#
# $daily$precipitation_probability_max[[7]]
# [1] 94
#
