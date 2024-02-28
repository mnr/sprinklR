# startup script. Runs at boot

# install.packages("httr2")
# install.packages("devtools")

# library(devtools)
library(httr2)
library(sprinklR)
library(rpigpior)

# sprinklR_PAT <- "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"
# devtools::install_github("mnr/sprinklR", auth_token = sprinklR_PAT)
# devtools::install_github("mnr/rpigpior")

create_waterByZone() #create the matrix if necessary

waterByZone <- readRDS("waterByZone.RDS") # retrieve zone watering matrix

# get the day of the year
# January 1 = 1
yearDay <- as.POSIXlt(Sys.Date())$yday + 1

waterByZone <- update_waterbyzone(waterByZone,yearDay) # update with current forecasts

saveRDS(waterByZone, "waterByZone.RDS") # save this update

# Calculate needed irrigation ---------------------------------------------


# Trigger irrigation ------------------------------------------------------

irrigate(TRUE, 1) # turn on front yard
irrigate(TRUE, 2) # turn on back yard
Sys.sleep(5)
irrigate(FALSE, 1) # turn off front yard
Sys.sleep(5)
irrigate(FALSE, 2) # turn off back yard

# Send a heartbeat --------------------------------------------------------

send_heartbeat()

