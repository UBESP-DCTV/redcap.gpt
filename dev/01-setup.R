install.packages("pak")

meta_pkg <- c("tidyverse")
dev_pkgs <- c(
  "devtools", "here", "janitor", "lubridate", "magick", "REDCapR",
  "rio", "testthat", "tibble", "withr"
)
prj_pkgs <- c(
  "checkmate", "dplyr", "forcats", "jsonlite", "purrr", "REDCapTidieR",
  "rlang", "stringi", "stringr", "tidyr", "usethis"
)
dev_gh_pkgs <- c("CorradoLanera/gpteasyr")
proj_gh_pkgs <- NULL

pak::pkg_install(
  c(meta_pkg, dev_pkgs, prj_pkgs, dev_gh_pkgs, proj_gh_pkgs),
  dependencies = TRUE,
  upgrade = TRUE
)

use_description()
use_mit_license()
usethis::use_package_doc()
usethis::use_readme_rmd()
usethis::use_code_of_conduct("corrado.lanera@ubep.unipd.it")
usethis::use_lifecycle_badge("experimental")
usethis::use_logo("man/img/LAIMS.png")
usethis::use_spell_check()
usethis::use_testthat()
usethis::git_vaccinate()
usethis::use_mit_license()
usethis::use_news_md()
usethis::use_github(
  organisation = "UBESP-DCTV", private = TRUE, protocol = "ssh"
)
usethis::use_pkgdown_github_pages()
usethis::use_tidy_eval()

dev_pkgs |> purrr::walk(\(x) usethis::use_package(x, type = "Suggests"))
prj_pkgs |> purrr::walk(use_package)

dev_gh_pkgs |> 
  stringr::str_remove_all("^[^/]+/") |> 
  purrr::walk(\(x) use_dev_package(x, type = "Suggests"))
proj_gh_pkgs |> 
  stringr::str_remove_all("^[^/]+/") |> 
  purrr::walk(use_dev_package)
renv::snapshot()

usethis::use_tidy_description()
