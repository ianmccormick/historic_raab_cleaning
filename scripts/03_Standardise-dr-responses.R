# Script to align DR module observations
# If no DR module done, all numeric cells set to 0 and all logical cells set to NA

# List of RAABs with DR module, taken from raab-log_v5

#RACSS N=0
racss_sur_data$noblood <- NA

write.csv(racss_sur_data, here('outputs', 'racss_sur_data.csv'), row.names = FALSE)

#RAAB5 N=13 total
raab5_dr <- c("2016.Cuba..",
              "2014.Iran.Kurdistan.",
              "2012.Jordan.Irbid.",
              # "2010.Mexico.Chiapas.Central, Highland and Frialesca", NB this was a pilot of DR module, data not inputted to RAAB software
              "2012.Moldova..",
              "2015.Pakistan.FATA.Peshawar",
              "2011.Saudi Arabia.Taif.",
              "2013.Suriname..")

# replace FALSE with NA in RAABs with no DR module
raab5_sur_data$noblood[!(raab5_sur_data$raab_id %in% raab5_dr)] <- NA

# replace NA with FALSE in RAAB+DRs where FALSE has been left blank among examined
raab5_sur_data <- raab5_sur_data %>% 
  mutate(
  noblood = case_when((raab_id %in% raab5_dr & status==1 & is.na(noblood) ~ "true"),
                      raab_id %in% raab5_dr & status==1 & noblood==TRUE ~ "false",
                      raab_id %in% raab5_dr & status==1 & noblood==FALSE ~ "true",
                      raab_id %in% raab5_dr & status!=1 ~ NA)
)

# drexam: 1=dilated, 2=fundus photo, 3=refused dilation
# recode drexam from 1, 2, 3 with 2 never used for fundus photos to 1=dilated 2=refused dilation
raab5_sur_data <- raab5_sur_data %>% 
  mutate(
    drexam = case_when(raab_id %in% raab5_dr & status==1 & drexam==1 ~ 1,
                        raab_id %in% raab5_dr & status==1 & drexam==2 ~ 0,
                        raab_id %in% raab5_dr & status==1 & drexam==3 ~2)
    )

write.csv(raab5_sur_data, here('outputs', 'raab5_sur_data.csv'), row.names = FALSE)

#RAAB6 N= total (inc India national series)
raab6_dr <- c("2016.Cameroon.Yaounde",
              "2015.Costa Rica..",
              "2019.Egypt.Sohag.",
              "2015.Hungary..",
              "2014.Mexico.Nuevo Leon.",
              "2015.Mexico.Queretaro.",
              "2016.Pakistan.Khyber Pakhtunkhwa.Mansehra",
              "2016.Pakistan.Khyber Pakhtunkhwa.Swabi",
              "2017.Papua New Guinea.NCD.",
              "2017.India.Maharashtra.Pune",
              "2018.Nepal.Province5.",
              "2020.Nepal.Province1.",
              "2020.Nepal.Province4.")
              # "2021.Pakistan.Sindh.Umerkot",
              # "2021.Pakistan.Sindh.Malir",
              # "2021.Pakistan.Sindh.Jacobabad",
              # "2019.Pakistan.Punjab.Vehari",
              # "2019.Pakistan.Punjab.Sialkot",
              # "2019.Pakistan.Punjab.Sargodha",
              # "2019.Pakistan.Punjab.Rawalpindi",
              # "2019.Pakistan.Punjab.Rajanpur",
              # "2019.Pakistan.Punjab.Layyah",
              # "2019.Pakistan.Punjab.Hafizabad",
              # "2019.Pakistan.Khyber Pakhtunkhwa.Nowshera",
              # "2019.Pakistan.Khyber Pakhtunkhwa.Lower Dir",
              # "2019.Pakistan.Khyber Pakhtunkhwa.Khyber Agency",
              # "2019.Pakistan.Khyber Pakhtunkhwa.Dera Ismail Khan",
              # "2019.Pakistan.Balochistan.Quetta")

# replace FALSE with NA in RAABs with no DR module
raab6_sur_data$noblood[!(raab6_sur_data$raab_id %in% raab6_dr)] <- NA

# replace NA with FALSE in RAAB+DRs where FALSE has been left blank among examined
raab6_sur_data <- raab6_sur_data %>% 
  mutate(
    noblood = case_when((raab_id %in% raab6_dr & status==1 & is.na(noblood) ~ "true"),
                        raab_id %in% raab6_dr & status==1 & noblood==TRUE ~ "false",
                        raab_id %in% raab6_dr & status==1 & noblood==FALSE ~ "true",
                        raab_id %in% raab6_dr & status!=1 ~ NA)
  )

# drexam: 1=dilated, 2=fundus photo, 3=refused dilation
# recode drexam from 1, 2, 3 with 2 never used for fundus photos to 1=dilated 2=refused dilation
raab6_sur_data <- raab6_sur_data %>% 
  mutate(
    drexam = case_when(raab_id %in% raab6_dr & status==1 & drexam==1 ~ 1,
                       raab_id %in% raab6_dr & status==1 & drexam==2 ~ 0, # 12 observations ==2 in Pakistan series but all had DR examination responses so could recode as dilated, or update raw data
                       raab_id %in% raab6_dr & status==1 & drexam==3 ~2)
  )

write.csv(raab6_sur_data, here('outputs', 'raab6_sur_data.csv'), row.names = FALSE)

