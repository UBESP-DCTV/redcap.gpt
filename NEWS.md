# redcap.gpt (development version)

# redcap.gpt 0.2.0

* allow `query_gpt_on_redcap_instrument` to process the whole db setting `query_all_records` to `TRUE`.
* change `parse_sensazione` to a more general `parse_checkbox`.

# redcap.gpt 0.1.1

* Added support of `targets` and `tarchetypes`.
* Fix levels name for the trend question (fix issue #1).

# redcap.gpt 0.1.0

* Change factors and logical behavior accordingly to REDCapR specification for writing on REDCap.
* Add `query_gpt_on_redcap_instrument()` to extract (our) information of interest from the instrument identified.
* Add `parse_sensazione()` and `parse_gpt_fctr()` to parse the gpt categories extracted form the answers, converting them (respectively) to logical vectors, and factors with the proper levels.
* Add `gpt_to_tibble()` to parse gpt JSON hierarchical responses into a suitable, flat, tibble.
* Add `fetch_redcap()` and `fetch_form()` to fetch data from the REDCap project.
* Provided templates (`.Renviron-template`, and `dev/redcap-credentials.csv`) and example usage (`analyses/connect.R`) to connect to the REDCap project.
* Add `get_redcap_uri()`, `get_redcap_pid()`, and `get_redcap_token()` to safely read environmental variable to setup the connection with the project.
* Setup GitHub environment.
* Setup dev environment.
