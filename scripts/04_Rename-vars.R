# Update historic varnames to RAAB7 
# satisre and satisle omitted from all updates

library(tidyverse)
library(data.table)

# Read in RACSS and add, remove or rename vars to align with RAAB7 (NB only one bloodsugar var in RACSS data sets)
racss_sur_data_newvars <- read.csv(here('outputs', 'racss_sur_data.csv')) %>% 
  select('raab_id',  'gbd', 'year','id', 'cluster', 
         'status','age','sex',
         'histre', 'histle',
         'glasses', 'glassesn',
         'pvare', 'pvale', 'bvare', 'bvale',
         'lere', 'lele',
         'causere', 'causele', 'prcause',
         'bar1', 'bar2',
         'agere', 'plre','surgre','costre','outlowre',
         'agele', 'plle', 'surgle', 'costle', 'outlowle',
         'knowndm', 'noblood', 'bloodsugar',
         'agedm', 'dmtypetreat', 'dmlastexam',
         'drexam',
         'drretinare', 'drmaculare', 'drscarsre',
         'drretinale', 'drmaculale', 'drscarsle', -dmtreatment, -dmexbefore, -drnodilate, -drnophoto) %>% 
  mutate('dr_retinopathy_method_left' = drexam) %>% relocate('dr_retinopathy_method_left', .before = "drretinale") %>% 
  rename('dr_retinopathy_method_right' = drexam) %>%
  mutate('country' = gsub("^.+?\\.(.+?)\\..*$", "\\1", raab_id)) %>% relocate('country', .before = 'gbd') %>% 
  # add_column('created' = 0, .after = "cluster") %>% 
  # add_column('longitude' = 0, .after = "sex") %>% add_column('latitude' = 0, .after = "sex") %>% 
  # add_column('acuity_test_distance' = 0, .after = "longitude") %>%
  add_column('right_distance_acuity_uncorrected' = 0, .before = 'pvare') %>% add_column('right_distance_acuity_corrected' = 0, .before = 'pvare') %>% 
  add_column('left_distance_acuity_uncorrected' = 0, .before = 'pvale') %>% add_column('left_distance_acuity_corrected' = 0, .before = 'pvale') %>%
  add_column( 'bloodsugar2' = 0, .after = "bloodsugar") %>%
  relocate('glassesn', .after = "glasses") %>%
  relocate('noblood', .before = "bloodsugar") %>%
  relocate('bvare', .after = 'pvare') %>% 
  relocate('bvale', .after = 'pvale')
  # add_column('Diabetic Retinopathy Not Visualised Reason Right' = as.character(0), .after = "drscarsre") %>% 
  # add_column('Diabetic Retinopathy Not Visualised Reason Left' = as.character(0), .after = "drscarsle")

setnames(racss_sur_data_newvars, 
         old = c('raab_id', 'gbd', 'year', 'cluster', 'id',
                 'sex','age', 'status', 
                 'histre', 'histle',
                 'glasses', 'glassesn',
                 'pvare', 'pvale', 'bvare', 'bvale',
                 'lere', 'lele',
                 'causere', 'causele', 'prcause',
                 'bar1', 'bar2',
                 'agere', 'agele',
                 'plre', 'plle',
                 'surgre', 'surgle',
                 'costre', 'costle',
                 'outlowre', 'outlowle',
                 'knowndm', 'noblood', 'bloodsugar', 'bloodsugar2',
                 'agedm', 'dmtypetreat', 'dmlastexam',
                 'drretinare', 'drmaculare', 'drscarsre',
                 'drretinale', 'drmaculale', 'drscarsle'
         ),
         
         new = c('raab_id', 'gbd_superreg', 'year','clusterId', 'participantId',
                 'gender','age', 'exam_status',
                 'eye_history_right', 'eye_history_left',
                 'spectacles_used_distance', 'spectacles_used_near', 
                 'right_distance_acuity_presenting', 'left_distance_acuity_presenting','right_distance_acuity_pinhole', 'left_distance_acuity_pinhole',
                 'lens_status_right', 'lens_status_left',
                 'poor_vision_cause_right', 'poor_vision_cause_left', 'poor_vision_cause_principle',
                 'surgery_none_reason_1', 'surgery_none_reason_2',
                 'surgery_age_right', 'surgery_age_left',
                 'surgery_place_right', 'surgery_place_left',
                 'surgery_type_right', 'surgery_type_left',
                 'surgery_cost_right', 'surgery_cost_left',
                 'surgery_poor_vision_reason_right', 'surgery_poor_vision_reason_left',
                 'dr_diabetes_known', 'dr_diabetes_blood_consent', 'dr_diabetes_blood_sugar', 'dr_diabetes_blood_sugar_mmol',
                 'dr_diabetic_told_age', 'dr_diabetic_treatment', 'dr_diabetic_last_exam',
                 'dr_retinopathy_grade_right', 'dr_maculopathy_grade_right', 'dr_laser_photocoagulation_scars_right',
                 'dr_retinopathy_grade_left', 'dr_maculopathy_grade_left', 'dr_laser_photocoagulation_scars_left'
         ))

