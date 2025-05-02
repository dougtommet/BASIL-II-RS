# ../DATA_MANAGEMENT/BASIL/CODE/RS_Paper/SourceData/n46_of_488.dta
#
#     has 2 variables: studyid and n46
#     488 rows for BASIL participants
#     n46 is 0 or 1, 1 means included in RS adjudication study
#
n46 <- haven::read_dta(here::here("SourceData", "n46_of_488.dta"))

#../DATA_MANAGEMENT/BASIL/CODE/RS_Paper/SourceData/PROCESSED_RS_IRR_Ratings.dta
#
#     has 320 rows
#     studyid and rsadjname uniquely identify the rows
#     studyid has 46 distinct values
#     key variables include:
#        studyid rsadjname rsadjdate
#        deliriumpresence_1n deliriumpresence_2n
#        deliriumseverity_1n deliriumseverity_2n
#        ncdpresence_1n ncdpresence_2n
#        dementiaseverity_1n dementiaseverity_2n
#     variables have variable and value labels (no value labels on deliriumseverity_xn)
#     _1n means initial rating
#     _2n means rating after adjudication process (usually the same as _1n)

processed_rs <- haven::read_dta(here::here("SourceData", "PROCESSED_RS_IRR_Ratings.dta"))

saveRDS(n46, here::here("RData", "030-n46.rds"))
saveRDS(processed_rs, here::here("RData", "030-processed_rs.rds"))
