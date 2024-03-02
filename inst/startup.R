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

# create_waterByZone() #create a fresh copy of this matrix

waterByZone <- readRDS("waterByZone.RDS") # retrieve zone watering matrix

waterByZone <- update_waterbyzone(waterByZone, yearDay) # update with current forecasts

# Calculate needed irrigation ---------------------------------------------
waterByZone <- howMuchToWater(waterByZone,yearDay)

saveRDS(waterByZone, "waterByZone.RDS") # save this update

# Trigger irrigation ------------------------------------------------------

irrigate(1, conv_mm_to_duration(waterByZone["wateredInFront",yearDay])) # turn on front yard
irrigate(2, conv_mm_to_duration(waterByZone["wateredInFront",yearDay])) # turn on back yard
# irrigate(1,waterByZone["wateredInFront",yearDay]/mmWaterPerSecond) # turn on front yard
# irrigate(2,waterByZone["wateredInFront",yearDay]/mmWaterPerSecond) # turn on back yard

# Send a heartbeat --------------------------------------------------------

send_heartbeat()

