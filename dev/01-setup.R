install.packages("pak")

# dev
pak::pkg_install(c(
  # dev
  "devtools", "tidyverse", "testthat", "checkmate",
  # proj
  "REDCapR"
), dependencies = TRUE)

renv::snapshot()
