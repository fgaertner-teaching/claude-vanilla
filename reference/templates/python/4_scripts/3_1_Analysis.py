# 3_1_Analysis.py ----------------------------------------------------------
# Stage 3, analyse: computes the results from the clean data.
# Reads:  3_clean_data/clean_data.pkl (from 2_1_Clean_Data.py)
# Writes: 7_objects/results.pkl
# The placeholder result is a description of every numeric column; the
# models from claude/analysis_plan.md replace it.

import pickle
import runpy
from pathlib import Path

import pandas as pd


# Setup ---------------------------------------------------------------------
ANALYSIS = Path(__file__).resolve().parents[1]
setup = runpy.run_path(str(ANALYSIS / "0_shared" / "setup.py"))


# Read the clean data ------------------------------------------------------
setup["require_input"](setup["CLEAN_DATA_FILE"], "4_scripts/2_1_Clean_Data.py")
clean_data = pd.read_pickle(setup["CLEAN_DATA_FILE"])


# Describe every numeric column --------------------------------------------
numeric_data = clean_data.select_dtypes("number")
if numeric_data.shape[1] == 0:
    raise SystemExit(
        "The clean data has no numeric column to describe. "
        "Adapt 4_scripts/3_1_Analysis.py to your data."
    )
descriptives = pd.DataFrame({
    "variable": numeric_data.columns,
    "n": numeric_data.count().to_numpy(),
    "mean": numeric_data.mean().to_numpy(),
    "sd": numeric_data.std().to_numpy(),
    "min": numeric_data.min().to_numpy(),
    "max": numeric_data.max().to_numpy(),
})


# Save the results ---------------------------------------------------------
results = {"descriptives": descriptives}
setup["ensure_dir"](setup["OBJECTS_DIR"])
with open(setup["RESULTS_FILE"], "wb") as results_handle:
    pickle.dump(results, results_handle)
print(f"Results: {numeric_data.shape[1]} numeric columns described.")
