# 3_1_Analysis.R -----------------------------------------------------------
# Stage 3, analyse: computes the results from the clean data.
# Reads:  3_clean_data/clean_data.rds (from 2_1_Clean_Data.R)
# Writes: 7_r_objects/results.rds
# The placeholder result is a description of every numeric column; the
# models from claude/analysis_plan.md replace it.


# Setup, when this script runs on its own ----------------------------------
if (!exists("require_input")) {
  if (!file.exists(here::here("0_shared", "0_Setup.R"))) {
    stop("Start R in the analysis/ folder (or open it in Positron or RStudio), ",
         "then run this again.", call. = FALSE)
  }
  source(here::here("0_shared", "0_Setup.R"))
}


# Read the clean data ------------------------------------------------------
require_input(clean_data_file, "4_scripts/2_1_Clean_Data.R")
clean_data <- readRDS(clean_data_file)


# Describe every numeric column --------------------------------------------
numeric_columns <- names(clean_data)[vapply(clean_data, is.numeric, logical(1))]
if (length(numeric_columns) == 0) {
  stop("The clean data has no numeric column to describe. Adapt ",
       "4_scripts/3_1_Analysis.R to your data.", call. = FALSE)
}
descriptives <- data.frame(
  variable = numeric_columns,
  n        = vapply(clean_data[numeric_columns], function(x) sum(!is.na(x)), numeric(1)),
  mean     = vapply(clean_data[numeric_columns], mean, numeric(1), na.rm = TRUE),
  sd       = vapply(clean_data[numeric_columns], sd, numeric(1), na.rm = TRUE),
  min      = vapply(clean_data[numeric_columns], min, numeric(1), na.rm = TRUE),
  max      = vapply(clean_data[numeric_columns], max, numeric(1), na.rm = TRUE),
  row.names = NULL
)


# Save the results ---------------------------------------------------------
results <- list(descriptives = descriptives)
ensure_dir(objects_dir)
saveRDS(results, results_file)
message("Results: ", length(numeric_columns), " numeric columns described.")
