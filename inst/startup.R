# startup script. Runs at boot

# install.packages("httr2")
# install.packages("devtools")

# library(devtools)
library(httr2)
library(sprinklR)
library(rpigpior)

# source("inst/sprinklR_PAT.R")
# devtools::install_github("mnr/sprinklR", auth_token = sprinklR_PAT)
# devtools::install_github("mnr/rpigpior")

yearDay <- as.POSIXlt(Sys.Date())$yday + 1

create_waterByZone() #create a fresh copy of this matrix

waterByZone <- readRDS("waterByZone.RDS") # retrieve zone watering matrix

waterByZone <- update_waterbyzone(waterByZone) # update with current forecasts

# Calculate needed irrigation ---------------------------------------------
waterByZone <- howMuchToWater(waterByZone,yearDay)

saveRDS(waterByZone, "waterByZone.RDS") # save this update

# convert mm^3 of water to seconds valves are open -----

# irrigation tape produces .25 gph
# milliliter/gallon = 3785.41
# .25 gallon per hour = x milliliter per hour = 946.3 ml/hour
# ml per hour = x ml per second = .262 ml/second

mmWaterPerSecond <- .262

# Trigger irrigation ------------------------------------------------------

irrigate(1,waterByZone["wateredInFront",yearDay]/mmWaterPerSecond) # turn on front yard
irrigate(2,waterByZone["wateredInFront",yearDay]/mmWaterPerSecond) # turn on back yard

# Send a heartbeat --------------------------------------------------------

send_heartbeat()

