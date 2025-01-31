source("renv/activate.R")

options(tidyverse.quiet = TRUE)

if (
  interactive() &&
  requireNamespace("usethis", quietly = TRUE) &&
  (
    as.logical(Sys.getenv("ATTACH_STARTUP_PKGS", FALSE)) ||
    usethis::ui_yeah(
      "Would you like to attachdevelopment supporting packages"
    )
  )
) {
  .attach <- function(pkg) {
    if (requireNamespace(pkg, quietly = TRUE)) {
      pkg |>
        library(character.only = TRUE) |>
        suppressWarnings() |>
        suppressPackageStartupMessages()
      usethis::ui_done("Package {ui_value(pkg)} attached.")
    }
  }
  usethis::ui_todo("Attaching development supporting packages...")
  .attach("usethis")
  .attach("devtools")
  .attach("testthat")
  .attach("checkmate")
  .attach("targets")
  .attach("tarchetypes")

  .run <- function(...) {
    source(here::here("dev/run.R")) # check and make pipeline.
    .run(...)
  }
  ui_info("Exexute {ui_code('.run()')} to make the pipeline.")

  .background_run <- function(...) {
    stopifnot(requireNamespace("rstudioapi"))
    rstudioapi::jobRunScript(
      here::here("dev/background_run.R"),
      workingDir = here::here()
    )
  }
  ui_info(paste0(
    "Exexute {ui_code('.background_run()')} to make the pipeline ",
    "as a background job in RStudio."
  ))

}
