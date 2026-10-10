# BASIL-II-RS

This repository contains the BASIL-II reference-standard analysis and its
reports. It was reorganized using the AgentKit project framework. The framework
provides conventions for analysis code, data handling, Quarto rendering, and
project documentation; the existing Analysis1 workflow remains a legacy,
multi-report workflow rather than a single AgentKit driver/control pair.

## Start here

- Read `AGENTS.md` for project-wide coding and data-handling rules.
- Read `.github/copilot-instructions.md` for the academic writing style used
  in project documents.
- Read `RULES_AND_LOGS/R_Rules.md` before changing R or Quarto files.
- `CLAUDE.md` points Cowork and other agents to the project instructions.

The instructions and templates were copied into this repository from
`_AgentKit`; they are project copies and do not update when the shared framework
changes.

## Project layout

| Path | Purpose |
| --- | --- |
| `R/Analysis1/` | Analysis1 R scripts, Quarto reports and presentations, and their content files. |
| `R/RDATA/` | Regenerable intermediate `.rds` files produced by the R workflow. |
| `Stata/Analysis1/` | Analysis1 Stata materials. |
| `SourceData/` | Original project data files and supporting materials. |
| `DATA/SOURCE/` | AgentKit location for source data in new or migrated workflows. |
| `DATA/DERIVED/` | Reusable derived data; `DATA/DERIVED/README.md` is its manifest. |
| `FIGURES/`, `MD/`, `EXCALIDRAW/` | Figures, report-ready tables or text, and diagrams. |
| `REFERENCES/` | Reference documents; extracted text is stored under `REFERENCES/LLM_OUT/`. |
| `TEMPLATES/` | Quarto/Pandoc reference documents. |
| `RENDER/` | Rendered output used as a staging area. |
| `REPORTS/` | Dated report and presentation copies. |
| `ADMIN/` | Administrative and regulatory records. |
| `RULES_AND_LOGS/` | Project rules, session logs, and analytic decisions. |

Paths in R should be built with `here::here()`. The root-level `.here` file is
the marker that lets `here` find the project root; keep it in place.

## Analysis1 workflow

`R/Analysis1/000-control.R` is the legacy workflow entry point. From the
project root, run it in R with:

```r
source(here::here("R", "Analysis1", "000-control.R"))
```

It renders `_000-master.qmd` and the dated presentation QMDs in sequence,
including both HTML and DOCX versions of the May 30 presentation. The
`setup-routines` chunk in `_000-master.qmd` is enabled and rebuilds the data
intermediates before rendering the report. The content files included by these
Quarto documents are siblings in `R/Analysis1/`.

The data preparation sequence is:

1. `030-pull-rs-data.R` reads `SourceData/FINAL RS IRR Ratings.xlsx` and creates
   the reference-standard rating and sample intermediates.
2. `040-pull-other-data.R` reads `BASILIIMainStudy_Derived.dta` and `n488.dta`
   from the BASIL derived-data directory.
3. `045-munge-other-data.R` prepares the BASIL participant data.
4. `046-sampling_weights.R` creates the weighted analysis data.
5. `050-munge-data.R` creates the paired-rater analysis datasets used by the
   tables and figures.

The regenerable intermediates are written to `R/RDATA/`. The external BASIL
derived-data location is resolved in `R/Analysis1/020-folder-file-locations.R`:
the network location is preferred, with user-specific local fallbacks. Rich's
local fallback is relative to the `.here` project root. The source files are
read-only inputs and are not copied into this repository by the workflow.

Rendered files are staged in `RENDER/` and copied to `REPORTS/` with the render
date in their names. `RENDER/` is scratch output; use `REPORTS/` for dated
deliverables.

## Analysis2 one-off Word report

The canonical [Analysis2 driver](R/Analysis2/Analysis2_Driver.R) still renders
HTML. To render the one-off Word version, run:

```r
source(here::here("R", "Analysis2", "Analysis2_DOCX_Driver.R"))
```

The [DOCX control](R/Analysis2/Analysis2_DOCX_Control.qmd) is a one-off version
of the HTML control, using `TEMPLATES/reference_report.docx` and native
`flextable` tables. It includes
[manuscript-tables-docx.qmd](R/Analysis2/manuscript-tables-docx.qmd) for Word
tables and shares the unchanged redlines child with HTML. The DOCX sources do
not automatically track later edits to their HTML counterparts. The driver reruns the
analysis (including 2000 bootstrap replicates) and rebuilds the same interim
files, figures, and table exports. It stages `Analysis2_agreement_oneoff.docx`
in `RENDER/` and archives `Analysis2_agreement_oneoff_YYYY-MM-DD.docx` in
`REPORTS/`, leaving HTML reports untouched.

Install `flextable` locally in addition to the canonical analysis packages.
The driver reuses Analysis1's `002-Word-safe-docx.R` helper. LibreOffice is
optional; when available it re-saves the archived document for Word, otherwise
the helper reports that the DOCX is unconverted. Tables use 9-point Arial,
repeat column headers when they span pages, and retain captions, group labels,
and notes. CSS-based HTML page breaks do not apply in Word. The DOCX workflow
writes Markdown table exports; standalone HTML table exports still come from
the HTML workflow.

The 2026-10-10 trial completed, including both child QMDs, and LibreOffice
re-saved the archived DOCX. Archive/XML checks found all 4 plot drawings and
the main report sections, but 0 native Word tables in either the Quarto build
or the archived document. This prompted the separate flextable renderers in
the DOCX control and manuscript-table child, leaving the HTML sources intact.

The flextable version was rendered end to end and checked with
`Rscript R/Analysis2/tests/test-docx-tables.R`. The check compares all 31
native Word tables (28 technical and 3 manuscript tables) with current
Markdown exports, including captions, group labels, values, and notes, and
checks that all 4 figures remain present. It also checks that the DOCX and
HTML manuscript-table calculation functions are identical. Pagination and
appearance still require review in Word.

## Adding or changing analyses

For a new AgentKit-style Quarto analysis, create a sibling folder under `R/`
with its own `<analysis>_Driver.R`, `<analysis>_Control.qmd`, content files,
and starter scripts. Drivers and controls should both identify the analysis;
the control file owns the YAML, report structure, and sibling includes, while
the driver handles rendering and archiving. Follow `AGENTS.md` and
`RULES_AND_LOGS/R_Rules.md` for path, data, output, and naming conventions.

## References and citations

Put source documents in `REFERENCES/` and extracted text in
`REFERENCES/LLM_OUT/`. `AGENTS.md` describes how agents should ground
literature-based answers in those extracted artifacts. Store project citations
in `bibliography.bib`.
