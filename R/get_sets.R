#' Get sets (paged)
#'
#' @param org_id Numeric organization id.
#' @param begin_time,end_time Optional numeric epoch seconds.
#' @param include_reps Logical; include rep arrays.
#' @param untracked One of "INCLUDE" or "EXCLUDE".
#' @return A data frame of sets (joined with user/exercise names when available).
#' @examples
#' \dontrun{
#'   perch_auth(Sys.getenv("PERCH_TOKEN"))
#'   oid <- get_organization_id()
#'   sets <- get_sets(oid)
#' }
#' @export
get_sets <- function(org_id, begin_time = NULL, end_time = NULL,
                     include_reps = FALSE, untracked = "INCLUDE") {
  # your current implementation (using .bearer() + UTF-8 parsing) goes here
}
