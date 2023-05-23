# Data cleaning steps identified

#RAAB7s exported from Peek platform - see email from VH 09 Feb 2022 for more information on Peek investigation

raabs_612 <- read.csv(here('outputs', 'raabs_612.csv'))

# Exam status in 2019_Nepal_Karnali
# This was a RAAB7 database/ syncing error investigated by VH. 10 encounters did not have an exam status recorded, 2 were unavailable, among the other 8 there are other missing data points so droppoing them
# RAAB Trainer closed the survey before edits could be made in Admin

# two observations with history if not examined responses
raabs_612 <- raabs_612 %>% mutate(
  exam_status = case_when(
    participantId=="7033-23" ~ "exam_status_unavailable",
    participantId=="7033-02" ~ "exam_status_unavailable",
    TRUE ~ exam_status
  )
)

# eight observations with incomplete examination data - this is reducing the sample size, not response rate
karnali_id_exclude <- c("7043-23", 
                        "7045-02", 
                        "7044-01", 
                        "7042-10", 
                        "7042-01",
                        "7033-07",
                        "7033-05",
                        "7033-01")

raabs_612 <- raabs_612 %>% filter(!participantId %in% karnali_id_exclude)

# Missing VA data in early RAAB7s

# 2018_Palestine
pal_review <- raabs_612 %>% filter(
  raab_id=="2018_Palestine" & exam_status=="exam_status_examined" & (is.na(right_distance_acuity_presenting) | is.na(left_distance_acuity_presenting))
)
# pal_review <- pal_review %>% select(-c(right_distance_acuity_uncorrected, right_distance_acuity_corrected, left_distance_acuity_uncorrected, left_distance_acuity_corrected))

# Right PVA missing (n=9) - applying cause of poor vision value fixes 9/9
raabs_612 <- raabs_612 %>% mutate(
  right_distance_acuity_presenting = case_when(
    raab_id=="2018_Palestine" & exam_status=="exam_status_examined" & is.na(right_distance_acuity_presenting) & poor_vision_cause_right=="poor_vision_cause_not_examined" ~ 0.3,
    TRUE ~ right_distance_acuity_presenting
  )
)
# Left PVA missing (n=3) - applying cause of poor vision value fixes 2/3; the other observation (1024-13) is a VI case: CO as cause both eyes, right eye NPL
raabs_612 <- raabs_612 %>% mutate(
  left_distance_acuity_presenting = case_when(
    raab_id=="2018_Palestine" & exam_status=="exam_status_examined" & is.na(left_distance_acuity_presenting) & poor_vision_cause_left=="poor_vision_cause_not_examined" ~ 0.3,
    TRUE ~ left_distance_acuity_presenting
  )
)
# 1024-13 is at least worse than 6/12 as has CO as cause of poor vision. Keeping in dataset with most conservative estimate of VI (mild VI from CO le)
raabs_612 <- raabs_612 %>% mutate(
  left_distance_acuity_presenting = case_when(
    participantId=="1024-13" ~ 0.47,
    TRUE ~ left_distance_acuity_presenting
  )
)

# Palestine DR module
# The following participants have complete core RAAB data but missing DR module retinopathy and maculopathy grades for both right and left eyes
# "1032-17" "1008-17" "1021-02" "1027-29" "1014-24" "1014-22" "1014-23" "1009-01" "1034-09" "1034-07" "1034-03" "1036-03" "1004-04" "1003-02" "1119-14" "1001-23"

# 2019_Cambodia
cam_review <- raabs_612 %>% filter(
  raab_id=="2019_Cambodia" & exam_status=="exam_status_examined" & (is.na(right_distance_acuity_presenting) | is.na(left_distance_acuity_presenting))
)
cam_review <- cam_review %>% select(-c(right_distance_acuity_uncorrected, right_distance_acuity_corrected, left_distance_acuity_uncorrected, left_distance_acuity_corrected))

# Right PVA missing (n=3) - all 3 have not examined can see 6/12 for cause right eye so am applying 0.3 to each observation
raabs_612 <- raabs_612 %>% mutate(
  right_distance_acuity_presenting = case_when(
    participantId=="4010-23" ~ 0.3,
    participantId=="4113-11" ~ 0.3,
    participantId=="4097-49" ~ 0.3,
    TRUE ~ right_distance_acuity_presenting
  )
)
# Left PVA missing (n=1) - not examined can see 6/12 for cause left eye so am applying 0.3 to observation
raabs_612 <- raabs_612 %>% mutate(
  left_distance_acuity_presenting = case_when(
    participantId=="4104-25" ~ 0.3,
    TRUE ~ left_distance_acuity_presenting
  )
)

