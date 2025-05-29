
n488 <- readRDS(here::here("RData", "040-n488.rds"))
basil_redcap <- readRDS(here::here("RData", "040-basil_redcap.rds"))

basil_redcap <- basil_redcap %>%
  mutate(vddelseveritygs = dels_6_consensus,
         vddemseveritygs = dems_6_consensus,
  )

basil_df <- basil_redcap %>%
  filter(studyid %in% n488[["studyid"]]) %>%
  select(studyid, vdsite,  vdage, vdfemale, vdnonwhite, vdhisp, vdesl, vdeduc,
         vdlivesalone, vdmarried, vdlivesinnh, vdvisionimp, vdhearingimp,
         vdcharlson, vdmajneurogs, vdminneurogs, vddeliriumgs, vddelseveritygs, vddemseveritygs,
         vdcamsrs, phq_9_score, moca_score, ad8_total_score) %>%
  group_by(studyid) %>%
  fill(vdsite, vdage, vdfemale, vdnonwhite, vdhisp, vdesl, vdeduc,
       vdlivesalone, vdmarried, vdlivesinnh, vdhearingimp, vdvisionimp,
       vdcharlson, vdmajneurogs, vdminneurogs, vddeliriumgs, vddelseveritygs, vddemseveritygs,
       vdcamsrs, phq_9_score, moca_score, ad8_total_score,
       .direction = "downup") %>%
  slice(1) %>%
  ungroup()

labelled::var_label(basil_df$vdage) <- "Age"
labelled::var_label(basil_df$vdeduc) <- "Education"
labelled::var_label(basil_df$vdlivesalone) <- "Lives alone"
labelled::var_label(basil_df$vdlivesinnh) <- "Lives in NH"
labelled::var_label(basil_df$vdmarried) <- "Married"
labelled::var_label(basil_df$vdcharlson) <- "Charlson Comorbidity Index"

labelled::var_label(basil_df$vdfemale) <- "Female"
labelled::var_label(basil_df$vdnonwhite) <- "Non-white"
labelled::var_label(basil_df$vdesl) <- "English is second language"
labelled::var_label(basil_df$vdhearingimp) <- "Hearing impairment"
labelled::var_label(basil_df$vdvisionimp) <- "Vision impairment"
labelled::var_label(basil_df$vdmajneurogs) <- "Major neurocognitive disorder (GS)"
labelled::var_label(basil_df$vdminneurogs) <- "Minor neurocognitive disorder (GS)"
labelled::var_label(basil_df$vddeliriumgs) <- "Delirium diagnosis (GS)"
labelled::var_label(basil_df$vddelseveritygs) <- "Delirium severity (GS)"
labelled::var_label(basil_df$vddemseveritygs) <- "Dementia severity (GS)"

labelled::var_label(basil_df$phq_9_score) <- "PHQ-9 score"
labelled::var_label(basil_df$moca_score) <- "MOCA score"
labelled::var_label(basil_df$ad8_total_score) <- "AD8 total score"

saveRDS(basil_df, here::here("RData", "045-basil_redcap.rds"))

