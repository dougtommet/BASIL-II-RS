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