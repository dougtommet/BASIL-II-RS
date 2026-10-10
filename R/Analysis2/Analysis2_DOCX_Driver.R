# One-off DOCX trial; the canonical Analysis2 driver remains HTML.
# Requirements: R >= 4.3, Quarto CLI, flextable, packages in 000-Libraries.R.
# Control: R/Analysis2/Analysis2_DOCX_Control.qmd; DOCX-specific table child.
# Reuses Analysis1's Word-safe helper; LibreOffice is optional.
# Rebuilds the same Analysis2 interim files, figures, and table exports as HTML.
if (!requireNamespace("here", quietly = TRUE) ||
    !requireNamespace("quarto", quietly = TRUE)) stop("Install here and quarto locally.")
here::i_am("R/Analysis2/Analysis2_DOCX_Driver.R")
analysis <- "Analysis2"
src_dir <- here::here("R", analysis)
control <- file.path(src_dir, "Analysis2_DOCX_Control.qmd")
word_helper <- here::here("R", "Analysis1", "002-Word-safe-docx.R")
for (f in c(control, here::here("TEMPLATES", "reference_report.docx"), word_helper)) {
  if (!file.exists(f)) stop("Required source file absent: ", f)
}
source(word_helper)
output_name <- paste0(analysis, "_agreement_oneoff.docx")
built <- file.path(src_dir, output_name)
quarto::quarto_render(input = control, output_format = "docx",
                      output_file = output_name)
check_docx(built, "Rendered DOCX")
for (folder in c("RENDER", "REPORTS")) {
  dir.create(here::here(folder), showWarnings = FALSE)
}
flat <- here::here("RENDER", output_name)
if (!file.copy(built, flat, overwrite = TRUE)) stop("Cannot stage rendered DOCX.")
unlink(built)
dated <- here::here("REPORTS", paste0(analysis, "_agreement_oneoff_", Sys.Date(), ".docx"))
converted <- word_safe_docx(flat, dated, quiet = TRUE)
message("Created ", dated, if (converted) " (re-saved through LibreOffice)." else
          " (unconverted Quarto DOCX).")
