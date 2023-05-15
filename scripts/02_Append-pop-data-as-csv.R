# Script to take historic survey population age-sex data extracted from foxpro format to excel sheets and append all survey data by RAAB version

library(here)
library(tidyverse)
library(readxl)

# Renaming variables (RACSS-REC files have different col name to other three versions) 
new = c('raab_id', 'areaname', 
        'm50', 'm55', 'm60', 'm65', 'm70', 'm75', 'm80plus', 'mtot',
        'f50', 'f55', 'f60', 'f65', 'f70', 'f75', 'f80plus', 'ftot')

old = c('raab_id', 'AREANAME,C,20', 
        'M50,N,7,0', 'M55,N,7,0', 'M60,N,7,0', 'M65,N,7,0', 'M70,N,7,0', 'M75,N,7,0', 'M80,N,7,0', 'MTOT,N,8,0',
        'F50,N,7,0', 'F55,N,7,0', 'F60,N,7,0', 'F65,N,7,0', 'F70,N,7,0', 'F75,N,7,0', 'F80,N,7,0', 'FTOT,N,8,0')

#Create and export a CSV file of all RAAB5 format RACSS surveys pop data to new dir
racss_pop_data <- list.files('/Users/lsh1604470/Dropbox/RAAB repository data extraction/Extracted RAAB Data/RACSS',
                             pattern='.+\\.xlsx$',
                             full.names=TRUE) %>%
  map_dfr(function(f) {
    read_excel(f, sheet=2) %>% 
      select(-`KNOWN,L`, -AREACODE)
  })

racss_pop_data <- racss_pop_data %>% rename_at(old, ~ new)

write.csv(racss_pop_data, here('outputs', 'racss_pop_data.csv'), row.names = FALSE)

#Create and export a CSV file of all RAAB5 surveys pop data to new dir
raab5_pop_data <- list.files('/Users/lsh1604470/Dropbox/RAAB repository data extraction/Extracted RAAB Data/RAAB5',
                             pattern='.+\\.xlsx$',
                             full.names=TRUE) %>%
  map_dfr(function(f) {
    read_excel(f, sheet=2) %>% 
      select(-`KNOWN,L`, -AREACODE)
  })

# Chitrakoot - five rows with very small pop counts - have asked Hans, kept small numbers and collapsed to single row
# Sudan Northern - two rows equivalent pop data ('Northern' and 'NORTHERNSTATE') for same survey - deleted later  
# Pop data from Mansur added to Saudi Arabia, Taif
# Duplicate row of pop data deleted from a China survey

raab5_pop_data <- raab5_pop_data %>% rename_at(old, ~ new)

write.csv(raab5_pop_data, here('outputs', 'raab5_pop_data.csv'), row.names = FALSE)

#Create and export a CSV file of all RAAB6 surveys pop data to new dir 
raab6_pop_data <- list.files('/Users/lsh1604470/Dropbox/RAAB repository data extraction/Extracted RAAB Data/RAAB6',
                             pattern='.+\\.xlsx$',
                             full.names=TRUE) %>%
  map_dfr(function(f) {
    read_excel(f, sheet=2) %>% 
      select(-`KNOWN,L`, -AREACODE)
  })

raab6_pop_data <- raab6_pop_data %>% rename_at(old, ~ new)

write.csv(raab6_pop_data, here('outputs', 'raab6_pop_data.csv'), row.names = FALSE)
