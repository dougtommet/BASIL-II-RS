## 2026-10-08

- Analysis1 now has an enabled setup-routines chunk. Rich's local BASIL derived-data path is resolved relative to the project root, with the network and Doug-specific fallbacks retained.
- Fixed the `n488` data-mask conflict and updated Table 1 to use `vdrace`, which is present in the source data, instead of the absent `vdblack`.
- The legacy workflow rendered all 7 reports successfully. It rebuilt intermediate files in `R/RDATA/` from the Excel source workbook and BASIL derived-data files; source data were read only.
- Committed and pushed the AgentKit migration and README as `c494d2c`. Manuscript drafts and generated outputs were excluded from the commit. Render-updated figures, dated reports, render staging files, and manuscript drafts remain uncommitted.
- Next: review the remaining figure changes, reports, and manuscript drafts and decide which, if any, belong in a separate commit.

### Analysis2 agreement analysis and report layout

- Corrected entropy-balancing targets: `ebalance()` constrains weighted totals, so cohort means must be multiplied by the reliability sample size (46). The prior code supplied means as totals and produced weighted means divided by 46. Added a solver-convergence check alongside the achieved-mean check.
- The Analysis2 driver completed locally. All 3 weighted covariate means matched the full-cohort targets within 1e-6; weights summed to 46, with effective sample size 30.20789. All 72 agreement-result rows had finite estimates and intervals, with 2000 valid participant-bootstrap replicates each.
- Each table now occupies a separate page with 9-point type. The 2 long agreement tables were split by outcome and rating stage after smaller type alone failed to fit a portrait page. All values were retained.
- The 17 displayed tables have sequential numbers, descriptive titles, and NOTES defining every displayed column. Constant outcome, stage, and weighting columns were moved into agreement-table titles. Markdown exports carry the same numbered titles and notes.
- Browser screen and print-style checks confirmed that tables and notes fit the page dimensions. Narrative page blocks were already below 650 words. The staged and dated HTML copies were identical.
- Approved committing all Analysis2 source files, including manuscript redlines, to the public repository. Generated reports, tables, figures, interim data, other manuscript drafts, and reference resources remain excluded.
- Next: review the scientific interpretation and manuscript redlines. Reference resources cited by Analysis2 remain local and are not included in this commit; other users need those resources for provenance review and local source data to rerun the driver.
