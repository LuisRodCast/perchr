#' Get Sets from Perch API
#'
#' @param org_id Organization ID
#' @param begin_time Optional POSIXct or Unix time
#' @param end_time Optional POSIXct or Unix time
#' @param include_reps Logical, include reps array
#' @param untracked 'INCLUDE' or 'EXCLUDE'
#' @return List with sets and referenced objects
#' @export
get_sets <- function(org_id,
                     begin_time = NULL,
                     end_time   = NULL,
                     include_reps = FALSE,
                     untracked  = "INCLUDE") {
  body <- list(
    group_id     = org_id,
    include_reps = include_reps,
    untracked    = untracked
  )
  if (!is.null(begin_time)) body$begin_time <- begin_time
  if (!is.null(end_time))   body$end_time   <- end_time
  
  all <- list()
  repeat {
    res <- httr::RETRY( # retry helps with transient aborts
      "POST",
      url = "https://api.perch.fit/v3/sets",
      httr::add_headers(Authorization = paste("Bearer", getOption("perchr.token"))),
      body = body,
      encode = "json",
      times = 5, pause_min = 0.5
    )
    txt <- httr::content(res, "text", encoding = "UTF-8")
    page <- jsonlite::fromJSON(txt, simplifyVector = TRUE)
    
    all <- append(all, list(page$data %||% list()))
    
    if (is.null(page$next_token) || isFALSE(page$truncated)) break
    body$next_token <- page$next_token
    Sys.sleep(0.2)
  }
  dplyr::bind_rows(all)
}
