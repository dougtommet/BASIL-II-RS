
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

basil_rs_irr <- readxl::read_excel(here::here("SourceData", "FINAL RS IRR Ratings.xlsx"))

basil_rs_irr <- basil_rs_irr %>%
  janitor::clean_names()

basil_rs_irr <- basil_rs_irr %>%
  filter(!is.na(patient_id)) %>%
  filter(adjudicator != "Tamara")

basil_rs_irr <- basil_rs_irr %>%
  separate(patient_id, into = c("studyid", "x"), sep = "#") %>%
  select(-x) %>%
  mutate(studyid = str_trim(studyid))

basil_rs_irr <- basil_rs_irr %>%
  rename(rsadjdate = date) %>%
  rename(rsadjname = adjudicator)

basil_rs_irr <- basil_rs_irr %>%
  mutate(delirium_presence = str_replace(delirium_presence, "-->", "->")) %>%
  separate(delirium_presence, into = c("delirium_presence_1", "delirium_presence_2"), sep = "->") %>%
  mutate(delirium_presence_1 = str_trim(delirium_presence_1),
         delirium_presence_2 = case_when(is.na(delirium_presence_2) ~ str_trim(delirium_presence_1),
                                          TRUE ~ str_trim(delirium_presence_2))
  ) %>%
  mutate(delirium_severity = str_replace(delirium_severity, "-->", "->"),
         delirium_severity = str_replace(delirium_severity, "- >", "->"),
         delirium_severity = str_replace(delirium_severity, "- ->", "->"),
         delirium_severity = str_replace(delirium_severity, " \\s*\\([^\\)]+\\)", "")) %>%
  separate(delirium_severity, into = c("delirium_severity_1", "delirium_severity_2"), sep = "->") %>%
  mutate(delirium_severity_1 = str_trim(delirium_severity_1),
         delirium_severity_1 = as.numeric(delirium_severity_1),
         delirium_severity_2 = case_when(is.na(delirium_severity_2) ~ str_trim(delirium_severity_1),
                                          TRUE ~ str_trim(delirium_severity_2)),
         delirium_severity_2 = as.numeric(delirium_severity_2)
  ) %>%
  mutate(ncd_presence = str_replace(ncd_presence, " neurocognitive disorder present", ""),
         ncd_presence = str_replace(ncd_presence, " neurocognitive disorder", ""),
         ncd_presence = tolower(ncd_presence),
         ncd_presence = str_replace(ncd_presence, " \\s*\\([^\\)]+\\)", ""),
         ncd_presence = str_replace(ncd_presence, "-->", "->")
         ) %>%
  separate(ncd_presence, into = c("ncd_presence_1", "ncd_presence_2"), sep = "->") %>%
  mutate(ncd_presence_1 = str_trim(ncd_presence_1),
         ncd_presence_2 = case_when(is.na(ncd_presence_2) ~ str_trim(ncd_presence_1),
                                     TRUE ~ str_trim(ncd_presence_2))
  ) %>%
  mutate(dementia_severity = str_replace(dementia_severity, "-->", "->"),
         dementia_severity = str_replace(dementia_severity, "- >", "->"),
         dementia_severity = tolower(dementia_severity),
         dementia_severity = str_replace(dementia_severity, " \\s*\\([^\\)]+\\)", "")
         ) %>%
  separate(dementia_severity, into = c("dementia_severity_1", "dementia_severity_2"), sep = "->") %>%
  mutate(dementia_severity_1 = str_trim(dementia_severity_1),
         dementia_severity_2 = case_when(is.na(dementia_severity_2) ~ str_trim(dementia_severity_1),
                                          TRUE ~ str_trim(dementia_severity_2)),
         )

basil_rs_irr <- basil_rs_irr %>%
  mutate(ncd_presence_1 = case_when(ncd_presence_1 == "no" ~ 0,
                                    ncd_presence_1 == "minor" ~ 1,
                                    ncd_presence_1 == "major" ~ 2),
         ncd_presence_2 = case_when(ncd_presence_2 == "no" ~ 0,
                                    ncd_presence_2 == "minor" ~ 1,
                                    ncd_presence_2 == "major" ~ 2),
         dementia_severity_1 = case_when(dementia_severity_1 == "no dementia" ~ 0,
                                         dementia_severity_1 == "very mild" ~ 1,
                                         dementia_severity_1 == "mild" ~ 2,
                                         dementia_severity_1 == "moderate" ~ 3,
                                         dementia_severity_1 == "severe" ~ 4),
         dementia_severity_2 = case_when(dementia_severity_2 == "no dementia" ~ 0,
                                         dementia_severity_2 == "very mild" ~ 1,
                                         dementia_severity_2 == "mild" ~ 2,
                                         dementia_severity_2 == "moderate" ~ 3,
                                         dementia_severity_2 == "severe" ~ 4)
         )

basil_rs_irr <- basil_rs_irr %>%
  labelled::set_variable_labels(delirium_presence_1 = "Delirium Presence (Initial)") %>%
  labelled::set_variable_labels(delirium_presence_2 = "Delirium Presence (Consensus)") %>%

  labelled::set_variable_labels(delirium_severity_1 = "Delirium Severity (Initial)") %>%
  labelled::set_variable_labels(delirium_severity_2 = "Delirium Severity (Consensus)") %>%

  labelled::set_variable_labels(ncd_presence_1 = "NCD Presence (Initial)") %>%
  labelled::set_value_labels(ncd_presence_1 = c("No NCD" = 0, "Minor NCD" = 1, "Major NCD" = 2)) %>%
  labelled::set_variable_labels(ncd_presence_2 = "NCD Presence (Consensus)") %>%
  labelled::set_value_labels(ncd_presence_2 = c("No NCD" = 0, "Minor NCD" = 1, "Major NCD" = 2)) %>%

  labelled::set_variable_labels(dementia_severity_1 = "Dementia Severity (Initial)") %>%
  labelled::set_value_labels(dementia_severity_1 = c("No dementia" = 0, "Very mild" = 1, "Mild" = 2, "Moderate" = 3, "Severe" = 4)) %>%
  labelled::set_variable_labels(dementia_severity_2 = "Dementia Severity (Consensus)") %>%
  labelled::set_value_labels(dementia_severity_2 = c("No dementia" = 0, "Very mild" = 1, "Mild" = 2, "Moderate" = 3, "Severe" = 4))

# basil_rs_irr %>%
#   select(ends_with("_1"), ends_with("_2")) %>%
#   labelled::to_factor() %>%
#   gtsummary::tbl_summary()


# ../DATA_MANAGEMENT/BASIL/CODE/RS_Paper/SourceData/n46_of_488.dta
#
#     has 2 variables: studyid and n46
#     488 rows for BASIL participants
#     n46 is 0 or 1, 1 means included in RS adjudication study
#

n46 <- basil_rs_irr %>%
  select(studyid) %>%
  distinct()



saveRDS(n46, here::here("RData", "030-n46.rds"))
saveRDS(basil_rs_irr, here::here("RData", "030-processed_rs.rds"))