write.csv(racss_sur_data_newvars, here('outputs', 'racss_sur_data_newvars.csv'), row.names = FALSE)


# Read in RAAB5 and add, remove or rename vars to align with RAAB7
raab5_sur_data_newvars <- read.csv(here('outputs', 'raab5_sur_data.csv')) %>% 
  select('raab_id', 'gbd', 'year','id', 'cluster', 
         'status','age','sex',
         'histre', 'histle',
         'glasses', 'glassesn',
         'pvare', 'pvale', 'bvare', 'bvale',
         'lere', 'lele',
         'causere', 'causele', 'prcause',
         'bar1', 'bar2',
         'agere', 'plre','surgre','costre','outlowre',
         'agele', 'plle', 'surgle', 'costle', 'outlowle',
         'knowndm', 'noblood', 'bloodsugar',
         'agedm', 'dmtypetreat', 'dmlastexam',
         'drexam',
         'drretinare', 'drmaculare', 'drscarsre',
         'drretinale', 'drmaculale', 'drscarsle', -dmtreatment, -dmexbefore, -drnodilate, -drnophoto) %>% 
  mutate('dr_retinopathy_method_left' = drexam) %>% relocate('dr_retinopathy_method_left', .before = "drretinale") %>% 
  rename('dr_retinopathy_method_right' = drexam) %>%
  mutate('country' = gsub("^.+?\\.(.+?)\\..*$", "\\1", raab_id)) %>% relocate('country', .before = 'gbd') %>%
  # add_column('created' = 0, .after = "cluster") %>% 
  # add_column('longitude' = 0, .after = "sex") %>% add_column('latitude' = 0, .after = "sex") %>% 
  # add_column('acuity_test_distance' = 0, .after = "longitude") %>% 
  add_column('right_distance_acuity_uncorrected' = 0, .before = 'pvare') %>% add_column('right_distance_acuity_corrected' = 0, .before = 'pvare') %>% 
  add_column('left_distance_acuity_uncorrected' = 0, .before = 'pvale') %>% add_column('left_distance_acuity_corrected' = 0, .before = 'pvale') %>%
  add_column( 'bloodsugar2' = 0, .after = "bloodsugar") %>%
  relocate('glassesn', .after = "glasses") %>%
  relocate('noblood', .before = "bloodsugar") %>%
  relocate('bvare', .after = 'pvare') %>% 
  relocate('bvale', .after = 'pvale') 
  # add_column('Diabetic Retinopathy Not Visualised Reason Right' = as.character(0), .after = "drscarsre") %>% 
  # add_column('Diabetic Retinopathy Not Visualised Reason Left' = as.character(0), .after = "drscarsle")

