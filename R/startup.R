# startup script. Runs at boot

# install.packages("httr2")
# install.packages("devtools")

library(devtools)

devtools::install_github("mnr/sprinklR")

create_waterByZone.R #create the matrix if necessary

main_loop.R
