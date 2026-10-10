# Run after the DOCX driver: Rscript R/Analysis2/tests/test-docx-tables.R
# Requirements: here, knitr, xml2 (installed with flextable's dependencies).
here::i_am("R/Analysis2/tests/test-docx-tables.R")
load_qmd_functions <- function(file) {
  extracted <- tempfile(fileext = ".R")
  on.exit(unlink(extracted))
  knitr::purl(file, output = extracted, documentation = 0, quiet = TRUE)
  functions <- new.env(parent = globalenv())
  for (expr in parse(extracted)) {
    if (is.call(expr) && identical(expr[[1]], as.name("<-")) &&
        is.call(expr[[3]]) && identical(expr[[3]][[1]], as.name("function")))
      eval(expr, envir = functions)
  }
  functions
}
html <- load_qmd_functions(here::here("R", "Analysis2", "manuscript-tables.qmd"))
docx <- load_qmd_functions(here::here("R", "Analysis2", "manuscript-tables-docx.qmd"))
for (name in c("manuscript_result", "manuscript_interval", "manuscript_characteristics",
               "build_manuscript_tables")) {
  stopifnot(identical(formals(html[[name]]), formals(docx[[name]])),
            identical(body(html[[name]]), body(docx[[name]])))
}

expected <- list()
expected_notes <- list()
for (file in list.files(here::here("MD"), pattern = "^Analysis2_.*\\.md$", full.names = TRUE)) {
  lines <- readLines(file, warn = FALSE)
  captions <- grep("^(Table T[A-Z]+\\.|Table 1\\.|Supplemental Table [12]\\.) ", lines)
  for (i in captions) {
    j <- i + 1L
    while (j <= length(lines) && !startsWith(lines[j], "|")) j <- j + 1L
    rows <- list()
    while (j <= length(lines) && startsWith(lines[j], "|")) {
      cells <- strsplit(sub("\\|\\s*$", "", sub("^\\|", "", lines[j])), "|", fixed = TRUE)[[1]]
      rows[[length(rows) + 1L]] <- trimws(cells)
      j <- j + 1L
    }
    if (length(rows) < 2L) stop("No Markdown table for: ", lines[i])
    rows <- rows[-2L]
    if (rows[[1]][1] == "Group") {
      grouped <- list(rows[[1]][-1L])
      group <- ""
      for (row in rows[-1L]) {
        if (row[1] != group) {
          group <- row[1]
          grouped[[length(grouped) + 1L]] <- group
        }
        grouped[[length(grouped) + 1L]] <- row[-1L]
      }
      rows <- grouped
    }
    expected[[lines[i]]] <- rows
    while (j <= length(lines) && !grepl("^(NOTES\\.|Notes:)", lines[j])) j <- j + 1L
    if (j > length(lines)) stop("No notes for: ", lines[i])
    expected_notes[[lines[i]]] <- lines[j]
  }
}
stopifnot(length(expected) == 31L)
check_tables <- function(file) {
  work <- tempfile("docx_tables_")
  dir.create(work)
  on.exit(unlink(work, recursive = TRUE))
  utils::unzip(file, files = "word/document.xml", exdir = work)
  document <- xml2::read_xml(file.path(work, "word", "document.xml"))
  ns <- c(w = "http://schemas.openxmlformats.org/wordprocessingml/2006/main")
  elements <- xml2::xml_children(xml2::xml_find_first(document, ".//w:body", ns))
  table_indices <- which(xml2::xml_name(elements) == "tbl")
  stopifnot(length(table_indices) == 31L,
            length(xml2::xml_find_all(document, ".//w:drawing", ns)) == 4L)
  seen <- character()
  for (i in table_indices) {
    caption <- paste0(xml2::xml_text(xml2::xml_find_all(elements[[i - 1L]], ".//w:t", ns)),
                      collapse = "")
    if (is.null(expected[[caption]])) stop("Missing or unexpected caption: ", caption)
    notes <- paste0(xml2::xml_text(xml2::xml_find_all(elements[[i + 1L]], ".//w:t", ns)),
                    collapse = "")
    notes <- chartr("\u2018\u2019\u201c\u201d", "''\"\"", notes)
    if (!identical(trimws(notes), trimws(expected_notes[[caption]])))
      stop("Word notes differ from Markdown export: ", caption, "; got: ", notes)
    rows <- lapply(xml2::xml_find_all(elements[[i]], "./w:tr", ns), function(row) {
      vapply(xml2::xml_find_all(row, "./w:tc", ns), function(cell) {
        text <- paste0(xml2::xml_text(xml2::xml_find_all(cell, ".//w:t", ns)), collapse = "")
        gsub("\u00a0", " ", text, fixed = TRUE)
      }, character(1))
    })
    reference <- expected[[caption]]
    stopifnot(length(rows) == length(reference))
    for (j in seq_along(rows)) {
      stopifnot(length(rows[[j]]) == length(reference[[j]]))
      for (k in seq_along(rows[[j]])) {
        actual <- rows[[j]][k]
        target <- reference[[j]][k]
        numeric_pattern <- "^[+-]?[0-9]+(\\.[0-9]+)?([eE][+-]?[0-9]+)?$"
        equal <- if (grepl(numeric_pattern, actual) && grepl(numeric_pattern, target))
          isTRUE(all.equal(as.numeric(actual), as.numeric(target), tolerance = 1e-12)) else
          identical(actual, target)
        if (!equal) stop("Word cell differs from Markdown export: ", caption,
                         "; row ", j, ", column ", k, " in ", file)
      }
    }
    seen <- c(seen, caption)
  }
  stopifnot(setequal(seen, names(expected)), !anyDuplicated(seen))
  message(basename(file), ": 31 tables, all captions, notes, and cells match; 4 figures.")
}
check_tables(here::here("RENDER", "Analysis2_agreement_oneoff.docx"))
check_tables(here::here("REPORTS", paste0("Analysis2_agreement_oneoff_", Sys.Date(), ".docx")))
