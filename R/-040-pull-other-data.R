# ../DATA_MANAGEMENT/BASIL/DATA/DERIVED/BASILIIMainStudy_Derived.dta
# ../DATA_MANAGEMENT/BASIL/DATA/DERIVED/n488.dta
#
# BASILIIMainStudy_Derived.dta
# - keep if studyid is in n488.dta
# - keep if redcap_repeat_instance is 1
# - should have 488 rows
# - key variables for analysis:
#    vdcamsrs             CAM-S (RS)
#    vdage                Age
#    vdfemale             Female Sex
#    vdrace               Racial Group
#    vdhisp               Hispanic ethnicity
#    vdeduc               Years of education
#    vdcharlson           Charlson Comorbidity Index
#    vdmajneurogs         Major neurocognitive disorder (GS)
#    vdminneurogs         Minor neurocognitive disorder (GS)
#    vddeliriumgs         Delirium (GS)
#    vdsite               Site
#    vdesl                English is second language
#    vdhearingimp         Hearing impairment
#    vdvisionimp          Vision impairment
#    phq_9_score        * Depressive symptoms (PHQ) rs_patient_depression_questionnaire_phq9
#    moca_score         * Cognitive perfirmance (MOCA) rs_montreal_cognitive_assessment_moca
#    ad8_total_score    * AD-8 rs_ad8 (also RS SEVERE IMPAIRMENT BATTERY [SIB8]
#                         rs_severe_impairment_battery_sib8)
#    (not yet defined)    ADL dependence rs_cg_adl_and_dev
#    (not yet defined)    IADL dependence rs_cg_iadl
#
#    * - these are sums in REDCap and should be replaced with
#        VDS variables, eventually, maybe.

basil_redcap <- haven::read_dta(fs::path(basil_derived_folder, "BASILIIMainStudy_Derived.dta"))
n488 <- haven::read_dta(fs::path(basil_derived_folder, "n488.dta"))


saveRDS(n488, here::here("RData", "040-n488.rds"))
saveRDS(basil_redcap, here::here("RData", "040-basil_redcap.rds"))



