# Send heartbeat ----------------------------------------------------------
#' Send_heartbeat
#'
#' Let the web page know we are alive and working
#'
#' @param iam_to_send ip address of raspberry pi
#'
#' @return void
#' @export
#'
#' @examples
#'
send_heartbeat <- function() {
  # get ip address
  theIPaddress <- system("hostname -I", intern = TRUE) |>
    strsplit(" ") |>
    unlist() |>
    (\(x) {x[1]})()

  # get uptime
  reboot_datetime <- system("uptime -s", intern = TRUE)

  # convert waterByZone to json
  waterByZone <- readRDS("waterByZone.RDS") # retrieve zone watering matrix

  #heartbeat_request <- request("https://niemannross.com")

  http_request <- request("https://niemannross.com") |>
    req_url_path_append("sprinklR") |>
    req_url_path_append("heartbeat.php") |>
    req_body_json(list(iam = theIPaddress,
                       last_reboot = reboot_datetime,
                       wbz_rainfall = waterByZone["rainfall",],
                       wbz_zone1 = waterByZone["neededInFront",],
                       wbz_zone2 = waterByZone["neededInRear",]),
                  digits = 4)

  http_response <- req_perform(http_request)
}
