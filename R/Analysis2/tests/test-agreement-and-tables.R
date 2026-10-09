# Run from the project: Rscript R/Analysis2/tests/test-agreement-and-tables.R
here::i_am("R/Analysis2/tests/test-agreement-and-tables.R")
load_functions <- function(expressions) {
  for (expr in expressions) {
    if (is.call(expr) && identical(expr[[1]], as.name("<-")) &&
        is.call(expr[[3]]) && identical(expr[[3]][[1]], as.name("function"))) {
      eval(expr, envir = .GlobalEnv)
    }
  }
}
load_functions(parse(here::here("R", "Analysis2", "060-agreement.R")))
extracted <- tempfile(fileext = ".R")
knitr::purl(here::here("R", "Analysis2", "manuscript-tables.qmd"),
            output = extracted, documentation = 0, quiet = TRUE)
load_functions(parse(extracted))
unlink(extracted)
extracted <- tempfile(fileext = ".R")
knitr::purl(here::here("R", "Analysis2", "Analysis2_Control.qmd"),
            output = extracted, documentation = 0, quiet = TRUE)
load_functions(parse(extracted))
unlink(extracted)
expect_error <- function(expr) {
  result <- tryCatch(force(expr), error = identity)
  if (!inherits(result, "error")) stop("Expected an explicit error.")
}
stopifnot(identical(vapply(c(1, 17, 26, 27, 28, 52, 53), technical_table_id, character(1)),
                    c("TA", "TQ", "TZ", "TAA", "TAB", "TAZ", "TBA")),
          !anyDuplicated(vapply(1:100, technical_table_id, character(1))))
expect_error(technical_table_id(0))
expect_error(technical_table_id(1.5))
expect_error(technical_table_id(NA_real_))
set.seed(19)
x <- matrix(sample(0:10, 60 * 7, replace = TRUE), ncol = 7)
x[cbind(c(3, 9, 22), c(2, 5, 7))] <- NA
w <- seq(0.2, 3, length.out = nrow(x))
W <- category_weights(0:10, TRUE)
reference_kappa <- function(x, w) {
  p <- vapply(0:10, function(k) {
    vapply(seq_len(ncol(x)), function(j) {
      available <- !is.na(x[, j])
      sum(w[available] * (x[available, j] == k)) / sum(w[available])
    }, numeric(1))
  }, numeric(ncol(x)))
  stopifnot(max(abs(rowSums(p) - 1)) < 1e-12)
  pairs <- combn(ncol(x), 2)
  pe <- mean(apply(pairs, 2, function(jk) sum(W * outer(p[jk[1], ], p[jk[2], ]))))
  pa <- weighted.mean(row_agreement(x, 0:10, W), w)
  (pa - pe) / (1 - pe)
}
for (i in seq_len(100)) {
  idx <- if (i == 1) seq_len(nrow(x)) else sample.int(nrow(x), nrow(x), replace = TRUE)
  xx <- x[idx, , drop = FALSE]
  ww <- w[idx]
  point <- conger_point(xx, 0:10, W, ww)
  stopifnot(abs(point - reference_kappa(xx, ww)) < 1e-12,
            abs(point - conger_point(xx, 0:10, W, 7 * ww)) < 1e-12,
            point <= 1)
}
fit <- irrCAC::conger.kappa.raw(x, weights = W, categ.labels = 0:10, N = Inf)
stopifnot(abs(conger_point(x, 0:10, W) - fit$est$coeff.val) < 1e-5)
post <- x
post[1:15, 1] <- pmin(10, post[1:15, 1] + 1)
paired <- paired_kappa_change(x, post, 0:10, W, w, B = 100)
stopifnot(abs(paired$estimate - (reference_kappa(post, w) - reference_kappa(x, w))) < 1e-12)

participants <- data.frame(
  studyid = paste0("test", 1:60), vdsite = rep(1:3, 20), dementia = rep(0:1, 30),
  vdage = seq(65, 90, length.out = 60), vdfemale = rep(0:1, 30),
  vdrace = rep(c(1, 2, 3, 4, 5, NA), 10), vdhisp = rep(0:1, 30),
  vdeduc = c(NA, rep(14, 59)), vdesl = rep(0:1, 30), vdmarried = rep(0:1, 30),
  vdlivesalone = rep(0:1, 30), vdlivesinnh = rep(0:1, 30),
  vdcharlson = c(NA, rep(0:3, length.out = 59)),
  vdhearingimp = rep(0:1, 30), vdvisionimp = c(NA, rep(0:1, length.out = 59)),
  vdmajneurogs = rep(0:1, 30), vdminneurogs = rep(0:1, 30),
  vddeliriumgs = rep(0:1, 30), vddelseveritygs = rep(0:10, length.out = 60)
)
matrices <- list(severity_initial = x, severity_consensus = x,
                 presence_initial = (x > 5) * 1, presence_consensus = (x > 5) * 1)
agreement <- list()
for (key in names(matrices)) {
  quadratic <- startsWith(key, "severity")
  categories <- if (quadratic) 0:10 else 0:1
  for (group in c("Overall", "No dementia", "Dementia")) {
    use <- if (group == "Overall") rep(TRUE, 60) else
      participants$dementia == as.integer(group == "Dementia")
    xx <- matrices[[key]][use, , drop = FALSE]
    for (mode in c("Equal participant weights", "Entropy balanced")) {
      ans <- analyze_matrix(xx, categories, quadratic,
                            if (mode == "Equal participant weights") rep(1, sum(use)) else w[use],
                            mode, B = 100)
      if (mode == "Equal participant weights") {
        validation <- attr(ans, "package_validation")
        stopifnot(nrow(validation) == 1L, validation$absolute_difference <= validation$tolerance)
      }
      agreement[[length(agreement) + 1L]] <- cbind(
        outcome_stage = key, group = group, weighting = mode, participants = sum(use), ans
      )
    }
  }
}
agreement <- do.call(rbind, agreement)
tables <- build_manuscript_tables(agreement, participants, matrices, 488, 100)
stopifnot(identical(names(tables), c("main", "s1", "s2")),
          identical(vapply(tables, function(t) nrow(t$data), integer(1)), c(main = 10L, s1 = 23L, s2 = 18L)),
          !grepl("missing dementia", tables$s2$notes, fixed = TRUE))
