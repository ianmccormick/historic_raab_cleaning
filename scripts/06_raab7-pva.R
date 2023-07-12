library(tidyverse)
library(here)

# Read in an export of the Peek RAAB7 database - note survey and pop coming from different sources 02 May 2023
# raab7 <- read.csv(here('data', 'peek-raab-export_230314', 'surveys.csv'))
raab7 <- read.csv(here('data', 'peek-encounter-2023-07-12T11-23-survey.csv'))
raab7_pop <- read.csv(here('data', 'peek-raab-export_230314', 'population.csv'))

# Filter to early RAAB7s with PVA only
pva_raab7s <- c("08287662-baeb-4093-ac1d-a80a6a961258", #'2018.Palestine..', CLOSED
                "6e386334-4050-4d03-973b-00b710e5c1c3", #'2018.Pakistan.Punjab.Talagang',
                "f83ec5aa-7694-4a72-aa7d-47d23093978a", #'2019.Cambodia..',
                "22b71eee-5493-402f-89e6-9ea25a04434e", #'2019.Nepal.Karnali.', CLOSED
                "ef713fa5-6757-4c99-985c-5bf71c9d9c33", #'2019.Nepal.Province3.', CLOSED
                "50f4c3d3-490a-4a6c-b088-9cbcbc8e997c", #'2020.Nepal.Province2.', CLOSED
                "8320455b-39d5-441f-9806-ed1403867f7e", #'2019.Zimbabwe.Matabeleland South.', CLOSED
                "15e50c7a-d2b4-426a-8a3a-f4234e88e8c8", #'2019.Pakistan.Sindh.Matiari',
                "63d1d070-1021-4a78-bfc1-369195459a1d") #'2021.Nepal.Province7.' CLOSED

raab7pva_sur_data <- raab7 %>% filter(raab_id %in% pva_raab7s)
raab7pva_pop_data <- raab7_pop %>% filter(regionId %in% pva_raab7s)

# Create a raab_id variable in the historic RAAB format
raab7pva_sur_data <- raab7pva_sur_data %>% mutate(
  raab_id = case_when(
    raab_id == "08287662-baeb-4093-ac1d-a80a6a961258" ~ '2018.Palestine..',
    raab_id == "6e386334-4050-4d03-973b-00b710e5c1c3" ~ '2018.Pakistan.Punjab.Talagang',
    raab_id == "f83ec5aa-7694-4a72-aa7d-47d23093978a" ~ '2019.Cambodia..',
    raab_id == "22b71eee-5493-402f-89e6-9ea25a04434e" ~ '2019.Nepal.Karnali.',
    raab_id == "ef713fa5-6757-4c99-985c-5bf71c9d9c33" ~ '2019.Nepal.Province3.',
    raab_id == "50f4c3d3-490a-4a6c-b088-9cbcbc8e997c" ~ '2020.Nepal.Province2.',
    raab_id == "8320455b-39d5-441f-9806-ed1403867f7e" ~ '2019.Zimbabwe.Matabeleland South.',
    raab_id == "15e50c7a-d2b4-426a-8a3a-f4234e88e8c8" ~ '2019.Pakistan.Sindh.Matiari',
    raab_id == "63d1d070-1021-4a78-bfc1-369195459a1d" ~ '2021.Nepal.Province7.')
  )

# Select RAAB6 variables
raab7pva_sur_data <- raab7pva_sur_data %>% select('raab_id', 'clusterId', 'participantId',
                          'gender','age', 'exam_status',
                          'eye_history_right', 'eye_history_left',
                          'spectacles_used_distance', 'spectacles_used_near',
                          'right_distance_acuity_uncorrected', 'left_distance_acuity_uncorrected', 'right_distance_acuity_corrected', 'left_distance_acuity_corrected',
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
                          'dr_retinopathy_method_right', 'dr_retinopathy_grade_right', 'dr_maculopathy_grade_right', 'dr_laser_photocoagulation_scars_right',
                          'dr_retinopathy_method_left', 'dr_retinopathy_grade_left', 'dr_maculopathy_grade_left', 'dr_laser_photocoagulation_scars_left',
                          'wg_difficulty_seeing', 'wg_difficulty_hearing', 'wg_difficulty_mobility', 'wg_difficulty_memory', 'wg_difficulty_communication', 'wg_difficulty_selfcare')
  

raab7pva_sur_data <- raab7pva_sur_data %>% add_column('gbd_superreg' = 'none', .after = 'raab_id') %>% add_column('year' = 0, .after = 'gbd_superreg')

