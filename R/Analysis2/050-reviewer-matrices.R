# Participant rows and fixed reviewer columns are the analysis units.
ratings <- readRDS(here::here("R", "RDATA", "Analysis2_030-processed_rs.rds"))
cohort <- readRDS(here::here("R", "RDATA", "Analysis2_045-basil_redcap.rds"))
reviewers <- c("Anna MacKay-Brandt", "Benjamin Chapin", "Cate Price", "Juliana Burt",
               "Kerry Palihnich", "Rebecca Avila-Rieger", "Wingyun Mak")
if (any(!ratings$rsadjname %in% reviewers)) stop("Unrecognized reviewer name.")
if (anyDuplicated(ratings[c("studyid", "rsadjname")])) stop("Duplicate participant-reviewer key.")
if (anyDuplicated(cohort$studyid)) stop("Duplicate cohort participant key.")
ids <- sort(unique(ratings$studyid))
if (length(ids) != params$expected_n || nrow(cohort) != params$expected_cohort_n)
  stop("Participant count differs from the documented design; inspect imports locally.")
participants <- cohort[match(ids, cohort$studyid), , drop = FALSE]
if (anyNA(participants$studyid)) stop("Reliability participant absent from cohort.")
if (any(!is.na(participants$vdmajneurogs) & !participants$vdmajneurogs %in% 0:1))
  stop("Reference-standard dementia indicator must be 0/1.")
participants$dementia <- as.numeric(participants$vdmajneurogs)
make_matrix <- function(variable, categories) {
  x <- matrix(NA_real_, length(ids), length(reviewers), dimnames = list(ids, paste0("Reviewer", 1:7)))
  values <- as.numeric(ratings[[variable]])
  if (any(!is.na(values) & !values %in% categories)) stop("Invalid categories in ", variable)
  x[cbind(match(ratings$studyid, ids), match(ratings$rsadjname, reviewers))] <- values
  if (any(colSums(!is.na(x)) == 0)) stop("A reviewer has no ratings in ", variable)
  if (any(rowSums(!is.na(x)) < 2)) stop("Fewer than two ratings for a participant in ", variable)
  x
}
matrices <- list(
  severity_initial = make_matrix("delirium_severity_1", 0:10),
  severity_consensus = make_matrix("delirium_severity_2", 0:10),
  presence_initial = make_matrix("delirium_presence_1", 0:1),
  presence_consensus = make_matrix("delirium_presence_2", 0:1))
# ebalance constrains weighted totals, so scale cohort means by the weight sum.
# The synthetic target row never enters the ratings matrix.
X <- cbind(severity = as.numeric(cohort$vddelseveritygs),
           site2 = as.numeric(cohort$vdsite == 2), site3 = as.numeric(cohort$vdsite == 3))
if (anyNA(X) || any(!is.finite(X))) stop("Missing/nonfinite balancing covariates; no silent deletion.")
Xs <- X[match(ids, cohort$studyid), , drop = FALSE]
target_totals <- length(ids) * colMeans(X)
fit_w <- ebal::ebalance(Treatment = c(rep(0, length(ids)), 1),
                        X = rbind(Xs, target_totals), norm.constant = length(ids),
                        max.iterations = 1000, constraint.tolerance = 1e-8)
if (!isTRUE(fit_w$converged)) {
  stop("Entropy balancing solver did not converge; maximum constraint error: ",
       fit_w$maxdiff)
}
weights <- as.numeric(fit_w$w)
if (length(weights) != length(ids) || any(!is.finite(weights) | weights <= 0))
  stop("Invalid entropy weights.")
balance <- data.frame(variable = colnames(X), target = colMeans(X),
                      sample = colMeans(Xs),
                      weighted = colSums(Xs * weights) / sum(weights))
if (max(abs(balance$target - balance$weighted)) > 1e-6) stop("Entropy balance did not converge.")
weight_summary <- data.frame(n = length(weights), minimum = min(weights),
                             maximum = max(weights), ESS = sum(weights)^2/sum(weights^2))
audit <- do.call(rbind, lapply(names(matrices), function(key) {
  x <- matrices[[key]]
  data.frame(outcome_stage = key, participants = nrow(x), observed = sum(!is.na(x)),
             missing = sum(is.na(x)), complete_participants = sum(rowSums(!is.na(x)) == 7),
             graphic_comparisons = sum(choose(rowSums(!is.na(x)), 2)))
}))
# Anonymous reviewer columns; no individual identifiers printed in the report.
reviewer_audit <- data.frame(reviewer = colnames(matrices[[1]]),
  sapply(matrices, function(x) colSums(!is.na(x))), check.names = FALSE)
saveRDS(list(matrices = matrices, participants = participants, weights = weights,
             balance = balance), here::here("R", "RDATA", "Analysis2_matrices.rds"))
participant_summary <- data.frame(
  measure = c("Reliability participants", "Reference-standard dementia present",
              "Reference-standard dementia absent", "Dementia status missing"),
  count = c(nrow(participants), sum(participants$dementia == 1, na.rm = TRUE),
            sum(participants$dementia == 0, na.rm = TRUE), sum(is.na(participants$dementia))))
score_distribution <- do.call(rbind, lapply(names(matrices)[startsWith(names(matrices), "severity")], function(key) {
  x <- matrices[[key]]
  data.frame(outcome_stage = key, severity = 0:10,
             ratings = vapply(0:10, function(v) sum(x == v, na.rm = TRUE), numeric(1)),
             denominator = sum(!is.na(x)))
}))
reference_distribution <- as.data.frame(table(participants$vddelseveritygs, useNA = "ifany"))
names(reference_distribution) <- c("reference_standard_severity", "participants")
