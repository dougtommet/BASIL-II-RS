options(stringsAsFactors = FALSE)
set.seed(params$seed)
for (folder in c("R/RDATA", "FIGURES", "MD")) {
  dir.create(here::here(folder), recursive = TRUE, showWarnings = FALSE)
}
