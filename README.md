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

## Another Option
```r
#Once library is loaded, you can try this code to authenticate, get perch_users, perch_exercises, 
#and perch_sets (gives a list of sets & reps; this is a long pull if you have a lot of data)

perch_auth(token = "YOUR_PERCH_TOKEN_HERE")

begin <- as.numeric(as.POSIXct("2024-04-01 00:00:00", tz = "UTC"))

org_id <- get_organization_id()
perch_users <- get_all_users(org_id = org_id)
perch_exercises <- get_all_exercises(org_id = org_id)
perch_sets <- get_sets(
  org_id = org_id,
  begin_time = begin_time,
  include_reps = TRUE
)
```
