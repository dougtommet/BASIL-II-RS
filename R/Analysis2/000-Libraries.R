# Requirements: R >= 4.3, Quarto CLI, and these CRAN packages installed locally.
# No installation, downloads, telemetry, or network calls during analysis.
required <- c("here", "quarto", "readxl", "janitor", "dplyr", "tidyr",
              "stringr", "labelled", "haven", "ebal", "irrCAC", "ggplot2",
              "ragg", "knitr", "kableExtra")
missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) stop("Install these packages locally before running: ",
                          paste(missing, collapse = ", "))
suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(stringr)
})
