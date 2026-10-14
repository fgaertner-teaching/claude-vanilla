# 2_1_Clean_Data.R ---------------------------------------------------------
# Stage 2, clean: turns the loaded data into the analysis-ready dataset.
# Reads:  2_interim_data_steps/loaded_data.rds (from 1_1_Load_Data.R)
# Writes: 3_clean_data/clean_data.rds
# Every change to the data happens here, in code, never by hand in the file.


# Setup, when this script runs on its own ----------------------------------
if (!exists("require_input")) {
  # Without here, R was started outside analysis/, where renv switches the
  # project's packages on; outside analysis/, the setup file is not found.
  if (!requireNamespace("here", quietly = TRUE) ||
      !file.exists(here::here("0_shared", "0_Setup.R"))) {
    stop("Start R in the analysis/ folder (or open it in Positron or RStudio), ",
         "then run this again.", call. = FALSE)
  }
  source(here::here("0_shared", "0_Setup.R"))
}


# Read the loaded data -----------------------------------------------------
require_input(loaded_data_file, "4_scripts/1_1_Load_Data.R")
clean_data <- readRDS(loaded_data_file)
rows_loaded <- nrow(clean_data)


# Clean the column names: lower case, words joined by "_" ------------------
# \p{L} keeps letters such as ä and ß ("Größe" becomes "größe").
names(clean_data) <- tolower(gsub("[^\\p{L}\\p{N}]+", "_", trimws(names(clean_data)),
                                  perl = TRUE))
names(clean_data) <- gsub("^_|_$", "", names(clean_data))
# A header with nothing left (an unnamed row-number column, "%") gets one.
unnamed <- !nzchar(names(clean_data))
names(clean_data)[unnamed] <- paste0("column_", which(unnamed))
stopifnot("two columns have the same name after cleaning" =
            !anyDuplicated(names(clean_data)))


# Drop rows that are empty in every column ---------------------------------
all_empty <- apply(is.na(clean_data) | clean_data == "", 1, all)
clean_data <- clean_data[!all_empty, , drop = FALSE]
message("Clean data: ", nrow(clean_data), " of ", rows_loaded,
        " rows kept (", sum(all_empty), " empty rows dropped).")
stopifnot("no rows left after cleaning" = nrow(clean_data) > 0)


# Save the clean data ------------------------------------------------------
ensure_dir(clean_data_dir)
saveRDS(clean_data, clean_data_file)
