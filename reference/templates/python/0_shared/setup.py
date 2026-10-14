# setup.py -----------------------------------------------------------------
# Runs first, from the main file or from any stage script run on its own
# (each script calls runpy.run_path on this file and reads the dictionary it
# returns). Names every folder of the pipeline and holds the helper functions
# every stage uses.
# Reads: config_local.py, only if this project has one. Writes: nothing.

import runpy
from pathlib import Path


# Folders of the pipeline --------------------------------------------------
# analysis/ is found from this file's own place, so every path is the same on
# every laptop and wherever Python was started.
ANALYSIS = Path(__file__).resolve().parents[1]
RAW_DATA_DIR = ANALYSIS / "1_raw_data"
INTERIM_DATA_DIR = ANALYSIS / "2_interim_data_steps"
CLEAN_DATA_DIR = ANALYSIS / "3_clean_data"
TABLES_DIR = ANALYSIS / "5_tables"
PLOTS_DIR = ANALYSIS / "6_plots"
OBJECTS_DIR = ANALYSIS / "7_objects"


# This laptop's paths, only if the project has a config_local.py ----------
# Read by its path, never by import; an error in the file stops the run.
config_local = {}
if (ANALYSIS / "config_local.py").exists():
    config_local = runpy.run_path(str(ANALYSIS / "config_local.py"))


# Files the stages hand on to each other -----------------------------------
# Each stage writes one file and the next stage reads it, so a stage also
# runs on its own once the stages before it have run once.
LOADED_DATA_FILE = INTERIM_DATA_DIR / "loaded_data.pkl"
CLEAN_DATA_FILE = CLEAN_DATA_DIR / "clean_data.pkl"
RESULTS_FILE = OBJECTS_DIR / "results.pkl"


# Helper functions ---------------------------------------------------------
def require_input(path, made_by):
    """Stop with a message naming the script to run first."""
    if not Path(path).exists():
        raise SystemExit(
            f"{Path(path).name} is missing. Run {made_by} first "
            "(or the main file, which runs every stage in order)."
        )
    return Path(path)


def ensure_dir(path):
    """Make sure an output folder exists before a stage writes to it."""
    Path(path).mkdir(parents=True, exist_ok=True)
    return Path(path)
