parse_answer <- function(
  x,
  what = c("sensazione", "momento", "andamento", "impatto")
) {
  checkmate::assert_string(x)
  what <- match.arg(what)

  parser <- switch (what,
    sensazione = parse_sensazione,
    momento = parse_momento,
    andamento = parse_andamento,
    impatto = parse_impatto
  )

  parser(x)
}

parse_sensazione <- function(x) {
  checkmate::assert_string(x)
  stringi::stri_enc_toascii(stringr::str_to_lower(x)) == "si"
}

parse_momento <- function(x) {
  checkmate::assert_string(x)
  .levels <- c(
    "Mattina (05-11)", "Pomeriggio (11-17)", "Sera (17-23)",
    "Notte (23-05)"
  )

  lover_level <- stringr::str_to_lower(.levels) |> 
    stringi::stri_enc_toascii() |> 
    stringr::str_remove_all("[^a-zA-Z]") |> 
    stringr::str_squish()

  vec <- c("mattina", "pomeriggio", "Mattina", "Sera (17-23)")
  




}

parse_andamento <- function(x) {
  checkmate::assert_string(x)

}

parse_impatto <- function(x) {
  checkmate::assert_string(x)

}

