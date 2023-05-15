# Reformat raab_id variable to align with raab_log of metadata

# install.packages("mgsub")
library(mgsub)

raabs_612 <- read.csv(here('outputs', 'raabs_612.csv'))
raabs_618 <- read.csv(here('outputs', 'raabs_618.csv'))
raabs_pop_612 <- read.csv(here('outputs', 'raabs_pop_612.csv'))
raabs_pop_618 <- read.csv(here('outputs', 'raabs_pop_618.csv'))
raabs_pop_612_repo <- read.csv(here('outputs', 'raabs_pop_612_repo.csv'))
raabs_pop_618_repo <- read.csv(here('outputs', 'raabs_pop_618_repo.csv'))


for (df in c("raabs_612", "raabs_618", "raabs_pop_612", "raabs_pop_618", "raabs_pop_612_repo", "raabs_pop_618_repo"))

{
  assign(df, transform(get(df), raab_id = gsub(",", "", mgsub(raab_id, c("\\..$", "\\.$", "\\.", "\\ ", "\\'"), c("","", "_", "-", "")))))
  assign(df, transform(get(df), raab_id = strtrim(raab_id, 50)))

}

# write csv to save with new raab_ids
data.frames <- list(raabs_612, raabs_618, raabs_pop_612, raabs_pop_618, raabs_pop_612_repo, raabs_pop_618_repo)
names(data.frames) <- c("raabs_612", "raabs_618", "raabs_pop_612", "raabs_pop_618", "raabs_pop_612_repo", "raabs_pop_618_repo")

lapply(names(data.frames), function(i) {
  write.csv(data.frames[[i]], file=here('outputs', paste0(i, ".csv")), row.names = FALSE)
  })

# Loop through the data frame names
# for (df in c("raabs_612", "raabs_618", "raabs_pop_612", "raabs_pop_618", "raabs_pop_612_repo", "raabs_pop_618_repo")) {
#   
#   # Get the data frame
#   df_data <- get(df)
#   
#   # Transform the raab_id column
#   raab_id <- gsub(",", "", mgsub(df_data$raab_id, c("\\..$", "\\.$", "\\.", "\\ ", "\\'"), c("","", "_", "-", "")))
#   raab_id <- strtrim(raab_id, 50)
#   
#   # Assign the transformed data frame to the original name
#   assign(df, transform(df_data, raab_id = raab_id))
#   
#   # Write the transformed data frame to a CSV file
#   write.csv(get(df), file = here('outputs', paste0(df, ".csv")), row.names = FALSE)
#   
# }
