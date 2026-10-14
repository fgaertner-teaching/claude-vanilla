# 5_1_Plots.R --------------------------------------------------------------
# Stage 5, plots: draws the figures for the paper.
# Reads:  3_clean_data/clean_data.rds (from 2_1_Clean_Data.R)
# Writes: 6_plots/fig_distribution.pdf
# claude/output_spec.md says which figure goes where in the paper.


# Setup, when this script runs on its own ----------------------------------
if (!exists("require_input")) {
  # Without here, R was started outside analysis/, where renv switches the
  # project's packages on; outside analysis/, the setup file is not found.
  if (!requireNamespace("here", quietly = TRUE) ||
      !file.exists(here::here("0_shared", "0_Setup.R"))) {
    stop("Start R in the analysis/ folder (or open it in Positron or RStudio), ",
         "then run this again.", call. = FALSE)
  }
  source(here::here("0_shared", "0_Setup.R"))
}


# Read the clean data ------------------------------------------------------
require_input(clean_data_file, "4_scripts/2_1_Clean_Data.R")
clean_data <- readRDS(clean_data_file)


# Pick the variable to plot ------------------------------------------------
# The placeholder figure is the distribution of the first numeric column;
# the figures from claude/output_spec.md replace it.
numeric_columns <- names(clean_data)[vapply(clean_data, is.numeric, logical(1))]
if (length(numeric_columns) == 0) {
  stop("The clean data has no numeric column to plot. Adapt ",
       "4_scripts/5_1_Plots.R to your data.", call. = FALSE)
}
plot_variable <- numeric_columns[1]


# Draw and save the figure -------------------------------------------------
ensure_dir(plots_dir)
plot_file <- file.path(plots_dir, "fig_distribution.pdf")
pdf(plot_file, width = 6, height = 4)
plot_values <- clean_data[[plot_variable]]
hist(plot_values[is.finite(plot_values)], main = NULL, xlab = plot_variable,
     col = "grey80", border = "white")
invisible(dev.off())
message("Figure written: 6_plots/", basename(plot_file))
