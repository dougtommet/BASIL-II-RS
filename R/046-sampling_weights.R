

basil_df <- readRDS(here::here("RData", "045-basil_redcap.rds"))
n46 <- readRDS(here::here("RData", "030-n46.rds"))

basil_df <- basil_df %>%
  mutate(vd_clinical_assessor = studyid %in% (n46[["studyid"]]),
         vdsite2 = vdsite==2,
         vdsite3 = vdsite==3
         )
labelled::var_label(basil_df$vd_clinical_assessor) <- "In the clinical adjudication sample"



## Entropy balancing
# Vector of in/out of sample
Treatment <- basil_df %>%
  mutate(t = case_when(vd_clinical_assessor==TRUE ~ 0,
                       vd_clinical_assessor==FALSE ~ 1)) %>%
  pull(t)
# Covariate matrix
X <- basil_df %>%
  select(vddelseveritygs, vdsite2, vdsite3) %>%
  as.matrix()
# Calculate the weights
eb_out <- ebal::ebalance(Treatment = Treatment, X = X)
# The weights
w_eb <- eb_out$w

eb_weights <- basil_df %>%
  filter(vd_clinical_assessor==1) %>%
  mutate(w_eb = w_eb) %>%
  select(studyid, w_eb)


## Logisitic regression
lr <- glm(vd_clinical_assessor ~ vdsite2 + vdsite3 + vddelseveritygs, data = basil_df,
    family = "binomial"
  )
# Get the predicted probabilities and take the inverse
w_lr<- broom::augment(lr, type.predict = "response") %>%
  mutate(
    # w_lr = case_when(vd_clinical_assessor==TRUE ~ 1/.fitted,
    #                  vd_clinical_assessor==FALSE ~ 1/(1-.fitted)),
    w_lr = case_when(vd_clinical_assessor==TRUE ~ 1/.fitted,
                     vd_clinical_assessor==FALSE ~ 0),
    w_lr = w_lr * 488/sum(w_lr)
         ) %>%
  pull(w_lr)

lr_weights <- basil_df %>%
  mutate(w_lr = w_lr) %>%
  select(studyid, w_lr)


basil_df <- basil_df %>%
  left_join(eb_weights, by = c("studyid"="studyid")) %>%
  left_join(lr_weights, by = c("studyid"="studyid")) %>%
  mutate(w_eb = case_when(is.na(w_eb) ~ 0,
                          !is.na(w_eb) ~ w_eb))

saveRDS(basil_df, here::here("RData", "046-basil_df.rds"))
