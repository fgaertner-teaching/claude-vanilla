# 4_1_Tables.py ------------------------------------------------------------
# Stage 4, tables: writes the results as tables for the paper.
# Reads:  7_objects/results.pkl (from 3_1_Analysis.py)
# Writes: 5_tables/tab_descriptives.tex
# claude/output_spec.md says which table goes where in the paper.

import pickle
import re
import runpy
from pathlib import Path


# Setup ---------------------------------------------------------------------
ANALYSIS = Path(__file__).resolve().parents[1]
setup = runpy.run_path(str(ANALYSIS / "0_shared" / "setup.py"))


# Read the results ---------------------------------------------------------
setup["require_input"](setup["RESULTS_FILE"], "4_scripts/3_1_Analysis.py")
with open(setup["RESULTS_FILE"], "rb") as results_handle:
    results = pickle.load(results_handle)
descriptives = results["descriptives"]


# Build a LaTeX table of the descriptives ----------------------------------
# Plain LaTeX, so the paper needs no extra package.
def latex_escape(text):
    return re.sub(r"([_%&#$])", r"\\\1", str(text))


def format_number(value):
    return f"{value:,.2f}"


table_rows = [
    f"{latex_escape(row.variable)} & {int(row.n)} & {format_number(row.mean)} & "
    f"{format_number(row.sd)} & {format_number(row.min)} & {format_number(row.max)} \\\\"
    for row in descriptives.itertuples()
]
table_lines = [
    r"\begin{tabular}{lrrrrr}",
    r"\hline",
    r"Variable & N & Mean & SD & Min & Max \\",
    r"\hline",
    *table_rows,
    r"\hline",
    r"\end{tabular}",
]


# Write the table ----------------------------------------------------------
setup["ensure_dir"](setup["TABLES_DIR"])
table_file = setup["TABLES_DIR"] / "tab_descriptives.tex"
with open(table_file, "w", encoding="utf-8", newline="\n") as table_handle:
    table_handle.write("\n".join(table_lines) + "\n")
print(f"Table written: 5_tables/{table_file.name}")