# 2021_Nepal_Province7
np7_review <- raabs_612 %>% filter(
  raab_id=="2021_Nepal_Province7" & exam_status=="exam_status_examined" & (is.na(right_distance_acuity_presenting) | is.na(left_distance_acuity_presenting))
)
np7_review <- np7_review %>% select(-c(right_distance_acuity_uncorrected, right_distance_acuity_corrected, left_distance_acuity_uncorrected, left_distance_acuity_corrected))

# 14 observations with both eyes VA data missing

# Drop 8 observations where both eyes are not "not examined, can see 6/12"
raabs_612 <- raabs_612 %>% filter(
  !(raab_id=="2021_Nepal_Province7" & exam_status=="exam_status_examined" & (is.na(right_distance_acuity_presenting) & is.na(left_distance_acuity_presenting)) & (poor_vision_cause_right!="poor_vision_cause_not_examined" | poor_vision_cause_left!="poor_vision_cause_not_examined"))
)

# Fill in PVA 0.3 values in both eyes where both eyes are "not examined, can see 6/12"
raabs_612 <- raabs_612 %>% mutate(
  right_distance_acuity_presenting = case_when(
    raab_id=="2021_Nepal_Province7" & exam_status=="exam_status_examined" & is.na(right_distance_acuity_presenting) & poor_vision_cause_right=="poor_vision_cause_not_examined" ~ 0.3,
    TRUE ~ right_distance_acuity_presenting
  )
)
raabs_612 <- raabs_612 %>% mutate(
  left_distance_acuity_presenting = case_when(
    raab_id=="2021_Nepal_Province7" & exam_status=="exam_status_examined" & is.na(left_distance_acuity_presenting) & poor_vision_cause_left=="poor_vision_cause_not_examined" ~ 0.3,
    TRUE ~ left_distance_acuity_presenting
  )
)

# Missing cause values in early RAAB7s

# 2020_Nepal_Province2
np2_review <- raabs_612 %>% filter(
  raab_id=="2020_Nepal_Province2" & exam_status=="exam_status_examined" & (poor_vision_cause_right=="" | poor_vision_cause_left=="" | poor_vision_cause_principle=="")
)
# Principal cause missing n=1, both eyes 6/12
raabs_612 <- raabs_612 %>% mutate(
  poor_vision_cause_principle = case_when(
  participantId=="12117-31" ~ "poor_vision_cause_not_examined",
  TRUE ~ poor_vision_cause_principle
)
)
# Left eye cause missing n=1, left eye 6/12
raabs_612 <- raabs_612 %>% mutate(
  poor_vision_cause_left = case_when(
    participantId=="12005-33" ~ "poor_vision_cause_not_examined",
  TRUE ~ poor_vision_cause_left
)
)

# 2018_Palestine
pal_review_cause <- raabs_612 %>% filter(
  raab_id=="2018_Palestine" & exam_status=="exam_status_examined" & (poor_vision_cause_right=="" | poor_vision_cause_left=="" | poor_vision_cause_principle=="")
)

# Cannot assign cause from other fields so dropping 1083-32
raabs_612 <- raabs_612 %>% filter(
  !(raab_id=="2018_Palestine" & exam_status=="exam_status_examined" & poor_vision_cause_left=="")
)


# Historic RAAB data - not using participantId as not unique across RAABs

# 2019_Armenia - survey team confirmed by email all missing data are not retrievable 

# Missing sex data among examined (n=11), dropping all (Publication reports n=2258 examined (2269-11))
raabs_612 <- raabs_612 %>% filter(
  !(raab_id=="2019_Armenia" & exam_status=="exam_status_examined" & is.na(gender))
)

# Missing pva data among examined (n=3; n=2 both eyes and n=1 right eye only) - not deleted from dataset for publication? Also missing lens status and cause so dropping
raabs_612 <- raabs_612 %>% filter(
  !(raab_id=="2019_Armenia" & exam_status=="exam_status_examined" & (is.na(right_distance_acuity_presenting) | is.na(left_distance_acuity_presenting)))
)

# Couched eyes and lens_status mismatch
# 2021_Ethiopia_Oromia_Jimma

write.csv(raabs_612, here('outputs', 'raabs_612.csv'), row.names = FALSE)
