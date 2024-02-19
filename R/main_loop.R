library(httr2)
library(openmeteo)

# retrieve zone watering matrix
readRDS("waterByZone.RDS")

# get the day of the year
# January 1 = 0
yearDay <- as.POSIXlt(Sys.Date())$yday

# get rain forecast -------------------------------------------------------

pdx_forecast <- climate_forecast("Portland",
                                 start = Sys.Date(),
                                 end = Sys.Date() + 7,
                                 daily = "rain_sum")

# Calculate needed irrigation ---------------------------------------------


# Trigger irrigation ------------------------------------------------------

irrigate(TRUE, 1) # turn on front yard
irrigate(TRUE, 2) # turn on back yard
Sys.sleep(100)
irrigate(FALSE, 1) # turn off front yard
Sys.sleep(100)
irrigate(FALSE, 2) # turn off back yard

# Send a heartbeat --------------------------------------------------------

theIPaddress <- system("hostname -I", intern = TRUE) |>
  strsplit(" ") |>
  unlist() |>
  (\(x) {x[1]})()

send_heartbeat(iam_to_send = theIPaddress)
