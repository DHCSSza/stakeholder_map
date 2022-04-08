#' Authenticate Google Credentials (sourced from https://github.com/jdtrat/tokencodr-google-demo)
#'
#' @param service The name of the service used to encrypt a file with [tokencodr::encrypt_token()]
#' @param token_path Path to encrypted json file, the `destination` field of [tokencodr::encrypt_token()].
#'
#' @return NA; used to authenticate Google Credentials
#'
auth_google <- function(email, service, token_path) {
  googlesheets4::gs4_auth(email = "*@talarify.co.za", path = tokencodr::decrypt_token(service = service,
                                                          path = token_path,
                                                          complete = TRUE))
}
