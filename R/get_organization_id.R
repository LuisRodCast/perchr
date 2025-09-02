#' Get your organization's id (from /v2/user)
#' @return numeric org_id
#' @export
get_organization_id <- function() {
  res <- httr::RETRY(
    "GET",
    "https://api.perch.fit/v2/user",
    httr::add_headers(Authorization = .bearer()),
    times = 3, pause_min = 0.3
  )
  httr::stop_for_status(res)
  
  txt <- httr::content(res, "text", encoding = "UTF-8")
  out <- jsonlite::fromJSON(txt, simplifyVector = TRUE)
  
  org_id <- suppressWarnings(as.numeric(out$data$org_id))
  if (!is.finite(org_id)) stop("Could not find numeric org_id in /v2/user response.")
  org_id
}
