# package build commands
# https://r-pkgs.org/ 


library(devtools)
# You will call these functions on a regular basis, as you add functions and tests or take on dependencies:

use_r()
use_test()
use_package()
use_article()
use_news_md()
use_package_doc()
use_rcpp()

# You will call these functions multiple times per day or per hour, during
# development:

load_all()
document()
test()
check() # aka R CMD check
check(args = "--no-examples")
Rcpp::compileAttributes()
roxygen2::roxygenize(roclets="rd")

#notes on Rcpp with Rstudio
https://support.posit.co/hc/en-us/articles/200486088-Using-Rcpp-with-the-RStudio-IDE


# others
build_readme()
build_vignettes()

build_site()

# to update RPi
devtools::install_github("mnr/sprinklR")
devtools::install_github("mnr/rpigpior")


# for cran submission
use_release_issue()
devtools::check(remote = TRUE, manual = TRUE)
check_win_devel()
submit_cran()


