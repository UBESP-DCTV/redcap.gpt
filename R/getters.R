get_redcap_uri <- function() {
  Sys.getenv("REDCAP_URI")
}

get_redcap_pid <- function() {
  Sys.getenv("REDCAP_PID") |> 
    as.integer()
}

get_redcap_token <- function() {
  Sys.getenv("REDCAP_TOKEN") |> 
    invisible()
}