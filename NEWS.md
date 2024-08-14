# redcap.gpt (development version)

* Add `gpt_to_tibble()` to parse gpt JSON hierarchical responses into a suitable, flat, tibble.
* Add `fetch_redcap()` and `fetch_form()` to fetch data from the REDCap project.
* Provided templates (`.Renviron-template`, and `dev/redcap-credentials.csv`) and example usage (`analyses/connect.R`) to connect to the REDCap project.
* Add `get_redcap_uri()`, `get_redcap_pid()`, and `get_redcap_token()` to safely read environmental variable to setup the connection with the project.
* Setup GitHub environment.
* Setup dev environment.
