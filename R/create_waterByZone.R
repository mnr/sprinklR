# create the watering matrix and save to disk if necessary

#' create_waterByZone
#'
#' Set up an initial matrix to track weather and watering
#'
#' creates waterByZone.RDS on local file system
#'
#' @return void
#' @export
#'
#' @examples
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
