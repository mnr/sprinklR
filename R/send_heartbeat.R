# Send heartbeat ----------------------------------------------------------
#' Title
#'
#' @param iam_to_send ip address of raspberry pi
#'
#' @return void
#' @export
#'
#' @examples
send_heartbeat <- function() {
  # get ip address
  theIPaddress <- system("hostname -I", intern = TRUE) |>
    strsplit(" ") |>
    unlist() |>
    (\(x) {x[1]})()

  # get uptime
  last_reboot <- system("uptime -s")

  heartbeat_request <- request("https://niemannross.com")

  http_request |>
    req_url_path_append("sprinklR") |>
    req_url_path_append("heartbeat.php") |>
    req_url_query(iam = theIPaddress) |>
    req_url_query(uptime = last_reboot)

  http_response <- req_perform(http_request)
}
