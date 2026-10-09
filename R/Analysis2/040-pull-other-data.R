# Same inputs as Analysis1, read only. Path is controlled by Control QMD.
basil_derived_folder <- here::here(params$basil_derived_folder)
files <- file.path(basil_derived_folder, c("BASILIIMainStudy_Derived.dta", "n488.dta"))
if (!all(file.exists(files))) stop("Missing local BASIL derived input(s): ",
                                  paste(basename(files[!file.exists(files)]), collapse = ", "))
basil_redcap <- haven::read_dta(files[1])
n488 <- haven::read_dta(files[2])
saveRDS(n488, here::here("R", "RDATA", "Analysis2_040-n488.rds"))
saveRDS(basil_redcap, here::here("R", "RDATA", "Analysis2_040-basil_redcap.rds"))
