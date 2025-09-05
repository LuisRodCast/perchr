#' Get sets (paginated)
#'
#' @param org_id Numeric organization ID.
#' @param begin_time,end_time Optional epoch seconds.
#' @param include_reps Logical; if TRUE, include rep data in output.
#' @param untracked One of "INCLUDE" or "EXCLUDE".
#' @param verbose Logical; if TRUE, prints progress.
#'
#' @return If include_reps = TRUE, a list with $sets and $reps data.frames; else just the sets.
#' @export
get_sets <- function(org_id,
                     begin_time = NULL,
                     end_time = NULL,
                     include_reps = FALSE,
                     untracked = "INCLUDE",
                     verbose = TRUE) {

  all_sets <- list()
  all_reps <- list()
  next_token <- NULL
  page <- 1

  repeat {
    body <- list(
      group_id = org_id,
      begin_time = begin_time,
      end_time = end_time,
      include_reps = include_reps,
      untracked = untracked
    )
    if (!is.null(next_token)) {
      body$next_token <- next_token
    }

    if (verbose) message(sprintf("Requesting page %d...", page))

    res <- httr::POST(
      url = "https://api.perch.fit/v3/sets",
      httr::add_headers(
        Authorization = .bearer(),
        `Content-Type` = "application/json"
      ),
      body = body,
      encode = "json"
    )

    if (httr::status_code(res) != 200) {
      warning("Request failed with status code: ", httr::status_code(res))
      return(NULL)
    }

    parsed <- jsonlite::fromJSON(
      httr::content(res, as = "text", encoding = "UTF-8"),
      flatten = TRUE
    )

    # Exit if no data
    if (is.null(parsed$data) || length(parsed$data) == 0) {
      if (verbose) message("No sets returned.")
      break
    }

    sets_batch <- parsed$data

    # If reps included
    if (include_reps && "reps" %in% names(sets_batch)) {
      all_reps <- c(all_reps, sets_batch$reps)
      sets_batch$reps <- NULL
    }

    all_sets <- append(all_sets, list(sets_batch))

    if (is.null(parsed$next_token)) {
      if (verbose) message("All pages retrieved.")
      break
    } else {
      next_token <- parsed$next_token
      page <- page + 1
    }
  }

  sets_df <- dplyr::bind_rows(all_sets)

  if (include_reps) {
    reps_df <- dplyr::bind_rows(all_reps)
    return(list(sets = sets_df, reps = reps_df))
  } else {
    return(sets_df)
  }
}
