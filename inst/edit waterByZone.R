# tools to edit waterByZone.RDS
# obtain a fresh copy by...
# 1) Open a terminal to the Raspberry Pi
# 2) Use scp mnr@10.0.0.252:~/sprinklR/waterByZone.RDS Downloads

# retrieve zone watering matrix
waterByZone <- readRDS("~/Downloads/waterByZone.RDS")

# edit the needed water by zone
# how much to water in each zone
mmWaterPerWeek <-  25.4 # one inch per week = 25.4 mm
waterByZone["neededInFront",] <- c(rep(0, last_frost),
                                   rep_len(c(0,0,mmWaterPerWeek/2,0,mmWaterPerWeek/2,0,0), first_frost - last_frost),
                                   rep(0, 366 - first_frost))
waterByZone["neededInRear",] <- c(rep(0, last_frost),
                                   rep_len(c(0,0,mmWaterPerWeek/2,0,mmWaterPerWeek/2,0,0), first_frost - last_frost),
                                   rep(0, 366 - first_frost))

