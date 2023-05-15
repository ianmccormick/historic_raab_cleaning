# List of all historic RAAB data transforming steps

library(tidyverse)
library(here)

# Append raw RAAB survey datasets
source(here('scripts', '01_Append-excels-as-csv_v4.R'))
# Append raw RAAB pop datasets
source(here('scripts', '02_Append-pop-data-as-csv_v2.R'))

# Standardise DR variable responses across historic datasets with and without DR module
source(here('scripts', '03_Standardise-dr-responses.R'))

# Rename variables to align with RAAB7 dataset
source(here('scripts', '04_Rename-vars_v3.R'))

# Relabel all variable options to RAAB7 strings and logMAR values
source(here('scripts', '05_Relabel-factors_v6.R'))

# Run a script that filters a Peek database export to the PVA RAAB7s and reorganises vars (survey and pop data)
source(here('scripts', '06_raab7-pva.R'))

# Merge RACSS and RAAB5 survey datasets to create a 6/18 threshold dataset and merge RAAB6 and PVA RAAB7 as the 6/12 threshold survey dataset
source(here('scripts', '07_Merge-datasets_v1.R'))
# Merge RACSS and RAAB5 pop datasets to create a 6/18 threshold pop dataset and merge RAAB6 and PVA RAAB7 as the 6/12 threshold pop dataset
source(here('scripts', '08_Merge-pop-datasets_v1.R'))

# Reformat the raab_id variable to align with historic RAAB metadata file (raab-log)
source(here('scripts', '09_Reformat-raab-id-var.R'))

# Data cleaning steps (for missing values from RAAB7 and Armenia)
source(here('scripts', '10_Data-cleaning_v1.R'))

