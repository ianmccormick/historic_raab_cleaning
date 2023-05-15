# Merge RACSS and RAAB5 historic data sets pop counts as both examine VA to 6/18 (no analysis of 6/12 outcomes feasible)
# Merge RAAB6 and RAAB7pva historic data sets as both examine VA to 6/12 (no analysis of UCVA feasible)
# Rename and restructure the pop files to align with RAAB7 output

library(tidyverse)
library(here)

# Historic data sets using 6/18 threshold - single use of separate version of code to generate summary tables?
racss_pop_data <- read.csv(here('outputs', 'racss_pop_data.csv'))
raab5_pop_data <- read.csv(here('outputs', 'raab5_pop_data.csv'))

raabs_pop_618 <- rbind(racss_pop_data, raab5_pop_data)

write.csv(raabs_pop_618, here('outputs', 'raabs_pop_618.csv'), row.names = FALSE)

# Rename and restructure the pop files to align with RAAB7 output
raabs_pop_618_repo <- raabs_pop_618

raabs_pop_618_repo <- raabs_pop_618_repo %>% 
  select(-'areaname', -'mtot', -'ftot') 

raabs_pop_618_repo <- raabs_pop_618_repo %>% 
  pivot_longer(starts_with(c('m', 'f')),
               names_to = c('gender', 'ageStart'), 
               names_pattern = "(.)(..)",
               values_to = 'population') %>%
  mutate(ageEnd = 
           case_when(
             (ageStart==50) ~ 54, 
             (ageStart==55) ~ 59,
             (ageStart==60) ~ 64,
             (ageStart==65) ~ 69,
             (ageStart==70) ~ 74,
             (ageStart==75) ~ 79,
             (ageStart==80) ~ as.numeric(NA)
           )
  ) %>% 
  relocate(ageEnd, .after = ageStart) %>% 
  mutate(gender= case_when(
    gender=="m" ~ "male",
    gender=="f" ~ "female"
  ))

write.csv(raabs_pop_618_repo, here('outputs', 'raabs_pop_618_repo.csv'), row.names = FALSE)

# Historic data sets using 6/12 threshold - can be integrated with RAAB7s/ can add rbind RAAB7 data to this
raabs_pop_612 <- read.csv(here('outputs', 'raab6_pop_data.csv'))

raabs_pop_612_repo <- raabs_pop_612

raabs_pop_612_repo <- raabs_pop_612_repo %>% 
  select(-'areaname', -'mtot', -'ftot') 

raabs_pop_612_repo <- raabs_pop_612_repo %>% 
  pivot_longer(starts_with(c('m', 'f')),
               names_to = c('gender', 'ageStart'), 
               names_pattern = "(.)(..)",
               values_to = 'population') %>%
  mutate(ageEnd = 
           case_when(
             (ageStart==50) ~ 54, 
             (ageStart==55) ~ 59,
             (ageStart==60) ~ 64,
             (ageStart==65) ~ 69,
             (ageStart==70) ~ 74,
             (ageStart==75) ~ 79,
             (ageStart==80) ~ as.numeric(NA)
           )
  ) %>% 
  relocate(ageEnd, .after = ageStart) %>% 
  mutate(gender= case_when(
    gender=="m" ~ "male",
    gender=="f" ~ "female"
  ))

# RAAB7 already in this long format
raab7pva_pop_data <- read.csv(here('outputs', 'raab7pva_pop_data.csv'))

raabs_pop_612_repo <- rbind(raabs_pop_612_repo, raab7pva_pop_data)

write.csv(raabs_pop_612_repo, here('outputs', 'raabs_pop_612_repo.csv'), row.names = FALSE)
