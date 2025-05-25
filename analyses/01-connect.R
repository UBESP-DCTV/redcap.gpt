library(REDCapR)
library(here)

devtools::load_all()

# Using environmental variable (suggested)
env_cred <- REDCapR::redcap_read(
  redcap_uri = get_redcap_uri(),
  token = get_redcap_token()
)

# using local credential file (NOT suggested)

credential <- REDCapR::retrieve_credential_local(
  path_credential = here("dev/redcap-credentials.csv"),
  project_id = 17
)

local_cred <- REDCapR::redcap_read(
  redcap_uri = credential$redcap_uri,
  token = credential$token
)

identical(env_cred$data, local_cred$data)
