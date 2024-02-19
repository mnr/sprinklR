# create the watering matrix and save to disk if necessary

if (!file.exists("waterByZone.RDS")) {
  waterByZone <- matrix(nrow = 3,
                        ncol = 365,
                        dimnames = list(c(
                          "rainfall", "neededInFront", "neededInRear"
                        ),
                        c()))

  saveRDS(waterByZone, "waterByZone.RDS")
}
