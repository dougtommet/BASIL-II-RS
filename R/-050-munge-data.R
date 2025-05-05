# 1. Make a data set of all possible pairs of patient data
#    in RS adjudication data.
#    Since there are 46 patients, 7 clinicians, but one clinician only saw 44
#    patients, there should be 44 * 21 + 2 * 15 = 924 + 30 = 954 pairs
#      where 21 is 44 patients seen by 7 doctors -> 21 pairs per patient
#            15 is  2 patients seen by 6 doctors -> 15 pairs per patient
#
# 2. Model P(n46=1) given Table 1 variables in N488 sample
#
# 3. Generate IPTW given P(n46=1) and observed n46=1
#    Scale to sum to 46
#
# 4. Generate IPTW for use in all pairs data set, dividing weight by
#    number of times studyid appears in all pairs data set
#    scale to sum to 46 in all pairs data set
#


processed_rs <- readRDS(here::here("RData", "030-processed_rs.rds"))
# Renaming variables and transforming to wide format to match the data structure from GS analysis
processed_rs <- processed_rs %>%
  mutate(rater = case_when(rsadjname=="Anna MacKay-Brandt" ~ 1,
                           rsadjname=="Benjamin Chapin" ~ 2,
                           rsadjname=="Cate Price" ~ 3,
                           rsadjname=="Juliana Burt" ~ 4,
                           rsadjname=="Kerry Palihnich" ~ 5,
                           rsadjname=="Rebecca Avila-Rieger" ~ 6,
                           rsadjname=="Wingyun Mak" ~ 7)) %>%
  select(studyid, rater,
         delirium_presence_1, delirium_presence_2,
         delirium_severity_1, delirium_severity_2,
         ncd_presence_1, ncd_presence_2,
         dementia_severity_1, dementia_severity_2) %>%
  rename(delirium_presence_initial = delirium_presence_1) %>%
  rename(delirium_presence_consensus = delirium_presence_2) %>%
  rename(delirium_severity_initial = delirium_severity_1) %>%
  rename(delirium_severity_consensus = delirium_severity_2) %>%
  rename(ncd_presence_initial = ncd_presence_1) %>%
  rename(ncd_presence_consensus = ncd_presence_2) %>%
  rename(dementia_severity_initial = dementia_severity_1) %>%
  rename(dementia_severity_consensus = dementia_severity_2)

processed_rs_wide <- processed_rs %>%
  arrange(studyid, rater) %>%
  pivot_wider(id_cols = studyid, names_from = rater, values_from = c(delirium_presence_initial, delirium_presence_consensus,
                                                              delirium_severity_initial, delirium_severity_consensus,
                                                              ncd_presence_initial, ncd_presence_consensus,
                                                              dementia_severity_initial, dementia_severity_consensus))

create_all_possible_pairs <- function(df, time) {
  # time = "initial" or "consensus"

  # this is the indicators for the raters
  rater_df <- tibble(rA = 1:7) %>%
    mutate(rB = rA)
  # create the possible pairs
  rater_pairs_df <- tidyr::expand(rater_df, rA, rB) %>%
    filter(rA < rB)
  # the number of possible pairs
  n_rater_pairs <- dim(rater_pairs_df)[1]
  # these are the instruments/domains to go over
  instrument_list <- c("delirium_presence", "delirium_severity", "ncd_presence", "dementia_severity")

  # empty object to hold the resulting data frame
  goo <- NULL
  # for each of the possible pairs
  for (i in 1:n_rater_pairs) {
    # get the number indicator for 'rater A'
    rater_a <- rater_pairs_df %>%
      slice(i) %>%
      pull(rA)
    # get the number indicator for 'rater B'
    rater_b <- rater_pairs_df %>%
      slice(i) %>%
      pull(rB)
    # create a list of the variables to keep
    # for example: if rater A is rater 3, the variables to keep are: "delirium_presence_1_3"  "delirium_severity_1_3", "ncd_presence_1_3", "dementia_severity_1_3", "delirium_presence_2_3", "delirium_severity_2_3", "ncd_presence_2_3", "dementia_severity_2_3"
    if (time == "initial") {
      instrument_list_a <- str_c(instrument_list, "_initial_", rater_a)
      instrument_list_b <- str_c(instrument_list, "_initial_", rater_b)
    }
    if (time == "consensus") {
      instrument_list_a <- str_c(instrument_list, "_consensus_", rater_a)
      instrument_list_b <- str_c(instrument_list, "_consensus_", rater_b)
    }

    foo <- df %>%
      mutate(pair = i,
             raterA = rater_a,
             raterB = rater_b) %>%
      select(studyid, pair,  raterA, raterB, all_of(instrument_list_a), all_of(instrument_list_b)) %>%
      # rename the variables so they line up when we append the data frame
      rename_with(~ gsub(rater_a, "A", .x)) %>%
      rename_with(~ gsub(rater_b, "B", .x))

    if (time == "initial") {
      foo <- foo %>%
        rename_with(~ gsub("_initial", "", .x))
    }
    if (time == "consensus") {
      foo <- foo %>%
        rename_with(~ gsub("_consensus", "", .x))
    }

    goo <- bind_rows(goo, foo)

  }

  goo <- goo %>%
    select(studyid,
           pair, raterA, raterB,
           delirium_presence_A, delirium_presence_B,
           delirium_severity_A, delirium_severity_B,
           ncd_presence_A, ncd_presence_B,
           dementia_severity_A, dementia_severity_B)
  goo
}

all_pairs_df_initial <- create_all_possible_pairs(processed_rs_wide, "initial")
all_pairs_df_consensus <- create_all_possible_pairs(processed_rs_wide, "consensus")




saveRDS(all_pairs_df_initial, here::here("RData", "050-all_pairs_df_initial.rds"))
saveRDS(all_pairs_df_consensus, here::here("RData", "050-all_pairs_df_consensus.rds"))

