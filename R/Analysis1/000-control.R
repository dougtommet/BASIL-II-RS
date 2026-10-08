
analysis <- "Analysis1"

render_and_archive <- function(input_stem, output_stem, output_format = "html") {
  input <- here::here("R", analysis, paste0(input_stem, ".qmd"))
  output_name <- paste0(analysis, "_", output_stem, ".", output_format)
  built <- here::here("R", analysis, output_name)

  quarto::quarto_render(
    input = input,
    output_format = output_format,
    output_file = output_name
  )

  render_dir <- here::here("RENDER")
  reports_dir <- here::here("REPORTS")
  fs::dir_create(render_dir)
  fs::dir_create(reports_dir)

  rendered <- file.path(render_dir, output_name)
  if (file.exists(rendered)) fs::file_delete(rendered)
  fs::file_move(built, rendered)

  report <- file.path(
    reports_dir,
    paste0(analysis, "_", output_stem, "_", Sys.Date(), ".", output_format)
  )
  if (!file.copy(rendered, report, overwrite = TRUE)) {
    stop("Could not copy rendered output to ", report)
  }
}

# Run the data management/log file
render_and_archive("_000-master", "BASIL_RS")

# Run the 2025-05-02 presentation
render_and_archive("ABC_presentation_2025-05-02", "ABC_presentation_2025-05-02")

# Run the 2025-05-30 presentation
render_and_archive("ABC_presentation_2025-05-30", "ABC_presentation_2025-05-30")
render_and_archive("ABC_presentation_2025-05-30", "ABC_presentation_2025-05-30", "docx")

# Run the 2025-06-06 presentation
render_and_archive("ABC_presentation_2025-06-06", "ABC_presentation_2025-06-06")

# Run the 2025-06-27 presentation
render_and_archive("ABC_presentation_2025-06-27", "ABC_presentation_2025-06-27")

# Run the 2025-07-11 presentation
render_and_archive("ABC_presentation_2025-07-11", "ABC_presentation_2025-07-11")
