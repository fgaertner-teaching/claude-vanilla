# Data_Analysis_Main_File_OPEN_ME_FIRST.py ---------------------------------
#
# Project: [PROJECT NAME]
# [One-sentence description of the project.]
#
# This file runs every stage of the analysis pipeline, in order. Later stages
# read what earlier ones wrote, so after a change, run this file again rather
# than only the script you edited. Which script does what:
# claude/pipeline_map.md. Conventions for Claude Code: CLAUDE.md.
#
# How to get started (first-time setup):
#   1. Install the project's packages, from the project root: uv sync
#   2. Copy the raw data into analysis/1_raw_data/ (CLAUDE.md § Where things
#      are says where the original is); the scripts read that copy. Only if
#      CLAUDE.md names a config_local.py: write it in analysis/ with this
#      laptop's paths. Git leaves it out.
#   3. Run this file, from the project root:
#        uv run python analysis/Data_Analysis_Main_File_OPEN_ME_FIRST.py
#
# Each stage reads its input from a file and writes its output to a file, so a
# single stage also runs on its own (uv run python analysis/4_scripts/<script>),
# and the tables and plots can be redrawn from the saved objects in 7_objects/
# without running the analysis again.

import runpy
from pathlib import Path


# Folders -------------------------------------------------------------------
# analysis/ is this file's own folder, wherever Python was started.
ANALYSIS = Path(__file__).resolve().parent
SCRIPTS = ANALYSIS / "4_scripts"


# Global setup --------------------------------------------------------------
# Every stage runs the setup itself too; running it here first stops the
# pipeline before any stage if the setup has an error.
runpy.run_path(str(ANALYSIS / "0_shared" / "setup.py"))


# The stages, in order ------------------------------------------------------
STAGES = [
    "1_1_Load_Data.py",   # 1_raw_data/            -> 2_interim_data_steps/
    "2_1_Clean_Data.py",  # 2_interim_data_steps/  -> 3_clean_data/
    "3_1_Analysis.py",    # 3_clean_data/          -> 7_objects/
    "4_1_Tables.py",      # 7_objects/             -> 5_tables/
    "5_1_Plots.py",       # 3_clean_data/          -> 6_plots/
]

for stage in STAGES:
    print(f"--- {stage}")
    runpy.run_path(str(SCRIPTS / stage), run_name="__main__")
print("--- Pipeline finished.")
