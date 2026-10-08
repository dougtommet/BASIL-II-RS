

basil_netpath <- fs::path(QSPtools::network_path(), "STUDIES", "DATA_MANAGEMENT", "BASIL")

# Check if the network path exists
if (fs::dir_exists(basil_netpath)) {
  # print(paste("connected to",basil_netpath))
} else if (Sys.info()["user"] == "rnj") {
  basil_netpath <- here::here("..", "..", "DATA_MANAGEMENT", "BASIL")
} else if (Sys.info()["user"] == "douglastommet") {
  # Fall back to a local or alternative path
  basil_netpath <- fs::path_home("Documents", "DWork", "Brown_Network_sync", "STUDIES", "DATA_MANAGEMENT", "BASIL")
}

basil_derived_folder <- fs::path(basil_netpath, "DATA", "DERIVED")
basil_project_folder <- fs::path(basil_netpath, "CODE", "RS_Paper")

required_basil_files <- c("BASILIIMainStudy_Derived.dta", "n488.dta")
missing_basil_files <- required_basil_files[
  !fs::file_exists(fs::path(basil_derived_folder, required_basil_files))
]
if (length(missing_basil_files) > 0) {
  stop(
    "Required BASIL derived data files not found in ",
    basil_derived_folder,
    ": ",
    paste(missing_basil_files, collapse = ", ")
  )
}

if (fs::dir_exists(here::here("R", "RDATA"))==FALSE) {
  fs::dir_create(here::here("R", "RDATA"))
}
