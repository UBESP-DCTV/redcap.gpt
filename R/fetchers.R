#' Fetch REDCap form
#'
#' @param form (chr, length 1) The REDCap form to fetch.
#' @param .uri (chr, default: get_redcap_uri()) The REDCap URI.
#' @param .token (chr, default: get_redcap_token()) The REDCap token.
#'
#' @return (tbl_df) The REDCap form.
#' @export
#'
#' @examples
#' \donttest{
#'   fetch_form("followup_postoperatorio_14_30_60_giorno_po") |>
#'     str(0)
#' }
fetch_form <- function(
  form,
  .uri = get_redcap_uri(),
  .token = get_redcap_token()
) {
  checkmate::assert_string(form)
  fetch_redcap(.uri = .uri, .token = .token, forms = form) |>
    REDCapTidieR::extract_tibble(form)
}

#' Fetch REDCap DB
#'
#' @param .uri (chr, default: get_redcap_uri()) The REDCap URI.
#' @param .token (chr, default: get_redcap_token()) The REDCap token.
#'
#' @return (tbl_df) The REDCap DB.
#' @export
#'
#' @examples
#' \donttest{
#'   fetch_redcap() |> 
#'     str(1)
#' }
fetch_redcap <- function(
  .uri = get_redcap_uri(),
  .token = get_redcap_token(),
  forms = NULL
) {
  REDCapTidieR::read_redcap(
    redcap_uri = .uri,
    token = .token,
    forms = forms
  )
}
