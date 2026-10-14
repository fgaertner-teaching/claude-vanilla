# 0_Setup.R --------------------------------------------------------------
# Runs first, from the main file or from any stage script run on its own.
# Loads the libraries, names every folder of the pipeline, and holds the
# helper functions every stage uses.
# Reads: config_local.R, only if this project has one. Writes: nothing.


# Libraries ----------------------------------------------------------------
# here::here() finds analysis/ (the folder holding the .here file) from any
# of its subfolders, so every path below is the same on every laptop.
library(here)
if (!file.exists(here::here(".here"))) {
  stop("here::here() points at ", here::here(), ", not at analysis/. Start R ",
       "in the analysis/ folder (or open it in Positron or RStudio), then run ",
       "this again.", call. = FALSE)
}


# This laptop's paths, only if the project has a config_local.R -----------
if (file.exists(here::here("config_local.R"))) source(here::here("config_local.R"))


# Folders of the pipeline --------------------------------------------------
raw_data_dir     <- here::here("1_raw_data")
interim_data_dir <- here::here("2_interim_data_steps")
clean_data_dir   <- here::here("3_clean_data")
tables_dir       <- here::here("5_tables")
plots_dir        <- here::here("6_plots")
objects_dir      <- here::here("7_r_objects")


# Files the stages hand on to each other -----------------------------------
# Each stage writes one file and the next stage reads it, so a stage also
# runs on its own once the stages before it have run once.
loaded_data_file <- file.path(interim_data_dir, "loaded_data.rds")
clean_data_file  <- file.path(clean_data_dir, "clean_data.rds")
results_file     <- file.path(objects_dir, "results.rds")


# Helper functions ---------------------------------------------------------
# Stop with a message that names the script to run first, instead of an
# R error about a missing file further down.
require_input <- function(path, made_by) {
  if (!file.exists(path)) {
    stop(basename(path), " is missing. Run ", made_by,
         " first (or the main file, which runs every stage in order).",
         call. = FALSE)
  }
  invisible(path)
}

# Make sure an output folder exists before a stage writes to it.
ensure_dir <- function(path) {
  dir.create(path, showWarnings = FALSE, recursive = TRUE)
  invisible(path)
}
