# Merge RACSS and RAAB5 historic data sets as both examine VA to 6/18 (no analysis of 6/12 outcomes feasible)
# Merge RAAB6 and RAAB7pva historic data sets as both examine VA to 6/12 (no analysis of UCVA feasible)

library(tidyverse)
library(here)

# Historic data sets using 6/18 threshold - single use of separate version of code to generate summary tables?
racss_sur_data_newvarslevs <- read.csv(here('outputs', 'racss_sur_data_newvarslevs.csv'))
raab5_sur_data_newvarslevs <- read.csv(here('outputs', 'raab5_sur_data_newvarslevs.csv'))

raabs_618 <- rbind(racss_sur_data_newvarslevs, raab5_sur_data_newvarslevs)

write.csv(raabs_618, here('outputs', 'raabs_618.csv'), row.names = FALSE)

# Historic data sets using 6/12 threshold - can be integrated with PVA RAAB7s/ can add rbind PVA RAAB7 data to this
raabs_612 <- read.csv(here('outputs', 'raab6_sur_data_newvarslevs.csv'))
raab7pva_sur_data <- read.csv(here('outputs', 'raab7pva_sur_data.csv'))

raabs_612 <- rbind(raabs_612, raab7pva_sur_data)

write.csv(raabs_612, here('outputs', 'raabs_612.csv'), row.names = FALSE)