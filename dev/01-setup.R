install.packages("pak")

dev_pkgs <- c(
  "checkmate", "devtools", "magick", "testthat", "tidyverse"
)
prj_pkgs <- c("here", "REDCapR")
pak::pkg_install(c(dev_pkgs, prj_pkgs), dependencies = TRUE)

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
usethis::use_dev_version()


dev_pkgs |> purrr::walk(\(x) usethis::use_package(x, type = "Suggests"))
prj_pkgs |> purrr::walk(use_package)
renv::snapshot()

usethis::use_tidy_description()
