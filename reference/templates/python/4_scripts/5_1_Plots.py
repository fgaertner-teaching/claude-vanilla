# 5_1_Plots.py -------------------------------------------------------------
# Stage 5, plots: draws the figures for the paper.
# Reads:  3_clean_data/clean_data.pkl (from 2_1_Clean_Data.py)
# Writes: 6_plots/fig_distribution.pdf
# claude/output_spec.md says which figure goes where in the paper.

import runpy
from pathlib import Path

import matplotlib
matplotlib.use("Agg")  # draw to files only, no window
import matplotlib.pyplot as plt
import pandas as pd


# Setup ---------------------------------------------------------------------
ANALYSIS = Path(__file__).resolve().parents[1]
setup = runpy.run_path(str(ANALYSIS / "0_shared" / "setup.py"))


# Read the clean data ------------------------------------------------------
setup["require_input"](setup["CLEAN_DATA_FILE"], "4_scripts/2_1_Clean_Data.py")
clean_data = pd.read_pickle(setup["CLEAN_DATA_FILE"])


# Pick the variable to plot ------------------------------------------------
# The placeholder figure is the distribution of the first numeric column;
# the figures from claude/output_spec.md replace it.
numeric_columns = list(clean_data.select_dtypes("number").columns)
if not numeric_columns:
    raise SystemExit(
        "The clean data has no numeric column to plot. "
        "Adapt 4_scripts/5_1_Plots.py to your data."
    )
plot_variable = numeric_columns[0]


# Draw and save the figure -------------------------------------------------
setup["ensure_dir"](setup["PLOTS_DIR"])
plot_file = setup["PLOTS_DIR"] / "fig_distribution.pdf"
figure, axis = plt.subplots(figsize=(6, 4))
plot_values = clean_data[plot_variable]
plot_values = plot_values[plot_values.abs() != float("inf")].dropna()  # hist needs finite values
axis.hist(plot_values, color="0.8", edgecolor="white")
axis.set_xlabel(plot_variable)
figure.tight_layout()
figure.savefig(plot_file)
plt.close(figure)
print(f"Figure written: 6_plots/{plot_file.name}")
