# 4_1_Tables.R -------------------------------------------------------------
# Stage 4, tables: writes the results as tables for the paper.
# Reads:  7_r_objects/results.rds (from 3_1_Analysis.R)
# Writes: 5_tables/tab_descriptives.tex
# claude/output_spec.md says which table goes where in the paper.


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


# Read the results ---------------------------------------------------------
require_input(results_file, "4_scripts/3_1_Analysis.R")
results <- readRDS(results_file)
descriptives <- results$descriptives


# Build a LaTeX table of the descriptives ----------------------------------
# Plain LaTeX, so the paper needs no extra package; a table package
# (modelsummary, kableExtra) can replace this once the project uses one.
latex_escape <- function(x) gsub("([_%&#$])", "\\\\\\1", x)
format_number <- function(x) formatC(x, format = "f", digits = 2, big.mark = ",")
table_rows <- sprintf("%s & %d & %s & %s & %s & %s \\\\",
                      latex_escape(descriptives$variable), as.integer(descriptives$n),
                      format_number(descriptives$mean), format_number(descriptives$sd),
                      format_number(descriptives$min), format_number(descriptives$max))
table_lines <- c(
  "\\begin{tabular}{lrrrrr}",
  "\\hline",
  "Variable & N & Mean & SD & Min & Max \\\\",
  "\\hline",
  table_rows,
  "\\hline",
  "\\end{tabular}"
)


# Write the table ----------------------------------------------------------
ensure_dir(tables_dir)
table_file <- file.path(tables_dir, "tab_descriptives.tex")
writeLines(table_lines, table_file, useBytes = TRUE)
message("Table written: 5_tables/", basename(table_file))
