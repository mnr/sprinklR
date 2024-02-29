# create the watering matrix and save to disk if necessary

#' create_waterByZone
#'
#' Sets up an initial matrix to track weather and watering
#'
#' creates waterByZone.RDS on local file system
#' 1 inch (25.4 mm) of water per week
#' Watering split over two sessions per week
#' Last frost: March 15
#' First frost: November 25
#'
#' @param forceWrite logical, default = TRUE. Overwrite the existing waterByZone?
#'
#' @return void
#' @export
#'
#' @examples
create_waterByZone <- function(forceWrite = TRUE) {
  if (forceWrite) {
    # calculate last and first frost
    last_frost <- as.POSIXlt("2024-03-15")$yday + 1 # March 15
    first_frost <- as.POSIXlt("2024-11-25")$yday + 1 # November 25
    irrigateVector <- c(rep(0, last_frost),
                        rep(25.4, first_frost - last_frost),
                        rep(0, 366 - first_frost))
    rainfallVector <- rep(0, 366)

    waterByZone <- matrix(
      data = c(rainfallVector, irrigateVector, irrigateVector),
      byrow = TRUE,
      nrow = 3,
      dimnames = list(c(
        "rainfall", "neededInFront", "neededInRear"
      ))
    )

    saveRDS(waterByZone, "waterByZone.RDS")
  }
}
