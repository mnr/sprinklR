# startup script. Runs at boot

# install.packages("httr2")
# install.packages("devtools")
# install.packages("openmeteo")

library(devtools)
library(openmeteo)
library(httr2)

devtools::install_github("mnr/sprinklR")

create_waterByZone() #create the matrix if necessary

waterByZone <- readRDS("waterByZone.RDS") # retrieve zone watering matrix

# get the day of the year
# January 1 = 0
yearDay <- as.POSIXlt(Sys.Date())$yday

waterByZone <- update_waterbyzone(waterByZone,yearDay) # update with current forecasts

saveRDS(waterByZone, "waterByZone.RDS") # save this update

# Calculate needed irrigation ---------------------------------------------


# Trigger irrigation ------------------------------------------------------

irrigate(TRUE, 1) # turn on front yard
irrigate(TRUE, 2) # turn on back yard
Sys.sleep(100)
irrigate(FALSE, 1) # turn off front yard
Sys.sleep(100)
irrigate(FALSE, 2) # turn off back yard

# Send a heartbeat --------------------------------------------------------

send_heartbeat()

