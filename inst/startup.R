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

# Trigger irrigation ------------------------------------------------------

# water in front
waterFrontSeconds <- conv_mm_to_duration(waterByZone["wateredInFront",yearDay])
irrigate(1, waterFrontSeconds) # turn on front yard
waterByZone["secondsWateredInFront", yearDay] <- waterFrontSeconds

# water in rear
waterRearSeconds <- conv_mm_to_duration(waterByZone["wateredInRear",yearDay])
irrigate(2, waterRearSeconds) # turn on back yard
waterByZone["secondsWateredInRear", yearDay] <- waterRearSeconds

# save all of these calculations
saveRDS(waterByZone, "waterByZone.RDS")

# Send a heartbeat --------------------------------------------------------

send_heartbeat()

