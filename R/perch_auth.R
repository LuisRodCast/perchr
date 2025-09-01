#' Authenticate with Perch API
#' @param token character, your API token
#' @export
perch_auth <- function(token) {
  options(perchr.token = token)
}
.get_token <- function() {
  tok <- getOption("perchr.token")
  if (is.null(tok) || !nzchar(tok)) stop("Token not set. Call perch_auth('...') first.")
  tok
}
.bearer <- function() paste("Bearer", .get_token())
