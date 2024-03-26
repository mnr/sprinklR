# Handle a request for manual irrigation

# cron runs every minute
# This program watches for a two way switch
# position one turns on zone 1
# position two turns on zone 2
# position central returns to automatic

library(sprinklR)
library(rpigpior)

zoneToPin <- c(15, 19)

while(rpi_get(zoneToPin[1])) {
    irrigate(1,30)
}

while(rpi_get(zoneToPin[2])) {
  irrigate(2,30)
}

