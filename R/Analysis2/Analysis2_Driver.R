# Canonical Analysis2 driver. Source locally from the BASIL-II-RS project.
# Requirements: R >= 4.3, Quarto CLI, packages in 000-Libraries.R.
# Control: R/Analysis2/Analysis2_Control.qmd owns inputs, methods, and report order.
# Reads local data only; writes Analysis2-prefixed interim files, figures, tables,
# and dated HTML. Does not alter Analysis1 or DATA/SOURCE or DATA/DERIVED.
if (!requireNamespace("here", quietly = TRUE) ||
    !requireNamespace("quarto", quietly = TRUE)) stop("Install here and quarto locally.")
here::i_am("R/Analysis2/Analysis2_Driver.R")
analysis <- "Analysis2"
src_dir <- here::here("R", analysis)
control <- file.path(src_dir, "Analysis2_Control.qmd")
for (f in c(control, here::here("TEMPLATES", "letter.css"),
            here::here("TEMPLATES", "letter_css_scripts.html"))) {
  if (!file.exists(f)) stop("Required source file absent: ", f)
}
# Render beside control; never use --output-dir (shared output folders are retained).
output_name <- paste0(analysis, "_agreement.html")
built <- file.path(src_dir, output_name)
quarto::quarto_render(input = control, output_format = "html",
                      output_file = output_name)
if (!file.exists(built)) stop("Quarto did not create the expected HTML.")
for (folder in c("RENDER", "REPORTS")) {
  dir.create(here::here(folder), showWarnings = FALSE)
}
flat <- here::here("RENDER", output_name)
if (!file.copy(built, flat, overwrite = TRUE)) stop("Cannot stage rendered HTML.")
unlink(built)
dated <- here::here("REPORTS", paste0(analysis, "_agreement_", Sys.Date(), ".html"))
if (!file.copy(flat, dated, overwrite = TRUE)) stop("Cannot archive rendered HTML.")
message("Created ", dated)
