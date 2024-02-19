# Send heartbeat ----------------------------------------------------------
#' Title
#'
#' @param iam_to_send ip address of raspberry pi
#'
#' @return void
#' @export
#'
#' @examples
send_heartbeat <- function(iam_to_send) {
  heartbeat_request <- request("https://niemannross.com")

  http_request |>
    req_url_path_append("sprinklR") |>
    req_url_path_append("heartbeat.php") |>
    req_url_query(iam = iam_to_send)

  http_response <- req_perform(http_request)
}
