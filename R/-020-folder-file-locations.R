

basil_netpath <- fs::path(QSPtools::network_path(), "STUDIES", "DATA_MANAGEMENT", "BASIL")

# Check if the network path exists
if (fs::dir_exists(basil_netpath)) {
  print(paste("connected to",basil_netpath))
} else if (Sys.info()["user"] == "rnj") {
  # Fall back to a local or alternative path
  basil_netpath <- fs::path_home("DWork", "DATA_MANAGEMENT", "BASIL")
} else if (Sys.info()["user"] == "douglastommet") {
  # Fall back to a local or alternative path
  basil_netpath <- fs::path_home("Documents", "DWork", "Brown_Network_sync", "STUDIES", "DATA_MANAGEMENT", "BASIL")
}

basil_derived_folder <- fs::path(basil_netpath, "DATA", "DERIVED")
basil_project_folder <- fs::path(basil_netpath, "CODE", "RS_Paper")