setnames(raab5_sur_data_newvars, 
         old = c('raab_id', 'gbd', 'year','cluster', 'id',
                 'sex','age', 'status', 
                 'histre', 'histle',
                 'glasses', 'glassesn',
                 'pvare', 'pvale', 'bvare', 'bvale',
                 'lere', 'lele',
                 'causere', 'causele', 'prcause',
                 'bar1', 'bar2',
                 'agere', 'agele',
                 'plre', 'plle',
                 'surgre', 'surgle',
                 'costre', 'costle',
                 'outlowre', 'outlowle',
                 'knowndm', 'noblood', 'bloodsugar', 'bloodsugar2',
                 'agedm', 'dmtypetreat', 'dmlastexam',
                 'drretinare', 'drmaculare', 'drscarsre',
                 'drretinale', 'drmaculale', 'drscarsle'
         ),
         
         new = c('raab_id', 'gbd_superreg', 'year','clusterId', 'participantId',
                 'gender','age', 'exam_status',
                 'eye_history_right', 'eye_history_left',
                 'spectacles_used_distance', 'spectacles_used_near', 
                 'right_distance_acuity_presenting', 'left_distance_acuity_presenting','right_distance_acuity_pinhole', 'left_distance_acuity_pinhole',
                 'lens_status_right', 'lens_status_left',
                 'poor_vision_cause_right', 'poor_vision_cause_left', 'poor_vision_cause_principle',
                 'surgery_none_reason_1', 'surgery_none_reason_2',
                 'surgery_age_right', 'surgery_age_left',
                 'surgery_place_right', 'surgery_place_left',
                 'surgery_type_right', 'surgery_type_left',
                 'surgery_cost_right', 'surgery_cost_left',
                 'surgery_poor_vision_reason_right', 'surgery_poor_vision_reason_left',
                 'dr_diabetes_known', 'dr_diabetes_blood_consent', 'dr_diabetes_blood_sugar', 'dr_diabetes_blood_sugar_mmol',
                 'dr_diabetic_told_age', 'dr_diabetic_treatment', 'dr_diabetic_last_exam',
                 'dr_retinopathy_grade_right', 'dr_maculopathy_grade_right', 'dr_laser_photocoagulation_scars_right',
                 'dr_retinopathy_grade_left', 'dr_maculopathy_grade_left', 'dr_laser_photocoagulation_scars_left'
         ))

write.csv(raab5_sur_data_newvars, here('outputs', 'raab5_sur_data_newvars.csv'), row.names = FALSE)

# Read in RAAB6 and add, remove or rename vars to align with RAAB7. NB Variables using RAAB6 codes are all stored as integers as this stage
raab6_sur_data_newvars <- read.csv(here('outputs', 'raab6_sur_data.csv')) %>% 
  select('raab_id', 'gbd', 'year','id', 'cluster', 
         'status','age','sex',
         'histre', 'histle',
         'glasses', 'glassesn',
         'pvare', 'pvale', 'bvare', 'bvale',
         'lere', 'lele',
         'causere', 'causele', 'prcause',
         'bar1', 'bar2',
         'agere', 'plre','surgre','costre','outlowre',
         'agele', 'plle', 'surgle', 'costle', 'outlowle',
         'knowndm', 'noblood', 'bloodsugar', 'bloodsugar2',
         'agedm', 'dmtypetreat', 'dmlastexam',
         'drexam',
         'drretinare', 'drmaculare', 'drscarsre',
         'drretinale', 'drmaculale', 'drscarsle', -dmtreatment, -dmexbefore, -drnodilate, -drnophoto) %>% 
  mutate('dr_retinopathy_method_left' = drexam) %>% relocate('dr_retinopathy_method_left', .before = "drretinale") %>% 
  rename('dr_retinopathy_method_right' = drexam) %>%
    mutate('country' = gsub("^.+?\\.(.+?)\\..*$", "\\1", raab_id)) %>% relocate('country', .before = 'gbd') %>%
    # add_column('created' = 0, .after = "cluster") %>% 
    # add_column('longitude' = 0, .after = "sex") %>% add_column('latitude' = 0, .after = "sex") %>% 
    # add_column('acuity_test_distance' = 0, .after = "longitude") %>% 
    add_column('right_distance_acuity_uncorrected' = 0, .before = 'pvare') %>% add_column('right_distance_acuity_corrected' = 0, .before = 'pvare') %>% 
    add_column('left_distance_acuity_uncorrected' = 0, .before = 'pvale') %>% add_column('left_distance_acuity_corrected' = 0, .before = 'pvale') %>% 
    relocate('noblood', .before = "bloodsugar") %>% 
    relocate('bvare', .after = 'pvare') %>% 
    relocate('bvale', .after = 'pvale') %>% 
    # add_column('Diabetic Retinopathy Not Visualised Reason Right' = as.character(0), .after = "drscarsre") %>% 
    # add_column('Diabetic Retinopathy Not Visualised Reason Left' = as.character(0), .after = "drscarsle")
    add_column('wg_difficulty_seeing'= NA, .after = 'drscarsle') %>% 
    add_column('wg_difficulty_hearing'= NA, .after = 'wg_difficulty_seeing') %>% 
    add_column('wg_difficulty_mobility'= NA, .after = 'wg_difficulty_hearing') %>% 
    add_column('wg_difficulty_memory'= NA, .after = 'wg_difficulty_mobility') %>% 
    add_column('wg_difficulty_communication'= NA, .after = 'wg_difficulty_memory') %>%
    add_column('wg_difficulty_selfcare'= NA, .after = 'wg_difficulty_communication')