# Add GBD super regions
raab7pva_sur_data <- raab7pva_sur_data %>% mutate(
  gbd_superreg = case_when(
    raab_id=="2018.Palestine.." ~ "gbd4",
    raab_id=='2018.Pakistan.Punjab.Talagang' ~ "gbd2",
    raab_id=='2019.Cambodia..' ~ "gbd1",
    raab_id=='2019.Nepal.Karnali.' ~ "gbd2",
    raab_id=='2019.Nepal.Province3.' ~ "gbd2",
    raab_id=='2020.Nepal.Province2.' ~ "gbd2",
    raab_id=='2019.Zimbabwe.Matabeleland South.' ~ "gbd5",
    raab_id=='2019.Pakistan.Sindh.Matiari' ~ "gbd2",
    raab_id=='2021.Nepal.Province7.' ~ "gbd2"
  )
)
# Add year in
raab7pva_sur_data <- raab7pva_sur_data %>% mutate(
  year = case_when(
    raab_id=="2018.Palestine.." ~ 2018,
    raab_id=='2018.Pakistan.Punjab.Talagang' ~ 2018,
    raab_id=='2019.Cambodia..' ~ 2019,
    raab_id=='2019.Nepal.Karnali.' ~ 2019,
    raab_id=='2019.Nepal.Province3.' ~ 2019,
    raab_id=='2020.Nepal.Province2.' ~ 2020,
    raab_id=='2019.Zimbabwe.Matabeleland South.' ~ 2019,
    raab_id=='2019.Pakistan.Sindh.Matiari' ~ 2019,
    raab_id=='2021.Nepal.Province7.' ~ 2021
  )
) %>% 
  mutate('country' = gsub("^.+?\\.(.+?)\\..*$", "\\1", raab_id)) %>% relocate('country', .before = 'gbd_superreg')

# Relabel gbd region values
raab7pva_sur_data <- raab7pva_sur_data %>% mutate(
  gbd_superreg = case_when(
                               gbd_superreg=="gbd1" ~ "sea_ea_o",
                               gbd_superreg=="gbd2" ~ "sa",
                               gbd_superreg=="gbd3" ~ "ce_ee_ca",
                               gbd_superreg=="gbd4" ~ "na_me",
                               gbd_superreg=="gbd5" ~ "ssa",
                               gbd_superreg=="gbd6" ~ "lac",
                               gbd_superreg=="gbd7" ~ "hi")
)

# Replace empty character values for dr_diabetes_blood_consent with NA values if DR module not done (NA required for DR_check in wrapper scripts)
raab7pva_sur_data <- raab7pva_sur_data %>% mutate(
  dr_diabetes_blood_consent = case_when(
    dr_diabetes_blood_consent=="" ~ NA, TRUE ~ dr_diabetes_blood_consent
  )
)

# Replace empty character values for wg_ with NA values if disability module not done (NA required for WG_check in wrapper scripts)
raab7pva_sur_data <- raab7pva_sur_data %>% mutate(
  across(starts_with("wg_"), ~case_when(
    .=="" ~ NA_character_, TRUE ~ as.character(.)
  )
))



# Write csv to merge with raabs_612.csv
write.csv(raab7pva_sur_data, here('outputs', 'raab7pva_sur_data.csv'), row.names = FALSE)

# RAAB7 population counts update

raab7pva_pop_data <- raab7pva_pop_data %>% mutate(
  raab_id = case_when(
    regionId == "08287662-baeb-4093-ac1d-a80a6a961258" ~ '2018.Palestine..',
    regionId == "6e386334-4050-4d03-973b-00b710e5c1c3" ~ '2018.Pakistan.Punjab.Talagang',
    regionId == "f83ec5aa-7694-4a72-aa7d-47d23093978a" ~ '2019.Cambodia..',
    regionId == "22b71eee-5493-402f-89e6-9ea25a04434e" ~ '2019.Nepal.Karnali.',
    regionId == "ef713fa5-6757-4c99-985c-5bf71c9d9c33" ~ '2019.Nepal.Province3.',
    regionId == "50f4c3d3-490a-4a6c-b088-9cbcbc8e997c" ~ '2020.Nepal.Province2.',
    regionId == "8320455b-39d5-441f-9806-ed1403867f7e" ~ '2019.Zimbabwe.Matabeleland South.',
    regionId == "15e50c7a-d2b4-426a-8a3a-f4234e88e8c8" ~ '2019.Pakistan.Sindh.Matiari',
    regionId == "63d1d070-1021-4a78-bfc1-369195459a1d" ~ '2021.Nepal.Province7.')
)

raab7pva_pop_data <- raab7pva_pop_data %>% select('raab_id', 'gender', 'ageStart', 'ageEnd', 'population')

# Write csv to merge with raabs_pop_612.csv
write.csv(raab7pva_pop_data, here('outputs', 'raab7pva_pop_data.csv'), row.names = FALSE)
