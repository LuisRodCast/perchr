# perchr

[![R-CMD-check](https://github.com/LuisRodCast/perchr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/LuisRodCast/perchr/actions/workflows/R-CMD-check.yaml)


The **perchr** package provides a simple R interface to the Perch API, enabling users to
authenticate, retrieve, and organize Perch data (e.g., sets, users, exercises)
directly into R for analysis.

## Installation

```r
# Install devtools if needed
install.packages("devtools")

# Install perchr from GitHub
devtools::install_github("LuisRodCast/perchr")

# Load the package
library(perchr)
```

## Authentication (keep your token out of scripts)

**Recommended:** store your token in an environment variable and read it at runtime:

1. Open your user `.Renviron`:
   ```r
   usethis::edit_r_environ()
   ```
2. Add a line (replace with your token), save, and restart R:
   ```
   PERCH_TOKEN=your_real_token_here
   ```
3. Authenticate:
   ```r
   perch_auth(Sys.getenv("PERCH_TOKEN"))
   ```

**Quick (less secure) option for testing only:**
```r
perch_auth(token = "YOUR_PERCH_API_TOKEN_GOES_HERE")
```

## Quick start

```r
# Get your organization ID (from /v2/user)
org_id <- get_organization_id()
print(org_id)

# If you already know your organization ID, you can set it directly:
# org_id <- 12345
```

```r
# Pull organization data
users     <- get_all_users(org_id)        # all users (paged)
exercises <- get_all_exercises(org_id)    # all exercises (paged)
sets      <- get_sets(org_id)             # sets (paged; latest first)

head(users)
head(exercises)
head(sets)
```

## Optional configuration (advanced)

These are usually **not** required; perchr defaults to the production API.

```r
# From Perch docs / Swagger
base_url    <- "https://api.perch.fit"

# Most installations use Bearer; change to "JWT" only if your server explicitly requires it
auth_scheme <- "Bearer"

# Your current token in this R session (set by perch_auth())
token <- getOption("perchr.token")

# Example: a default begin date if you build your own incremental logic
begin <- as.numeric(as.POSIXct("2024-04-01 00:00:00", tz = "UTC"))
```

## Notes

- Endpoints used by the high-level helpers:
  - `/v2/user` <U+2192> `get_organization_id()`
  - `/v2/users` <U+2192> `get_all_users()`
  - `/v3/exercises` <U+2192> `get_all_exercises()`
  - `/v3/sets` <U+2192> `get_sets()`
- JSON is parsed as UTF-8.
- Returned objects are data frames (tibbles), ready for analysis with dplyr.


