# Utility to get stored token
`%||%` <- function(a, b) if (!is.null(a)) a else b

# Optional alias if you used it elsewhere:
get_token <- function() .get_token()