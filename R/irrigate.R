#' irrigate
#'
#' Turns the irrigation system on and off
#'
#' This is a blocking function.
#'   It will not return until the duration is complete.
#'   duration must be greater than 30 seconds
#'
#' @param zone numerical. 1 = front yard, 2 = back yard
#' @param duration seconds of water for this zone
#'
#' @return nothing
#' @export
#'
#' @examples
#'
irrigate <- function(zone, duration) {
  # zone #1 connected to GPIO17, board pin 11.
  # zone #2 connected to GPIO27, board pin 13.
  zoneToPin <- c(11, 13)

    rpi_set(pin_number = zoneToPin[zone], onOff = 1)
    Sys.sleep(duration)
    rpi_set(pin_number = zoneToPin[zone], onOff = 0)
    return(NULL)
}
