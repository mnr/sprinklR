# create the watering matrix and save to disk if necessary

create_waterByZone <- function() {
  if (!file.exists("waterByZone.RDS")) {
    waterByZone <- matrix(
      data = NA,
      nrow = 3,
      ncol = 365,
      dimnames = list(c(
        "rainfall", "neededInFront", "neededInRear"
      ),
      c())
    )

    saveRDS(waterByZone, "waterByZone.RDS")
  }
}