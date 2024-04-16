
#' conv_mm_to_duration
#'
#' Converts mm of water to seconds to open valves
#'
#' emitters are spaced every 254 mm and emit 946353 mm^3 per hour
#'
#' @param mmOfWater depth of desired water column
#'
#' @return Seconds to open valve based on above assumptions
#' @export
#'
#' @examples
conv_mm_to_duration <- function(mmOfWater) {

  # convert GPH to mm3/second
  emitterGPH <- .25 # emitters put out .25 gph
  emitterGPsec <- emitterGPH / 60 / 60
  mm3_per_gallon <- 3.785e+6
  emitter_mm3_sec <- emitterGPsec * mm3_per_gallon

  # calculate the volume to be filled with water
  emitterDistance_mm <- 254
  volumeToFill <- mmOfWater * emitterDistance_mm * emitterDistance_mm

  # how long to fill the volume with water?
  secondsOpenValve <- volumeToFill / emitter_mm3_sec

  return(secondsOpenValve)
}
