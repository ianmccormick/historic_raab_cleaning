# Script to take historic survey data extracted from foxpro format to excel sheets and append all survey data by RAAB version

# Adding and moving variables to align all data sets with RAAB6 - except for RACSS REC files which are changed on 'rename vars' file

library(tidyverse)
library(readxl)
library(here)

#Create and export a CSV file of all RACSS surveys to new dir;  add bloodsugar2 var and move glassesn var to align with RAAB6 via anonymous function
racss_sur_data <- list.files('/Users/lsh1604470/Dropbox/RAAB repository data extraction/Extracted RAAB Data/RACSS',
                             pattern='.+\\.xlsx$',
                             full.names=TRUE) %>%
  map_dfr(function(f) {
    read_excel(f, sheet=1)
  })

write.csv(racss_sur_data, here('outputs', 'racss_sur_data.csv'), row.names = FALSE)

#Create and export a CSV file of all RAAB5 surveys to new dir; add bloodsugar2 var and move glassesn var to align with RAAB6 via anonymous function
raab5_sur_data <- list.files('/Users/lsh1604470/Dropbox/RAAB repository data extraction/Extracted RAAB Data/RAAB5',
                             pattern='.+\\.xlsx$',
                             full.names=TRUE) %>%
  map_dfr(function(f) {
    read_excel(f, sheet=1)
  })

write.csv(raab5_sur_data, here('outputs', 'raab5_sur_data.csv'), row.names = FALSE)

#Create and export a CSV file of all RAAB6 surveys to new dir (59 variables)
raab6_sur_data <- list.files('/Users/lsh1604470/Dropbox/RAAB repository data extraction/Extracted RAAB Data/RAAB6',
                             pattern='.+\\.xlsx$',
                             full.names=TRUE) %>%
  map_dfr(function(f) {
    read_excel(f, sheet=1)
  })

write.csv(raab6_sur_data, here('outputs', 'raab6_sur_data.csv'), row.names = FALSE)

#create lists of all raab_ids imported
# racss_ids <- as.data.frame(unique(racss_sur_data$raab_id))
# raab5_ids <- as.data.frame(unique(raab5_sur_data$raab_id))
# raab6_ids <- as.data.frame(unique(raab6_sur_data$raab_id))
