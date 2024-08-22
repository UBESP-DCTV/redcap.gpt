#' Query GPT on REDCap instrument
#'
#' @param db (tbl_df) The REDCap DB for a single form.
#' @param instrument (chr) The REDCap instrument of the form to query.
#' @param model (chr, default: "gpt-4o-mini") The GPT model to use.
#' @param seed (int, default: 1234) The seed for the GPT model.
#' @param query_on_all_records (lgl, default: FALSE) If TRUE, the 
#'   content of the "text_processed_record" variable (which mark if a 
#'   record has already been processed) will be ignored. If FALSE 
#'   (default) only records not marked as already processed will be 
#'   considered.
#'
#' @return (tbl_df) The REDCap DB with GPT responses parsed.
#' @export
query_gpt_on_redcap_instrument <- function(
  db,
  instrument = c("note_fup", "comments_fup", "details_fup"),
  model = "gpt-4o-mini",
  seed = 1234,
  query_on_all_records = FALSE
) {
  instrument <- match.arg(instrument)
  checkmate::assert_subset(instrument, names(db))
  stopifnot(
    sum(stringr::str_detect(
      names(db), stringr::str_glue("{instrument}_text")
    )) == 25
  )

  db_to_query <- db |>
    dplyr::select(
      dplyr::all_of(
        c("record_id", "redcap_form_name", "redcap_form_instance")
      ),
      dplyr::starts_with(instrument)
    ) |>
    dplyr::filter(
      !is.na(.data[[instrument]]),
      query_on_all_records | !.data[[
        stringr::str_c(instrument, "_text_processed_record___1")
      ]]
    ) |> 
      dplyr::rename(
        redcap_repeat_instrument = dplyr::all_of("redcap_form_name"),
        redcap_repeat_instance = dplyr::all_of("redcap_form_instance")
      )

  if (nrow(db_to_query) == 0) {
    return(
      db_to_query |>
        dplyr::mutate(
          dplyr::across(dplyr::where(is.factor), \(x) as.integer(x)),
          dplyr::across(dplyr::where(is.logical), \(x) as.integer(x))
        )
    )
  }
  
  sys <- gpteasyr::compose_sys_prompt(
    role = compose_sys_role(),
    context = compose_sys_context()
  )
  usr <- gpteasyr::compose_usr_prompt(
    task = compose_usr_task(),
    instructions = compose_usr_instructions(),
    output = compose_usr_output(),
    style = compose_usr_style(),
    examples = compose_usr_example(),
    closing = compose_usr_closing(),
    delimiter = "#####"
  )

  db_queried <- db_to_query |>
    gpteasyr::query_gpt_on_column(
      instrument,
       sys, usr,
       closing = compose_final_closing(),
       model = model,
       seed = seed
    ) |>
    dplyr::mutate(
      gpt_res = purrr::map(.data[["gpt_res"]], gpt_to_tibble)
    ) |>
    tidyr::unnest(cols = dplyr::all_of("gpt_res"))

  calmo_response <- stringr::str_glue("{instrument}_text_feeling___1")
  calmo_motivation <- stringr::str_glue("{instrument}_text_feeling_1_motivation")
  irritato_response <- stringr::str_glue("{instrument}_text_feeling___2")
  irritato_motivation <- stringr::str_glue("{instrument}_text_feeling_2_motivation")
  ansioso_response <- stringr::str_glue("{instrument}_text_feeling___3")
  ansioso_motivation <- stringr::str_glue("{instrument}_text_feeling_3_motivation")
  ottimista_response <- stringr::str_glue("{instrument}_text_feeling___4")
  ottimista_motivation <- stringr::str_glue("{instrument}_text_feeling_4_motivation")
  demotivato_response <- stringr::str_glue("{instrument}_text_feeling___5")
  demotivato_motivation <- stringr::str_glue("{instrument}_text_feeling_5_motivation")
  stanco_response <- stringr::str_glue("{instrument}_text_feeling___6")
  stanco_motivation <- stringr::str_glue("{instrument}_text_feeling_6_motivation")
  
  mattina_response <- stringr::str_glue("{instrument}_text_daytime___1")
  mattina_motivation <- stringr::str_glue("{instrument}_text_daytime_1_motivation")
  pomeriggio_response <- stringr::str_glue("{instrument}_text_daytime___2")
  pomeriggio_motivation <- stringr::str_glue("{instrument}_text_daytime_2_motivation")
  sera_response <- stringr::str_glue("{instrument}_text_daytime___3")
  sera_motivation <- stringr::str_glue("{instrument}_text_daytime_3_motivation")
  notte_response <- stringr::str_glue("{instrument}_text_daytime___4")
  notte_motivation <- stringr::str_glue("{instrument}_text_daytime_4_motivation")

  andamento_response <- stringr::str_glue("{instrument}_text_trend")
  andamento_motivation <- stringr::str_glue("{instrument}_text_trend_motivation")
  impatto_response <- stringr::str_glue("{instrument}_text_impact")
  impatto_motivation <- stringr::str_glue("{instrument}_text_impact_motivation")

  db_queried |>
    dplyr::mutate(
      dplyr::across(
        dplyr::where(is.character),
        \(x) dplyr::na_if(x, "NA")
      ),
      dplyr::across(
        dplyr::matches("^sensazione_.*_risposta"),
        parse_checkbox
      ),
      dplyr::across(
        dplyr::matches("^momento_.*_risposta"),
        parse_checkbox
      ),
      andamento_risposta = parse_gpt_fctr(
        from_str = .data[["andamento_risposta"]],
        to_fct = .data[[andamento_response]]
      ),
      impatto_risposta = parse_gpt_fctr(
        from_str = .data[["impatto_risposta"]],
        to_fct = .data[[impatto_response]]
      )
    ) |> 
    dplyr::mutate(
      !!calmo_response := .data[["sensazione_calmo_risposta"]],
      !!calmo_motivation := .data[["sensazione_calmo_motivazione"]],
      !!irritato_response := .data[["sensazione_irritato_risposta"]],
      !!irritato_motivation := .data[["sensazione_irritato_motivazione"]],
      !!ansioso_response := .data[["sensazione_ansioso_risposta"]],
      !!ansioso_motivation := .data[["sensazione_ansioso_motivazione"]],
      !!ottimista_response := .data[["sensazione_ottimista_risposta"]],
      !!ottimista_motivation := .data[["sensazione_ottimista_motivazione"]],
      !!demotivato_response := .data[["sensazione_demotivato_risposta"]],
      !!demotivato_motivation := .data[["sensazione_demotivato_motivazione"]],
      !!stanco_response := .data[["sensazione_stanco_risposta"]],
      !!stanco_motivation := .data[["sensazione_stanco_motivazione"]],

      !!mattina_response := .data[["momento_mattina_risposta"]],
      !!mattina_motivation := .data[["momento_mattina_motivazione"]],
      !!pomeriggio_response := .data[["momento_pomeriggio_risposta"]],
      !!pomeriggio_motivation := .data[["momento_pomeriggio_motivazione"]],
      !!sera_response := .data[["momento_sera_risposta"]],
      !!sera_motivation := .data[["momento_sera_motivazione"]],
      !!notte_response := .data[["momento_notte_risposta"]],
      !!notte_motivation := .data[["momento_notte_motivazione"]],
      
      !!andamento_response := .data[["andamento_risposta"]],
      !!andamento_motivation := .data[["andamento_motivazione"]],
      !!impatto_response := .data[["impatto_risposta"]],
      !!impatto_motivation := .data[["impatto_motivazione"]]
    ) |>
    dplyr::select(-dplyr::all_of(c(
      "sensazione_calmo_risposta",
      "sensazione_calmo_motivazione",
      "sensazione_irritato_risposta",
      "sensazione_irritato_motivazione",
      "sensazione_ansioso_risposta",
      "sensazione_ansioso_motivazione",
      "sensazione_ottimista_risposta",
      "sensazione_ottimista_motivazione",
      "sensazione_demotivato_risposta",
      "sensazione_demotivato_motivazione",
      "sensazione_stanco_risposta",
      "sensazione_stanco_motivazione",
      "momento_mattina_risposta",
      "momento_mattina_motivazione",
      "momento_pomeriggio_risposta",
      "momento_pomeriggio_motivazione",
      "momento_sera_risposta",
      "momento_sera_motivazione",
      "momento_notte_risposta",
      "momento_notte_motivazione",
      "andamento_risposta",
      "andamento_motivazione",
      "impatto_risposta",
      "impatto_motivazione"
    ))) |>
    dplyr::mutate(
      !!stringr::str_glue(
        "{instrument}_text_processed_record___1"
      ) := 1L
    ) |>
    dplyr::mutate(
      dplyr::across(dplyr::where(is.factor), \(x) as.integer(x)),
      dplyr::across(dplyr::where(is.logical), \(x) as.integer(x))
    )
}
