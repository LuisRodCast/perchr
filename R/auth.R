# Internal environment to hold auth state
.perch_env <- new.env(parent = emptyenv())

#' Authenticate with the Perch API
#'
#' @param token A valid API token string.
#' @return Invisibly returns TRUE.
#' @export
perch_auth <- function(token) {
  .perch_env$token <- token
  invisible(TRUE)
}

#' Construct Bearer token for Authorization header
#'
#' Internal helper. Falls back to PERCH_TOKEN env var.
#' @return A string like "Bearer <token>"
#' @noRd
.bearer <- function() {
  token <- .perch_env$token
  if (is.null(token) || token == "") {
    token <- Sys.getenv("PERCH_TOKEN")
  }
  if (token == "") stop("Token not set. Use perch_auth() or set PERCH_TOKEN.")
  paste("Bearer", token)
}