primary_only <- agreement[agreement$weighting == "Entropy balanced", ]
stopifnot(identical(tables, build_manuscript_tables(primary_only, participants, matrices, 488, 100)))
missing_dementia <- participants
missing_dementia$dementia[1] <- NA
missing_dementia_tables <- build_manuscript_tables(agreement, missing_dementia, matrices, 488, 100)
stopifnot(grepl("Participants with missing dementia status (n = 1)",
               missing_dementia_tables$s2$notes, fixed = TRUE))
row <- manuscript_result(agreement, "severity_initial", "Overall", "Entropy balanced", "Kappa")
stopifnot(tables$main$data$Initial[3] == manuscript_interval(row),
          tables$main$data$Initial[2] == as.character(sum(!is.na(x))),
          tables$s1$data[[2]][3] == "10 (16.7)",
          tables$s1$data[[2]][7] == "20 (33.3)",
          tables$s1$data[[2]][9] == "14.0 (0.0)",
          grepl("Education: 1/1/0/0", tables$s1$notes, fixed = TRUE))
stopifnot(all(endsWith(tables$main$data$Measure[c(3:6, 9:10)], "(95% CI)")),
          !any(grepl("95% CI", tables$main$data$Measure[c(1:2, 7:8)], fixed = TRUE)),
          all(endsWith(tables$s2$data$Measure, "(95% CI)")),
          !any(grepl("95% CI", tables$s1$data$Characteristic, fixed = TRUE)))
metrics <- list(severity = c("Kappa", "exact", "within2", "MAD"), presence = c("Kappa", "exact"))
offset <- 0L
for (outcome in names(metrics)) {
  for (i in seq_along(c("initial", "consensus"))) {
    stage <- c("initial", "consensus")[i]
    expected <- vapply(metrics[[outcome]], function(metric) {
      manuscript_interval(manuscript_result(agreement, paste(outcome, stage, sep = "_"),
                                           "Overall", "Entropy balanced", metric))
    }, character(1))
    stopifnot(identical(unname(tables$main$data[[i + 1L]][offset + 2L + seq_along(expected)]),
                        unname(expected)))
  }
  offset <- offset + 2L + length(metrics[[outcome]])
}
for (g in seq_along(c("Overall", "No dementia", "Dementia"))) {
  group <- c("Overall", "No dementia", "Dementia")[g]
  for (i in seq_along(c("initial", "consensus"))) {
    stage <- c("initial", "consensus")[i]
    expected <- unlist(lapply(names(metrics), function(outcome) {
      vapply(metrics[[outcome]], function(metric) {
        manuscript_interval(manuscript_result(agreement, paste(outcome, stage, sep = "_"),
                                             group, "Entropy balanced", metric))
      }, character(1))
    }), use.names = FALSE)
    stopifnot(identical(tables$s2$data[[i + 1L]][(g - 1L) * 6L + 1:6], expected))
  }
}
changed <- agreement
changed$estimate[changed$outcome_stage == "severity_initial" & changed$group == "Overall" &
                   changed$weighting == "Entropy balanced" & changed$metric == "Kappa"] <- 0.123
updated <- build_manuscript_tables(changed, participants, matrices, 488, 100)
stopifnot(startsWith(updated$main$data$Initial[3], "0.123"))
changed <- agreement
changed$estimate[changed$weighting == "Equal participant weights"] <- 0.666
stopifnot(identical(tables, build_manuscript_tables(changed, participants, matrices, 488, 100)))
primary_row <- which(agreement$weighting == "Entropy balanced")[1]
expect_error(build_manuscript_tables(rbind(agreement, agreement[primary_row, ]), participants,
                                    matrices, 488, 100))
expect_error(build_manuscript_tables(agreement[-primary_row, ], participants, matrices, 488, 100))
invalid <- row
invalid$upper <- 1.1
expect_error(manuscript_interval(invalid))
invalid <- participants
invalid$vdrace[1] <- 6
expect_error(manuscript_characteristics(invalid))
missing_interval <- row
missing_interval$lower <- missing_interval$upper <- NA_real_
notified <- FALSE
value <- withCallingHandlers(manuscript_interval(missing_interval), warning = function(w) {
  notified <<- TRUE
  invokeRestart("muffleWarning")
})
stopifnot(notified, grepl("CI unavailable", value, fixed = TRUE))
for (spec in tables) {
  document <- xml2::read_html(manuscript_table_html(spec))
  stopifnot(length(xml2::xml_find_all(document, "//caption")) == 1L,
            length(xml2::xml_find_all(document, "//tbody/tr[not(@grouplength)]")) == nrow(spec$data),
            grepl(spec$title, xml2::xml_text(document), fixed = TRUE),
            grepl("Notes:", xml2::xml_text(document), fixed = TRUE))
}
cat("Passed: weighted kappa normalization, package agreement with weights=1, weighted paired changes, entropy-only manuscript tables, missing-data handling, explicit errors, and HTML structure.\n")
