# ==============================================================================
# Data_Analysis_Main_File_OPEN_ME_FIRST.R
# ==============================================================================
#
# Project: [PROJECT NAME]
# [One-sentence description of the project.]
#
# This file is the central hub of the analysis pipeline. It calls each script
# in the intended order. Later scripts depend on earlier ones, so always run
# this file top-to-bottom (or source the scripts in the order shown here).
#
# For a structured overview of all scripts, what each stage does, and how they
# depend on each other, see: claude/pipeline_map.md
#
# For project configuration and conventions used by Claude Code, see: CLAUDE.md
#
#
# --- How to get started (first-time setup) -----------------------------------
#
# 1. Open the analysis/ folder (the one holding renv.lock and this file) in
#    Positron or RStudio, or start R there. R switches on the project's package
#    library (renv) only for the folder it starts in; opened anywhere else, the
#    pipeline would run on whatever packages are installed, and this file stops.
#
# 2. Install the renv package if you don't have it yet:
#      install.packages("renv")
#
# 3. Restore the project's package library, still in analysis/. This installs
#    every R package at the exact version used in this project, so your results
#    match ours:
#      renv::restore()
#
# 4. Copy the raw data into 1_raw_data/ (CLAUDE.md § Where things are says
#    where the original is); the scripts read that copy. Only if CLAUDE.md
#    names a config_local.R: write it in analysis/ with this laptop's paths.
#    Each laptop keeps its own; git leaves it out. With co-authors,
#    COAUTHOR_GUIDE.md has a template.
#
# 5. Run this file top-to-bottom. That's it!
#
#
# --- How the pipeline works --------------------------------------------------
#
# All paths in the pipeline are relative to analysis/. The check below stops the
# run if R was not started there.
#
# The pipeline has two modes:
#
#   RECOMPUTE (default): Runs every script from raw data through to final
#     tables and plots. This is the full replication path.
#
#   LOAD OBJECTS: Skips the computation and loads pre-saved R objects instead.
#     This is useful when you want to inspect results without waiting for the
#     full pipeline to run, or when raw data is not available (e.g. restricted
#     micro-data not included in the replication package).
#
# By default, the pipeline recomputes everything. The "Save Objects" lines are
# commented out to prevent accidentally overwriting the original objects. The
# "Load Objects" lines are also commented out because the loaded objects use the
# same names as the computed ones — uncommenting both would cause conflicts.
#
# To switch to load-objects mode: comment out the source() calls for a stage
# and uncomment the corresponding load() block below it.
#
# ==============================================================================


# Working directory and package check -----------------------------------------
# R must have started in analysis/: only there does renv's .Rprofile switch the
# project's package library on, and a setwd() later does not. Two start places
# are handled: analysis/ itself, and a subfolder of it left over from a crashed
# run in the same session (renv is already on then). In analysis/ itself with
# the setup file missing, the message says so instead of naming the folder.
if (!file.exists("0_shared/0_Setup.R")) {
  if (!file.exists("analysis/0_shared/0_Setup.R") &&
      requireNamespace("here", quietly = TRUE) &&
      file.exists(file.path(here::here(), "0_shared", "0_Setup.R"))) {
    setwd(here::here())  # In a subfolder of analysis/; here::here() finds it
  } else if (file.exists("Data_Analysis_Main_File_OPEN_ME_FIRST.R")) {
    stop("0_shared/0_Setup.R is missing. R is in the analysis/ folder, but the ",
         "setup file this file runs first is not there.")
  } else {
    stop("Start R in the analysis/ folder (the one holding renv.lock), then run ",
         "this file again. From anywhere else the project's packages are not used.")
  }
}
# renv must be loaded AND active for this folder: loading renv elsewhere (say,
# renv::status() run from the repository root) loads it without switching this
# project's library on. renv names the active project in RENV_PROJECT.
if (file.exists("renv.lock")) {
  renv_project <- Sys.getenv("RENV_PROJECT")
  same_folder <- function(a, b) {
    identical(tolower(normalizePath(a, "/", mustWork = FALSE)),
              tolower(normalizePath(b, "/", mustWork = FALSE)))
  }
  if (!isNamespaceLoaded("renv") ||
      (nzchar(renv_project) && !same_folder(renv_project, getwd()))) {
    stop("renv is not active for this folder: R was started outside analysis/, or ",
         "with --vanilla. Start R in analysis/ without --vanilla.")
  }
}


# Global Setup ----------------------------------------------------------------
# Loads global libraries, shared helper functions, and (if applicable) the
# Overleaf/Dropbox sync pipeline. Must run before anything else.
source("0_shared/0_Setup.R")


# =============================================================================
# [STUDY NAME]
# =============================================================================
# [TEMPLATE NOTE — delete this block after filling in]
#
# For a SINGLE-STUDY project, source scripts directly:
#
#   source("4_scripts/1_0_Load_Data_Setup.R")
#   source("4_scripts/1_1_Load_Data.R")
#   source("4_scripts/2_0_Clean_Data_Setup.R")
#   source("4_scripts/2_1_Clean_Data.R")
#   source("4_scripts/2_2_Clean_Data_Save_Objects.R")
#   source("4_scripts/2_3_EDA_Plots.R")
#   source("4_scripts/3_0_Results_Setup.R")
#   source("4_scripts/3_1_Results_Descriptives.R")
#   # ... etc.
#
#   # --- Load pre-saved objects (alternative to recomputing) ---
#   # load("7_r_objects/data_objects.RData")
#   # load("7_r_objects/results_objects.RData")
#   # load("7_r_objects/table_objects.RData")
#   # load("7_r_objects/plot_objects.RData")
#
# For a MULTI-STUDY project, each study has its own run_*.R entry point:
#
#   source("study_1/pilot/run_pilot.R")
#   source("study_1/main/run_main.R")
#   source("study_2/main/run_main.R")
#   source("cross_study/4_scripts/1_cross_study_analysis.R")
#
#   # --- Load pre-saved objects (alternative to recomputing) ---
#   # load("study_1/pilot/7_r_objects/data_objects.RData")
#   # load("study_1/pilot/7_r_objects/results_objects.RData")
#   # load("study_1/main/7_r_objects/data_objects.RData")
#   # ... etc.
#
# Delete this template note once the pipeline is set up.
# =============================================================================
