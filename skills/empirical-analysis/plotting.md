# Plotting for Research Output

**Load when:** creating or modifying any figure for a paper, talk, proposal or report, in R or Python.
**Skip when:** the task is analysis, tables or prose with no figure; or a quick exploratory plot nobody else will see.

Principles first (tool-agnostic), then R and Python recipes. Load alongside `SKILL.md`.

---

## Principles

Drawn from Tufte (1983), Cleveland & McGill (1984), Healy (2019) and Schwabish (2021).

1. **Put the key comparison on the most accurate encoding.** Readers judge position on a common
   scale best, then length, then angle, area, color intensity and volume. If readers must compare
   group means, align them on one axis (dot plot), rather than encoding the difference as color or area.
2. **Every mark should carry data.** Remove decorative gridlines, borders, 3D effects and background
   fills. For each element ask: what does this tell the reader?
3. **Show the data when n is small** (roughly under 100 per group). A mean and CI over 20 people
   hides whether the spread is symmetric or one person drives it. Standard combination: individual
   points (jittered, transparent), then the CI, then the mean.
4. **Always show uncertainty.** Never bare means. Default 95% CIs (±1.96 × SE), computed from the
   same SEs as the analysis (robust or clustered), not from raw SD/√n.
5. **Colorblind-safe palettes.** About 8% of men have a color vision deficiency; avoid red/green.
   - Ordered categories: viridis, or ColorBrewer sequential (Blues, Oranges)
   - Unordered categories: the Wong (2011) set
     (`#E69F00 #56B4E9 #009E73 #F0E442 #0072B2 #D55E00 #CC79A7 #000000`), or ColorBrewer Dark2/Set2
   - Deviations from a benchmark: diverging ColorBrewer RdBu or PRGn
6. **Small multiples over one crowded panel.** To compare the same relationship across subgroups,
   repeat the panel in a grid (facets). Overlaid colored lines force a legend lookup.
7. **Label directly where possible.** Put labels next to the lines or groups; a legend makes the
   reader look away from the data. Legends are fine for many groups or overlapping elements.
8. **Aspect ratio.** Slopes read best near 45° on average ("banking", Cleveland 1993). Adjust
   width/height for trend plots; dot plots usually work roughly square.
9. **One visual language per paper.** The same variable gets the same color, shape and line type in
   every figure. Define the palette once in the plot setup script and reuse it; never give two
   variables the same color.
10. **Captions live in LaTeX.** During development, a caption inside the figure (`labs(caption = )`)
    helps; for the paper, remove it and write the caption in the `.tex` file, where the journal's
    style decides its format.

---

## R (ggplot2)

```r
# Plot setup script: define once, use in every figure
theme_project <- function() {
  ggplot2::theme_bw() +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      strip.background = ggplot2::element_rect(fill = "grey95", colour = "grey70"),
      legend.position  = "bottom"
    )
}
wong_palette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442",
                  "#0072B2", "#D55E00", "#CC79A7", "#000000")

# Show the data: points, then 95% CI, then mean
# (summary_by_group: one row per group with columns group, mean, se)
p <- ggplot2::ggplot(data_final_survey_main, ggplot2::aes(x = group, y = outcome)) +
  ggplot2::geom_jitter(width = 0.08, alpha = 0.35, size = 1.2) +
  ggplot2::geom_errorbar(
    data = summary_by_group,
    ggplot2::aes(y = mean, ymin = mean - 1.96 * se, ymax = mean + 1.96 * se),
    width = 0.12, linewidth = 0.7
  ) +
  ggplot2::geom_point(data = summary_by_group, ggplot2::aes(y = mean), size = 3) +
  theme_project()

# Scales
ggplot2::scale_colour_manual(values = wong_palette)          # unordered categories
ggplot2::scale_colour_viridis_d(begin = 0.15, end = 0.85)    # ordered categories
ggplot2::scale_colour_distiller(palette = "RdBu", direction = 1)  # diverging

# Export as PDF (vector graphics, scales cleanly in Overleaf)
ggplot2::ggsave(here::here("6_plots", "outcome_by_group.pdf"),
                plot = p, width = 6, height = 4)
```

| Figure | Width | Height |
|---|---|---|
| single panel | 6 in | 4 in |
| facets, 2–3 columns | 8 in | 4 in |
| facets, 2 rows | 6 in | 6 in |
| coefficient plot, many rows | 6 in | 5–7 in |

Useful packages: `patchwork` (combine plots: `p1 + p2`, `p1 / p2`), `ggrepel` (labels that do not
overlap), `scales` (`label_percent()`, `label_comma()`), `ggdist` (distributions beside estimates).

**Non-ASCII text in a PDF.** The default PDF device handles only basic characters reliably: Δ,
subscripts or symbols give `conversion failure in 'mbcsToSbcs'` warnings and render blank. Use
`expression()` for math (`expression(italic(w)[auto])`), spell the symbol out in plain text, or
save with `device = cairo_pdf`.

---

## Python (matplotlib + seaborn, or plotnine)

```python
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme(style="ticks", context="paper")   # close to theme_bw()
palette = sns.color_palette("colorblind")       # Wong-style colorblind-safe set

fig, ax = plt.subplots(figsize=(6, 4))
sns.stripplot(data=data_final_survey_main, x="group", y="outcome", alpha=0.35, size=4, jitter=True, ax=ax)
ax.errorbar(x_positions, means, yerr=1.96 * ses, fmt="o", color="black",
            capsize=4, linewidth=1.5)
sns.despine(ax=ax)                              # removes top and right spines

fig.savefig(project_root / "6_plots" / "outcome_by_group.pdf", bbox_inches="tight")
plt.close(fig)                                  # frees memory in loops
```

`plotnine` copies ggplot2's grammar almost one to one; use it when the project thinks in ggplot2
or to cross-check an R figure in Python.

---

## Common mistakes

- **Bars with error bars and no data points.** The bar repeats the mean and hides the
  distribution. Use dot plus CI, with the points if n is small.
- **Two y-axes.** The visual relation between the series depends on arbitrary axis scaling. Use
  small multiples.
- **Pie charts.** Angle and area are judged poorly. Use a dot or bar chart of proportions.
- **A color gradient for unordered categories.** It implies an order that does not exist.
- **The default ggplot2 grey background.** Ink that carries no data; override it with a theme.
- **Truncated bar axes.** A bar chart must start at zero; dots and lines may start elsewhere if
  the axis is labeled clearly.
- **Different colors for the same variable across figures.** Readers carry the mapping from one
  figure to the next; breaking it causes misreadings.
