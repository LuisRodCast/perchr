The perchr package provides a simple R interface to the Perch API, enabling users to
authenticate, retrieve, and organize Perch data (e.g., sets, users, exercises)
directly into R for analysis.

When opening your R Script session, use the following code to install.package, upload, 
and access the perchr package:

#install.packages("devtools") <- Uncomment this line if 'devtools' is already installed
devtools::install_github("LuisRodCast/perchr")

#Upload the perchr package into the environment
library(perchr)