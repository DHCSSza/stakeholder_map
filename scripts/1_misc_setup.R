# adapted from https://github.com/jdtrat/tokencodr-google-demo
# also see https://tokencodr.jdtrat.com/articles/tokencodr.html

# remotes::install_github("jdtrat/tokencodr")
library(tokencodr)
library(googlesheets4)
library(googledrive)

# Run once and copy password to .Renviron
# Added this to GitHub repository secrets, with the name "GSHEET_ACCESS_PASSWORD"
# just copy the password to the secret
tokencodr::create_env_pw("GSHEET_ACCESS")

# Assumes the JSON file is a Google Service Account as described here:
# https://gargle.r-lib.org/articles/get-api-credentials.html#service-account-token
# the encrypted json file saved in .secrets folder in GitHub repo
tokencodr::encrypt_token(service = "GSHEET_ACCESS", # "stakeholder_map"
                         input = "sheets_service_account_key.json", 
                         destination = "path-to-save-encrypted-json-file")

# Locally Authenticate Google Sheets & Google Drive
googlesheets4::gs4_auth(path = tokencodr::decrypt_token(service = "GSHEET_ACCESS",
                                                        path = ".secret/GSHEET_ACCESS",
                                                        complete = TRUE))

