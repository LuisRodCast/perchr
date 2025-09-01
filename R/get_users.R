#' Get one page of Users
#' @param org_id numeric
#' @param next_token character cursor (from previous page)
#' @keywords internal
get_users_page <- function(org_id, next_token = NULL) {
  body <- list(group_id = org_id)
  if (!is.null(next_token)) body$next_token <- next_token
  
  res <- httr::RETRY(
    "POST",
    url = "https://api.perch.fit/v2/users",
    httr::add_headers(Authorization = .bearer()),
    body = body, encode = "json",
    times = 5, pause_min = 0.5
  )
  httr::stop_for_status(res)
  jsonlite::fromJSON(httr::content(res, "text", encoding = "UTF-8"), simplifyVector = TRUE)
}

#' Get all Users (paged)
#' @param org_id numeric
#' @return data.frame of users
#' @export
get_all_users <- function(org_id) {
  out <- list(); cursor <- NULL
  repeat {
    page <- get_users_page(org_id, cursor)
    out <- append(out, list(page$data %||% list()))
    cursor <- page$next_token
    if (is.null(cursor) || isFALSE(page$truncated)) break
    Sys.sleep(0.2)
  }
  dplyr::bind_rows(out)
}
