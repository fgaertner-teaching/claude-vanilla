# 1_1_Load_Data.py ---------------------------------------------------------
# Stage 1, load: reads the data as received and saves it unchanged.
# Reads:  1_raw_data/<your file>.csv (the copy; the original stays where it is)
# Writes: 2_interim_data_steps/loaded_data.pkl
# Claude adapts this script to the real data (file name, format, several files).

import runpy
from pathlib import Path

import pandas as pd


# Setup ---------------------------------------------------------------------
ANALYSIS = Path(__file__).resolve().parents[1]
setup = runpy.run_path(str(ANALYSIS / "0_shared" / "setup.py"))
raw_data_dir = setup["RAW_DATA_DIR"]


# Find the raw data file ---------------------------------------------------
# Set RAW_DATA_NAME to the file's name once the data is in; left empty, the
# script takes the one CSV file in 1_raw_data/. Hidden files (.gitkeep, a
# Mac's .DS_Store) do not count.
RAW_DATA_NAME = ""

raw_files = sorted(
    p.name for p in raw_data_dir.glob("*")
    if not p.name.startswith(".") and p.name != "README.md"
) if raw_data_dir.exists() else []
if not raw_files:
    raise SystemExit(
        "1_raw_data/ is empty: copy your data into 1_raw_data/ (keep the "
        "original where it is), then run this again."
    )
if not RAW_DATA_NAME:
    csv_files = [name for name in raw_files if name.lower().endswith(".csv")]
    if len(csv_files) != 1:
        raise SystemExit(
            f"1_raw_data/ holds {len(csv_files)} CSV files ({', '.join(raw_files)}). "
            "Set RAW_DATA_NAME in 4_scripts/1_1_Load_Data.py to the file to read, "
            "or adapt the script to your format."
        )
    RAW_DATA_NAME = csv_files[0]
raw_data_path = raw_data_dir / RAW_DATA_NAME
if not raw_data_path.exists():
    raise SystemExit(
        f"{RAW_DATA_NAME} is not in 1_raw_data/. Copy it there, or correct "
        "RAW_DATA_NAME in 4_scripts/1_1_Load_Data.py."
    )


# Read it, unchanged -------------------------------------------------------
# A CSV from German Excel separates columns with ";" and writes decimals with
# ","; the first line says which kind this file is.
try:
    # utf-8-sig: Excel's "CSV UTF-8" starts with a BOM, read as plain UTF-8 too
    with open(raw_data_path, encoding="utf-8-sig") as raw_handle:
        first_line = raw_handle.readline()
    semicolon_csv = first_line.count(";") > first_line.count(",")
    loaded_data = pd.read_csv(
        raw_data_path, encoding="utf-8-sig",
        sep=";" if semicolon_csv else ",", decimal="," if semicolon_csv else ".",
    )
except UnicodeDecodeError as error:
    raise SystemExit(
        f"Could not read {RAW_DATA_NAME} as UTF-8 ({error}).\nIf it has umlauts or "
        'accents, save it as UTF-8 (Excel: Save as, "CSV UTF-8"), or tell Claude '
        "the file's encoding."
    )
assert len(loaded_data) > 0, "the raw data file has no rows"
print(f"Loaded {RAW_DATA_NAME}: {len(loaded_data)} rows, {loaded_data.shape[1]} columns"
      + (" (semicolon-separated, decimal comma)." if semicolon_csv else "."))


# Save it for the next stage -----------------------------------------------
setup["ensure_dir"](setup["INTERIM_DATA_DIR"])
loaded_data.to_pickle(setup["LOADED_DATA_FILE"])
