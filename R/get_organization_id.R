#' Get Organization ID
#' @return numeric org_id
#' @export
get_organization_id <- function() {
  res <- httr::RETRY(
    "GET",
    "https://api.perch.fit/v2/user",
    httr::add_headers(Authorization = paste("Bearer", getOption("perchr.token"))),
    times = 5, pause_min = 0.5
  )
  httr::stop_for_status(res)
  body <- jsonlite::fromJSON(httr::content(res, "text", encoding = "UTF-8"), simplifyVector = TRUE)
  org_id <- body$data$org_id
  if (is.null(org_id)) stop("org_id not found in response$data.")
  org_id
}