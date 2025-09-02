#' Authenticate with Perch API
#'
#' Stores your API token in an R option for the current session.
#'
#' @param token Character. Your Perch API token.
#' @return Invisibly returns the token (invisibly).
#' @examples
#' # perch_auth("abc123")
#' @export
perch_auth <- function(token) {
  options(perchr.token = trimws(token))
}

# internal helpers (not exported)
.get_token <- function() {
  tok <- getOption("perchr.token")
  if (is.null(tok) || !nzchar(tok)) stop("Token not set. Call perch_auth('...') first.")
  tok
}
.bearer <- function() paste("Bearer", .get_token())
