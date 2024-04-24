# Send heartbeat ----------------------------------------------------------
#' Send_heartbeat
#'
#' Let the web page know we are alive and working
#'
#' @param waterByZone A copy of the waterByZone matrix
#'
#' @return void
#' @export
#'
#' @examples
#'
send_heartbeat <- function(waterByZone) {
  # get ip address
  theIPaddress <- system("hostname -I", intern = TRUE) |>
    strsplit(" ") |>
    unlist() |>
    (\(x) {x[1]})()

  # get uptime
  reboot_datetime <- system("uptime -s", intern = TRUE)

  # retrieve the log file
  sprinklR_logfile <- tail(read.delim("/home/mnr/sprinklR/sprinklR_log.txt", header=FALSE))

  http_request <- request("https://niemannross.com") |>
    req_url_path_append("sprinklR") |>
    req_url_path_append("heartbeat.php") |>
    req_body_json(list(iam = theIPaddress,
                       last_reboot = reboot_datetime,
                       wbz_rainfall = waterByZone["rainfall",],
                       wbz_NeededZone1 = waterByZone["neededInFront",],
                       wbz_NeededZone2 = waterByZone["neededInRear",],
                       wbz_WateredZone1 = waterByZone["wateredInFront",],
                       wbz_WateredZone2 = waterByZone["wateredInRear",],
                       wbz_SecondsWateredZone1 = waterByZone["secondsWateredInFront",],
                       wbz_SecondsWateredZone2 = waterByZone["secondsWateredInRear",],
                       wbz_evapotranspiration = waterByZone["evapotranspiration",],
                       logfile = sprinklR_logfile
                       ),
                  digits = 4)

  http_response <- req_perform(http_request)
}
