# 1_1_Load_Data.R ----------------------------------------------------------
# Stage 1, load: reads the data as received and saves it unchanged.
# Reads:  1_raw_data/<your file>.csv (the copy; the original stays where it is)
# Writes: 2_interim_data_steps/loaded_data.rds
# Claude adapts this script to the real data (file name, format, several files).


# Setup, when this script runs on its own ----------------------------------
if (!exists("require_input")) {
  if (!file.exists(here::here("0_shared", "0_Setup.R"))) {
    stop("Start R in the analysis/ folder (or open it in Positron or RStudio), ",
         "then run this again.", call. = FALSE)
  }
  source(here::here("0_shared", "0_Setup.R"))
}


# Find the raw data file ---------------------------------------------------
# Set raw_data_name to the file's name once the data is in; left empty, the
# script takes the one CSV file in 1_raw_data/.
raw_data_name <- ""

raw_files <- setdiff(list.files(raw_data_dir), "README.md")
if (length(raw_files) == 0) {
  stop("1_raw_data/ is empty: copy your data into 1_raw_data/ (keep the ",
       "original where it is), then run this again.", call. = FALSE)
}
if (raw_data_name == "") {
  csv_files <- raw_files[grepl("\\.csv$", raw_files, ignore.case = TRUE)]
  if (length(csv_files) != 1) {
    stop("1_raw_data/ holds ", length(csv_files), " CSV files (",
         paste(raw_files, collapse = ", "), "). Set raw_data_name in ",
         "4_scripts/1_1_Load_Data.R to the file to read, or adapt the script ",
         "to your format.", call. = FALSE)
  }
  raw_data_name <- csv_files
}
raw_data_path <- file.path(raw_data_dir, raw_data_name)
if (!file.exists(raw_data_path)) {
  stop(raw_data_name, " is not in 1_raw_data/. Copy it there, or correct ",
       "raw_data_name in 4_scripts/1_1_Load_Data.R.", call. = FALSE)
}


# Read it, unchanged -------------------------------------------------------
# A CSV from German Excel separates columns with ";" and writes decimals with
# ","; the first line says which kind this file is. Any warning while reading
# stops the run: R otherwise stops reading at the first character it cannot
# decode and carries on with the rows it has.
first_line <- readLines(raw_data_path, n = 1, warn = FALSE)
semicolon_csv <- lengths(regmatches(first_line, gregexpr(";", first_line))) >
                 lengths(regmatches(first_line, gregexpr(",", first_line)))
read_raw <- if (semicolon_csv) utils::read.csv2 else utils::read.csv
loaded_data <- withCallingHandlers(
  read_raw(raw_data_path, stringsAsFactors = FALSE, check.names = FALSE,
           fileEncoding = "UTF-8-BOM"),  # Excel's "CSV UTF-8" starts with a BOM
  warning = function(w) {
    stop("Could not read ", raw_data_name, " cleanly: ", conditionMessage(w),
         "\nIf it has umlauts or accents, save it as UTF-8 (Excel: Save as, ",
         "\"CSV UTF-8\"), or tell Claude the file's encoding.", call. = FALSE)
  }
)
stopifnot("the raw data file has no rows" = nrow(loaded_data) > 0)
message("Loaded ", raw_data_name, ": ", nrow(loaded_data), " rows, ",
        ncol(loaded_data), " columns",
        if (semicolon_csv) " (semicolon-separated, decimal comma)." else ".")


# Save it for the next stage -----------------------------------------------
ensure_dir(interim_data_dir)
saveRDS(loaded_data, loaded_data_file)
