# convert mm of water to to seconds valves are open -----

# recommendation is one inch of water per week
# emitters are spaced every 10 inches and emit .25 gallons per hour
# 1 inch of water with emitters spaced every 10 inches = 100 cubic inches of water
# 100 cubic inches = 0.43 gallons
# it will take one emitter 1.72 hours to emit 100 inches^3 (.43 gallons/.25 gph)

# recommendation is 2.54 mm of water per week
# emitters are spaced every 254 mm and emit 946 ml per hour
# 2.54 mm of water with emitters spaced every 254 mm = 163.870 ml of water
#       2.54 * 254 * 254 = 163870 mm^3. 1 mm^3 = .001 ml
# it will take one emitter .173 hours to emit 163 ml of water
# it will take one emitter 622 seconds to emit 163 ml of water

# 1 mm of water with emitters spaced every 254 mm = 64.51 ml of water
#       1 * 254 * 254 * .001
# it will take one emitter .07 hours to emit 64.51 ml of water
# it will take one emitter 252 seconds to emit 64.51 ml of water

#' conv_mm_to_duration
#'
#' Converts mm of water to seconds to open valves
#'
#' emitters are spaced every 254 mm and emit 946 ml per hour
#' 1 mm of water with emitters spaced every 254 mm = 64.51 ml of water
#' it will take one emitter 252 seconds to emit 64.51 ml of water
#'
#' @param mmOfWater depth of desired water column
#'
#' @return Seconds to open valve based on above assumptions
#' @export
#'
#' @examples
conv_mm_to_duration <- function(mmOfWater) {
  mlOfWater <- mmOfWater * 254 * 254 *.001
  secondsOpenValve <- mlOfWater / 64.51 * 252

  return(secondsOpenValve)
}
