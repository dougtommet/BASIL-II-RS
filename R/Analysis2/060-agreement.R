# Matrix estimator matches irrCAC's Conger point estimator when weights=1.
# Case weights affect participant means and each reviewer's category margins.
# Category agreement weights and case sampling weights are separate quantities.
category_weights <- function(categories, quadratic) {
  if (quadratic) 1 - outer(categories, categories, "-")^2 / 100 else diag(length(categories))
}
row_agreement <- function(x, categories, W) {
  counts <- vapply(categories, function(k) rowSums(x == k, na.rm = TRUE), numeric(nrow(x)))
  m <- rowSums(counts)
  numerator <- rowSums((counts %*% W) * counts) - m
  ifelse(m >= 2, numerator / (m * (m - 1)), NA_real_)
}
conger_point <- function(x, categories, W, w = rep(1, nrow(x))) {
  keep <- rowSums(!is.na(x)) >= 2 & is.finite(w) & w > 0
  x <- x[keep, , drop = FALSE]; w <- w[keep]
  r <- ncol(x)
  if (nrow(x) < 2 || any(colSums(!is.na(x)) == 0)) return(NA_real_)
  p <- vapply(categories, function(k) colSums((!is.na(x) & x == k) * w, na.rm = TRUE), numeric(r))
  p <- p / colSums(!is.na(x) * w)
  # Average cross-reviewer products; exclude each reviewer's self product.
  margins <- (outer(colSums(p), colSums(p)) - crossprod(p)) / (r * (r - 1))
  pe <- sum(W * margins)
  pa <- weighted.mean(row_agreement(x, categories, W), w)
  if (!is.finite(pe) || abs(1 - pe) < 1e-12) return(NA_real_)
  (pa - pe) / (1 - pe)
}
row_descriptives <- function(x, categories) {
  exact <- row_agreement(x, categories, diag(length(categories)))
  # Compute discrepancies inside each participant row; no pooled pair dataset.
  threshold <- outer(categories, categories, function(a, b) as.numeric(abs(a - b) <= 2))
  within2 <- row_agreement(x, categories, threshold)
  counts <- vapply(categories, function(k) rowSums(x == k, na.rm = TRUE), numeric(nrow(x)))
  m <- rowSums(counts)
  absW <- abs(outer(categories, categories, "-"))
  mad <- rowSums((counts %*% absW) * counts) / (m * (m - 1))
  data.frame(exact = exact, within2 = within2, MAD = mad)
}
ci_summary <- function(point, draws, B) {
  good <- is.finite(draws)
  valid <- sum(good)
  bounds <- if (is.finite(point) && valid >= ceiling(.95 * B))
    unname(quantile(draws[good], c(.025, .975), type = 7)) else c(NA_real_, NA_real_)
  data.frame(estimate = point, lower = bounds[1], upper = bounds[2],
             valid_bootstrap = valid, attempted = B)
}
analyze_matrix <- function(x, categories, quadratic, w, mode, B) {
  W <- category_weights(categories, quadratic)
  point <- conger_point(x, categories, W, w)
  if (mode == "Unweighted" && is.finite(point)) {
    package_fit <- irrCAC::conger.kappa.raw(x, weights = W, categ.labels = categories, N = Inf)
    if (abs(package_fit$est$coeff.val - point) > 1e-5)
      stop("Matrix implementation disagrees with installed irrCAC; inspect package version.")
    point <- as.numeric(package_fit$est$coeff.val)
  }
  d <- row_descriptives(x, categories)
  desc <- vapply(d, weighted.mean, numeric(1), w = w)
  # Resample whole participant rows, preserving all 7 fixed reviewer columns.
  # Case weights travel with their sampled participant and are not re-estimated.
  draws <- matrix(NA_real_, B, 4, dimnames = list(NULL, c("Kappa", "exact", "within2", "MAD")))
  for (b in seq_len(B)) {
    idx <- sample.int(nrow(x), nrow(x), replace = TRUE)
    draws[b, 1] <- conger_point(x[idx, , drop = FALSE], categories, W, w[idx])
    draws[b, 2:4] <- vapply(d[idx, , drop = FALSE], weighted.mean, numeric(1), w = w[idx])
  }
  values <- c(Kappa = point, desc)
  rows <- do.call(rbind, lapply(names(values), function(metric) {
    cbind(metric = metric, ci_summary(values[[metric]], draws[, metric], B))
  }))
  if (!quadratic) rows <- rows[rows$metric %in% c("Kappa", "exact"), ]
  rows
}
B <- as.integer(params$bootstrap_replicates)
if (is.na(B) || B < 1000) stop("Use at least 1000 bootstrap replicates.")
results <- list(); complete_case <- list(); k <- 0L
for (key in names(matrices)) {
  x <- matrices[[key]]
  quadratic <- startsWith(key, "severity")
  categories <- if (quadratic) 0:10 else 0:1
  for (group in c("Overall", "No dementia", "Dementia")) {
    use <- if (group == "Overall") rep(TRUE, nrow(x)) else
      !is.na(participants$dementia) & participants$dementia == as.integer(group == "Dementia")
    if (sum(use) < 2) stop("Insufficient participants in ", group)
    xx <- x[use, , drop = FALSE]
    cc <- xx[rowSums(!is.na(xx)) == 7, , drop = FALSE]
    complete_case[[length(complete_case) + 1L]] <- data.frame(
      outcome_stage = key, group = group, n = nrow(cc),
      kappa = conger_point(cc, categories, category_weights(categories, quadratic)))
    for (mode in c("Unweighted", "Entropy weighted sensitivity")) {
      k <- k + 1L
      w <- if (mode == "Unweighted") rep(1, sum(use)) else weights[use]
      ans <- analyze_matrix(xx, categories, quadratic, w, mode, B)
      results[[k]] <- cbind(outcome_stage = key, group = group, weighting = mode,
                            participants = sum(use), ans)
    }
  }
}
agreement <- do.call(rbind, results)
complete_case <- do.call(rbind, complete_case)
# Same row sample for both stages: paired change in overall unweighted kappa.
changes <- do.call(rbind, lapply(c("severity", "presence"), function(outcome) {
  cats <- if (outcome == "severity") 0:10 else 0:1
  W <- category_weights(cats, outcome == "severity")
  a <- matrices[[paste0(outcome, "_initial")]]
  z <- matrices[[paste0(outcome, "_consensus")]]
  delta <- conger_point(z, cats, W) - conger_point(a, cats, W)
  draws <- replicate(B, {
    ix <- sample.int(nrow(a), nrow(a), replace = TRUE)
    conger_point(z[ix, , drop = FALSE], cats, W) - conger_point(a[ix, , drop = FALSE], cats, W)
  })
  cbind(outcome = outcome, ci_summary(delta, draws, B))
}))
saveRDS(list(agreement = agreement, complete_case = complete_case, changes = changes,
             audit = audit, balance = balance, weight_summary = weight_summary,
             session = sessionInfo()), here::here("R", "RDATA", "Analysis2_results.rds"))
