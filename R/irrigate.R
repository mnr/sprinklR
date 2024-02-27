#' irrigate
#'
#' Turns the irrigation system on and off
#'
#' @param state Logical. TRUE = on, FALSE = off
#' @param zone numerical. 1 = front yard, 2 = back yard
#'
#' @return nothing
#' @export
#'
#' @examples
#'
irrigate <- function(state, zone) {
  # zone #1 connected to GPIO17, board pin 11.
  # zone #2 connected to GPIO27, board pin 13.
  zoneToPin <- c(11,13)

  rpi_set(pin_number = zoneToPin[zone], onOff = state) # turn both relays on
}
