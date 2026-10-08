## 2026-10-08

- Analysis1 now has an enabled setup-routines chunk. Rich's local BASIL derived-data path is resolved relative to the project root, with the network and Doug-specific fallbacks retained.
- Fixed the `n488` data-mask conflict and updated Table 1 to use `vdrace`, which is present in the source data, instead of the absent `vdblack`.
- The legacy workflow rendered all 7 reports successfully. It rebuilt intermediate files in `R/RDATA/` from the Excel source workbook and BASIL derived-data files; source data were read only.
- Committed and pushed the AgentKit migration and README as `c494d2c`. Manuscript drafts and generated outputs were excluded from the commit. Render-updated figures, dated reports, render staging files, and manuscript drafts remain uncommitted.
- Next: review the remaining figure changes, reports, and manuscript drafts and decide which, if any, belong in a separate commit.
