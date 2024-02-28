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

  heartbeat_request <- request("https://niemannross.com")

  http_request <- heartbeat_request |>
    req_url_path_append("sprinklR") |>
    req_url_path_append("heartbeat.php") |>
    req_url_query(iam = theIPaddress) |>
    req_url_query(last_reboot = reboot_datetime)

  http_response <- req_perform(http_request)
}
