# filter data to repo open access only
# requires most recent version of raab-log_v5 to be downloaded

library(dplyr)
library(here)
library(readxl)

# all raab data

raab5 <- read.csv(here('outputs', 'raabs_618.csv'))
raab6 <- read.csv(here('outputs', 'raabs_612.csv'))

# Match participantId var types
raab5$participantId <- as.character(raab5$participantId)

raabs_all <- bind_rows('raab5' = raab5, 'raab6' = raab6, .id = "version")

# # match id formatting to raab_log_v5
# raabs_all$raab_id<-gsub("\\.","_",raabs_all$raab_id)
# raabs_all$raab_id<-gsub("\\ ","-",raabs_all$raab_id)
# raabs_all$raab_id<-gsub("\\_$","",raabs_all$raab_id)
# raabs_all$raab_id<-gsub("\\_$","",raabs_all$raab_id)
# match id spelling
# raabs_all$raab_id<-gsub("\\,", "",raabs_all$raab_id)
# raabs_all$raab_id<-gsub("\\'", "",raabs_all$raab_id)
# raabs_all$raab_id<-gsub("2019_Kyrgyzstan_North-east","2019_Kyrgyzstan_Northeast",raabs_all$raab_id)
# raabs_all$raab_id<-gsub("2007_Kenya_Embu","2007_Kenya_Eastern_Embu",raabs_all$raab_id)
# raabs_all$raab_id<-gsub("2016_Timor-Leste","2016_TimorLeste",raabs_all$raab_id)

# limit length of id name (Malawi and Malaysia KL)
raabs_all$raab_id<-strtrim(raabs_all$raab_id, 50)

raabs_all_ids <- as.data.frame(unique(raabs_all$raab_id))

# raab_log_v5 access status

meta<-read.csv(here("data", "historic_meta.csv"))

meta[meta=="NA"]<-NA
meta<-meta[!is.na(meta$raab_id),]

meta$raab_id<-strtrim(meta$raab_id, 50)

# open access data via the repo
# open<-meta[meta$repo_meta==TRUE & meta$repo_data==TRUE,]
# open<-open[!is.na(open$raab_id),]
# 
# open_access_ids <- as.data.frame(unique(open$raab_id))

# data with consent for the ecsc/erec study
vleg<-meta[meta$ecsc_consent==TRUE,]
vleg<-vleg[!is.na(vleg$raab_id),]
vleg_ids <- as.data.frame(unique(vleg$raab_id))

# filter raabs by id on open access status
# raabs_open <- raabs_all[raabs_all$raab_id %in% open$raab_id,]
# raabs_open_ids <- as.data.frame(unique(raabs_open$raab_id))

# list <- as.data.frame(open_access_ids$`unique(open$raab_id)` %in% raabs_open_ids$`unique(raabs_open$raab_id)`)
# check <- cbind(open_access_ids, list)

# filter raabs by id on ecsc/erec study consent
raabs_vleg <- raabs_all[raabs_all$raab_id %in% vleg$raab_id,]
raabs_vleg_ids <- as.data.frame(unique(raabs_vleg$raab_id))

list <- as.data.frame(vleg_ids$`unique(vleg$raab_id)` %in% raabs_vleg_ids$`unique(raabs_vleg$raab_id)`)
check <- cbind(vleg_ids, list)


# drop cols for file to share with VLEG

raabs_vleg <- raabs_vleg %>% select(
  -starts_with(c('eye_history', 'dr', 'Diabetic', "wg_"))
) 

# drop surgery cols except surgery_type that indicates if couching was done
raabs_vleg <- raabs_vleg %>% select(-starts_with(c('surgery_none', 'surgery_age', 'surgery_place', 'surgery_cost', 'surgery_poor')))

# raabs_vleg <- raabs_vleg %>% select(-'created', -'repeat.', -'latitude', -'longitude')
# raabs_vleg <- raabs_vleg %>% select(-'acuity_test_distance')
raabs_vleg <- raabs_vleg %>% select(-'right_distance_acuity_uncorrected', -'left_distance_acuity_uncorrected', -'right_distance_acuity_corrected', -'left_distance_acuity_corrected')

# 30.06.23 dropping Liberia until the conversion is resolved
raabs_vleg <- raabs_vleg %>% filter(raab_id!="2012_Liberia")


# raabs_vleg <- raabs_vleg %>% mutate(
#   gbd_region = case_when(
#     gbd_region=='gbd1' ~ 'sea_ea_o',
#     gbd_region=='gbd2' ~ 'sa',
#     gbd_region=='gbd3' ~ 'ce_ee_ca',
#     gbd_region=='gbd4' ~ 'na_me',
#     gbd_region=='gbd5' ~ 'ssa',
#     gbd_region=='gbd6' ~ 'lac',
#     gbd_region=='gbd7' ~ 'hi'
#   )
# )

# test gbd regions correct for countries
regions <- raabs_vleg %>% group_by(country) %>% count(gbd_superreg)

# test hwo regions correct for countries
regions_who <- vleg %>% group_by(level0) %>% count(who_reg)

# output open access datasets
write.csv(raabs_open, here('outputs', 'raabs-open.csv'), row.names = FALSE)
# output open access datasets plus permission for WHO/VLEG study
write.csv(raabs_vleg, here('outputs', 'raabs-vleg.csv'), row.names = FALSE)
# output list of ids only
write.csv(raabs_vleg_ids, here('outputs', 'raabs-vleg-ids.csv'), row.names = FALSE)

# output request from SK 05.04.22
write.csv(regions_who, here('outputs', 'raabs-ecsc-summary.csv'), row.names = FALSE)

# survey level summary of data sources for eCSC project

# sample size summary information
raabs_examined <- raabs_vleg %>% filter(exam_status=="exam_status_examined")


sample_size <- raabs_examined %>% group_by(raab_id) %>% summarise(sample=n())
hist(sample_size$sample)
median(sample_size$sample)
quantile(sample_size$sample, 0.25)
quantile(sample_size$sample, 0.75)



write.csv(sample_size, here('outputs',"raab_ecsc_sample_sizes.csv"), row.names = FALSE)

