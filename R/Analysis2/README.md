# Analysis2

Copy this entire folder to `R/Analysis2/` in the BASIL-II-RS project. Retain the project's `.here`, `TEMPLATES/letter.css`, and `TEMPLATES/letter_css_scripts.html`.

Run locally from the project in R:

```r
source(here::here("R", "Analysis2", "Analysis2_Driver.R"))
```

The driver renders `Analysis2_Control.qmd` to HTML in place, stages `RENDER/Analysis2_agreement.html`, and copies a dated self-contained report to `REPORTS/`. It uses no `--output-dir` flag. The control file owns the input paths, bootstrap settings, and section order. Its default BASIL derived-data folder matches Rich's relative local path used by Analysis1; change that parameter if the local folder differs.

Install the packages listed in `000-Libraries.R` and the Quarto CLI locally before running. No script installs packages, accesses a remote service, or uploads data. The report uses the supplied CSS and its required after-body script, with every report section inside a `.page` block.

Each table has a separate `.page` block with a nested `.small` block and 9-point type. Tables are numbered sequentially and have descriptive titles and NOTES defining every displayed column. The primary and weighted agreement tables are split by outcome and rating stage to fit portrait pages; constant outcome, stage, and weighting information appears in their titles rather than repeated columns. The corresponding markdown exports retain every result, with the same numbered titles and notes. The table helper stops if column definitions do not match the displayed columns. Report-local cell wrapping and padding keep tables within the page width. Existing narrative page blocks contain fewer than 650 words each.

The workbook import and participant harmonization are adapted from Analysis1. They read the original workbook and parent BASIL derived files locally, then build isolated `Analysis2_` interim files in `R/RDATA/`. The workbook remains at the legacy `SourceData/` location; all source inputs are read only. `DATA/SOURCE/`, `DATA/DERIVED/`, and Analysis1 outputs are untouched.

Primary estimates use unweighted Conger's generalized kappa with quadratic category weights for severity and identity weights for presence. Participant bootstrap intervals condition on the fixed reviewer panel. The full-cohort entropy-weighted analysis is a sensitivity extension implemented from reviewer matrices, because irrCAC's `weights` argument is for category weights. Bootstrap sensitivity intervals hold participant weights fixed. The balancing target explicitly includes the entire enrolled cohort; this differs from Analysis1's non-reliability-participant target.

Entropy balancing supplies cohort means multiplied by the reliability sample size as target totals, because `ebalance()` constrains weighted sums. Weights sum to the reliability sample size; solver convergence and achieved weighted means are checked before the agreement analysis.

All-pairs objects are created only in `070-graphics.R` and are used only for descriptive plots. Descriptive agreement statistics are computed within participant using category counts. Tables and figures carry an Analysis2 prefix. Undefined bootstrap estimates are counted and interval suppression is explicit.

`manuscript-redlines.qmd` contains exact manuscript passages with whitespace normalized from the authoritative page JSONL. Old text is struck out, revised text follows, and new numerical results are inserted only when executed locally. PDF page numbers include the opening reviewer-response pages; manuscript text begins on PDF page 7. No literature citations were added to the empty project bibliography. Internal resources and implementation documentation are cited inline.

Validation performed during preparation: R source and extracted QMD chunks were parsed without evaluation; QMD source structure, redline provenance, relative paths, and output names were checked. No participant data were read or analyzed and no HTML report was rendered during preparation. The driver must be run locally to verify data-dependent calculations, package compatibility, and final HTML layout. No new agreement results are claimed before that run.

Local execution on 2026-10-08: `Rscript R/Analysis2/Analysis2_Driver.R` completed after correcting the entropy target scaling. The achieved weighted means matched all 3 cohort targets within 1e-6, and the weights summed to 46. All 72 agreement rows had finite estimates and intervals, with 2000 valid bootstrap replicates each. The staged and dated HTML files were identical. Final visual layout and scientific interpretation still require review.
