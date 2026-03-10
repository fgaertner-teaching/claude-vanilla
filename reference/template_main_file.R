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
# 1. Open this project in Positron or RStudio. We recommend opening from the
#    repository root (the top-level folder containing analysis/, claude/, etc.)
#    — the working directory correction below will handle the rest.
#
# 2. Install the renv package if you don't have it yet:
#      install.packages("renv")
#
# 3. Restore the project's package library. This installs every R package at
#    the exact version used in this project, so your results match ours:
#      renv::restore()
#
# 4. If a file called config_local.R exists in analysis/, it contains
#    machine-specific settings (e.g. your local Dropbox path). Each collaborator
#    maintains their own copy — it is never committed to git. If this is a fresh
#    clone, ask your co-author for a template or check COAUTHOR_GUIDE.md.
#
# 5. Run this file top-to-bottom. That's it!
#
#
# --- How the pipeline works --------------------------------------------------
#
# All paths in the pipeline are relative to analysis/. The working directory
# correction below ensures this is true regardless of where you opened the
# project.
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


# Working directory correction ------------------------------------------------
# Handles three start locations: analysis/ (correct), repo root, or a
# subdirectory of analysis/ left over from a crashed pipeline run.
if (file.exists("0_shared/0_Setup.R")) {
  # Already in analysis/ — nothing to do
} else if (file.exists("analysis/0_shared/0_Setup.R")) {
  setwd("analysis")  # Started from repo root
} else if (file.exists(file.path(here::here(), "0_shared", "0_Setup.R"))) {
  setwd(here::here())  # Started from a subdirectory; here anchors correctly
} else {
  stop("Cannot locate analysis/0_shared/0_Setup.R. ",
       "Please open Positron from the repo root ",
       "or set WD to analysis/ manually.")
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
