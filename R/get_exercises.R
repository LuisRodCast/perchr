#' Get all exercises (paged)
#'
#' @param org_id Numeric organization id.
#' @return A data frame of exercises.
#' @examples
#' \dontrun{
#'   perch_auth(Sys.getenv("PERCH_TOKEN"))
#'   oid <- get_organization_id()
#'   exs <- get_all_exercises(oid)
#' }
#' @export
get_all_exercises <- function(org_id) {
  exs <- list(); cursor <- NULL
  repeat {
    page <- get_exercises_page(org_id, cursor)
    exs  <- append(exs, list(page$data %||% list()))
    cursor <- page$next_token
    if (is.null(cursor) || isFALSE(page$truncated)) break
    Sys.sleep(0.2)
  }
  dplyr::bind_rows(exs)
}

# not exported
get_exercises_page <- function(org_id, next_token = NULL) {
  body <- list(org_id = org_id)
  if (!is.null(next_token)) body$next_token <- next_token
  res <- httr::RETRY(
    "POST",
    "https://api.perch.fit/v3/exercises",
    httr::add_headers(Authorization = .bearer()),
    body = body, encode = "json",
    times = 5, pause_min = 0.5
  )
  httr::stop_for_status(res)
  jsonlite::fromJSON(httr::content(res, "text", encoding = "UTF-8"), simplifyVector = TRUE)
}
