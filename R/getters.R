#' Get the REDCap URI from the environment.
#'
#' @return (chr) The REDCap URI.
#' @export
#'
#' @examples
#' get_redcap_uri()
get_redcap_uri <- function() {
  Sys.getenv("REDCAP_URI")
}

#' Get the REDCap project ID from the environment.
#'
#' @return (int) The REDCap project ID.
#' @export
#'
#' @examples
#' get_redcap_pid()
get_redcap_pid <- function() {
  Sys.getenv("REDCAP_PID") |>
    as.integer()
}

#' Get the REDCap token from the environment.
#'
#' @return (chr) The REDCap token, invisibly.
#' @export
#'
#' @examples
#' get_redcap_token()
get_redcap_token <- function() {
  Sys.getenv("REDCAP_TOKEN") |>
    invisible()
}