setnames(raab6_sur_data_newvars, 
         old = c('raab_id', 'gbd', 'year','cluster', 'id',
                 'sex','age', 'status', 
                 'histre', 'histle',
                 'glasses', 'glassesn',
                 'pvare', 'pvale', 'bvare', 'bvale',
                 'lere', 'lele',
                 'causere', 'causele', 'prcause',
                 'bar1', 'bar2',
                 'agere', 'agele',
                 'plre', 'plle',
                 'surgre', 'surgle',
                 'costre', 'costle',
                 'outlowre', 'outlowle',
                 'knowndm', 'noblood', 'bloodsugar', 'bloodsugar2',
                 'agedm', 'dmtypetreat', 'dmlastexam',
                 'drretinare', 'drmaculare', 'drscarsre',
                 'drretinale', 'drmaculale', 'drscarsle'
         ),
         
         new = c('raab_id', 'gbd_superreg', 'year','clusterId', 'participantId',
                 'gender','age', 'exam_status',
                 'eye_history_right', 'eye_history_left',
                 'spectacles_used_distance', 'spectacles_used_near', 
                 'right_distance_acuity_presenting', 'left_distance_acuity_presenting','right_distance_acuity_pinhole', 'left_distance_acuity_pinhole',
                 'lens_status_right', 'lens_status_left',
                 'poor_vision_cause_right', 'poor_vision_cause_left', 'poor_vision_cause_principle',
                 'surgery_none_reason_1', 'surgery_none_reason_2',
                 'surgery_age_right', 'surgery_age_left',
                 'surgery_place_right', 'surgery_place_left',
                 'surgery_type_right', 'surgery_type_left',
                 'surgery_cost_right', 'surgery_cost_left',
                 'surgery_poor_vision_reason_right', 'surgery_poor_vision_reason_left',
                 'dr_diabetes_known', 'dr_diabetes_blood_consent', 'dr_diabetes_blood_sugar', 'dr_diabetes_blood_sugar_mmol',
                 'dr_diabetic_told_age', 'dr_diabetic_treatment', 'dr_diabetic_last_exam',
                 'dr_retinopathy_grade_right', 'dr_maculopathy_grade_right', 'dr_laser_photocoagulation_scars_right',
                 'dr_retinopathy_grade_left', 'dr_maculopathy_grade_left', 'dr_laser_photocoagulation_scars_left'
         ))

write.csv(raab6_sur_data_newvars, here('outputs', 'raab6_sur_data_newvars.csv'), row.names = FALSE) #saves as integers not factors




