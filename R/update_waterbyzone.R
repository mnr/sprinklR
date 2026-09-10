# update waterbyzone with current forecast

#' update waterByZone with current forecast
#'
#' @param waterByZone a matrix with zone requests and rain forecast
#' @param yearDay day of the year
#'
#' @return updated version of the waterByZone matrix
#' @export
#'
#' @examples
#'
update_waterbyzone <- function(waterByZone, yearDay) {
  # get rain forecast -------------------------------------------------------
  # https://open-meteo.com/
  # fixing curl failure: https://forum.posit.co/t/httr2-request-fails-ok-in-browser/197965/2

  # trimmed meteo request
  # https://api.open-meteo.com/v1/forecast?latitude=45.5234&longitude=-122.676222&daily=precipitation_sum,et0_fao_evapotranspiration&timezone=America%2FLos_Angeles&forecast_days=3
  meteo_request <-
    request("https://api.open-meteo.com/v1/forecast") |>
    req_user_agent("Mozilla/5.0") |>
    req_headers("Accept-Encoding" = "identity") |>
    req_headers("Connection" = "Keep-Alive") |>
    req_url_query("latitude" = "45.5234") |>
    req_url_query("longitude" = "-122.6762") |>
    req_url_query("daily" = "precipitation_sum,et0_fao_evapotranspiration") |>
    req_url_query("timezone" = "America/Los_Angeles") |>
    req_url_query("forecast_days" = "3") |>
    req_retry(retry_on_failure = TRUE, max_tries = 4)

    try(
      { meteo_response <- req_perform(meteo_request) |> resp_body_json()

      # next, store forecast
      for (index in 1:length(meteo_response$daily$time)) {
        yearDayFloat <- as.POSIXlt(meteo_response$daily$time[[index]])$yday
        waterByZone["rainfall", yearDayFloat] <-
          meteo_response$daily$precipitation_sum[[index]]
        waterByZone["evapotranspiration", yearDayFloat] <-
          meteo_response$daily$et0_fao_evapotranspiration[[index]]
      }
      }
    )


  return(waterByZone)
}


