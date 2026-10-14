# 2_1_Clean_Data.py --------------------------------------------------------
# Stage 2, clean: turns the loaded data into the analysis-ready dataset.
# Reads:  2_interim_data_steps/loaded_data.pkl (from 1_1_Load_Data.py)
# Writes: 3_clean_data/clean_data.pkl
# Every change to the data happens here, in code, never by hand in the file.

import runpy
from pathlib import Path

import pandas as pd


# Setup ---------------------------------------------------------------------
ANALYSIS = Path(__file__).resolve().parents[1]
setup = runpy.run_path(str(ANALYSIS / "0_shared" / "setup.py"))


# Read the loaded data -----------------------------------------------------
setup["require_input"](setup["LOADED_DATA_FILE"], "4_scripts/1_1_Load_Data.py")
clean_data = pd.read_pickle(setup["LOADED_DATA_FILE"])
rows_loaded = len(clean_data)


# Clean the column names: lower case, words joined by "_" ------------------
clean_data.columns = (
    clean_data.columns.astype(str).str.strip()
    .str.replace(r"[\W_]+", "_", regex=True)  # \W keeps letters such as ä and ß
    .str.strip("_").str.lower()
)
# A header with nothing left (an unnamed index column, "%") gets one.
clean_data.columns = [
    name if name else f"column_{position}"
    for position, name in enumerate(clean_data.columns, start=1)
]
assert not clean_data.columns.duplicated().any(), \
    "two columns have the same name after cleaning"


# Drop rows that are empty in every column ---------------------------------
clean_data = clean_data.replace("", pd.NA).dropna(how="all")
print(f"Clean data: {len(clean_data)} of {rows_loaded} rows kept "
      f"({rows_loaded - len(clean_data)} empty rows dropped).")
assert len(clean_data) > 0, "no rows left after cleaning"


# Save the clean data ------------------------------------------------------
setup["ensure_dir"](setup["CLEAN_DATA_DIR"])
clean_data.to_pickle(setup["CLEAN_DATA_FILE"])
