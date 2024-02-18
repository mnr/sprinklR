# install.packages("httr2")

library(httr2)

theIPaddress <- system("hostname -I", intern = TRUE) |>  strsplit(" ") |>  unlist() |>  (\(x) {x[1]})()

http_request <- request("https://niemannross.com")

http_request |>
  req_url_path_append("sprinklR") |>
  req_url_path_append("heartbeat.php") |>
  req_url_query(iam = theIPaddress)

http_response <- req_perform(http_request)