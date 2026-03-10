# Sub-skill: Plotting (Empirical Analysis)

**Load when:** creating or modifying any figure for a paper or presentation.
**Skip when:** the task is purely analysis, table-building, or writing with no plot output.

Plotting conventions for academic research outputs. Load alongside `empirical-analysis/SKILL.md`
when building figures for a paper or presentation. Covers principles first, then
R and Python implementations.

---

## Principles (tool-agnostic)

These derive from Tufte (1983), Cleveland & McGill (1984), Healy (2019), and Schwabish (2021).

### 1. Perceptual hierarchy (Cleveland & McGill)
Design the most important comparison to use the most accurately perceived encoding:

**position along common scale > length > angle > area > colour intensity > volume/shape**

Practical implication: if readers need to compare group means, align them on a common
axis (dot plot, bar chart) rather than encoding the difference as colour or area.

### 2. Data-ink ratio (Tufte)
Maximise the proportion of ink that encodes data; eliminate everything that does not.
Remove: decorative gridlines, redundant tick marks, unnecessary borders, 3D effects,
background fills that carry no information. Every visual element should answer "what
does this tell the reader?"

### 3. Show the data (Healy)
When n per group is small (roughly < 100), always show individual observations alongside
summaries. A mean with a CI on n = 20 hides the distribution — the reader cannot tell
whether the variance is symmetric, whether there are outliers, or whether the CI is
driven by one participant. Standard combination:
  individual points (jittered, low alpha) → error bar → mean point

### 4. Always show uncertainty
Never plot bare means. Use 95% CIs as the default (standard: 1.96 × SE). When SEs
are heteroskedasticity-robust or clustered, compute CIs from those SEs, not raw SD/√n.

### 5. Colorblind-safe palettes
~8% of men have some form of colour vision deficiency. Avoid red/green contrasts.
Preferred palettes:
- **Sequential / ordered** (e.g., three precision conditions): viridis, or ColorBrewer
  sequential (Blues, Oranges, etc.)
- **Categorical / unordered** (e.g., table vs no-table): Wong (2011) 8-colour set
  (`#E69F00`, `#56B4E9`, `#009E73`, `#F0E442`, `#0072B2`, `#D55E00`, `#CC79A7`, `#000000`)
  or ColorBrewer "Dark2" / "Set2"
- **Diverging** (e.g., deviation from benchmark): ColorBrewer "RdBu" or "PRGn"
- Test your palette at: https://www.color-blindness.com/coblis-color-blindness-simulator/

### 6. Small multiples over overloaded panels (Tufte)
When comparing the same relationship across subgroups, repeat the same plot structure
in a grid (facet) rather than overlaying everything in one panel. The reader's eye can
scan across panels; overlapping lines or colour-coded groups require a legend lookup.

### 7. Direct labelling over legends (Schwabish)
Where feasible, label lines, groups, or points directly on or next to the element rather
than through a legend. Legends require the reader to look away from the data. Exception:
legends are fine when there are many groups or when elements overlap.

### 8. Aspect ratio
Slopes are perceived more accurately when the average absolute slope in the panel is
near 45°. For time-series or trend plots, adjust width/height to approximate this
("banking to 45°", Cleveland 1993). For comparative dot plots, a roughly square panel
usually works.

### 9. Consistent visual language within a paper
Same variable → same colour, same shape, same linetype across all figures. Define a
palette object at the top of the plots setup script and reference it everywhere. Never
use the same colour for two different variables.

### 10. Captions during development vs final paper
During development, use `labs(caption = ...)` to embed a description directly in the
figure. For the final paper, strip captions from the figure and write them in LaTeX/
Overleaf — journal style guides usually dictate caption format and placement.

---

## R Implementation (ggplot2)

### Default theme
```r
# In 5_0_Plots_Setup.R — apply to every plot
theme_project <- function() {
  ggplot2::theme_bw() +
    ggplot2::theme(
      panel.grid.minor  = ggplot2::element_blank(),
      strip.background  = ggplot2::element_rect(fill = "grey95", colour = "grey70"),
      legend.position   = "bottom"
    )
}
```

### Show-the-data combination
```r
ggplot2::ggplot(df, ggplot2::aes(x = group, y = outcome)) +
  ggplot2::geom_jitter(width = 0.08, alpha = 0.35, size = 1.2) +   # individual obs
  ggplot2::geom_errorbar(                                            # 95% CI
    data = df_summary,
    ggplot2::aes(ymin = mean - 1.96 * se, ymax = mean + 1.96 * se),
    width = 0.12, linewidth = 0.7
  ) +
  ggplot2::geom_point(data = df_summary, size = 3)                  # mean
```

### Colour palettes
```r
# Wong 8-colour (colorblind-safe categorical) — define in plots setup
wong_palette <- c(
  "#E69F00", "#56B4E9", "#009E73", "#F0E442",
  "#0072B2", "#D55E00", "#CC79A7", "#000000"
)

# In a plot:
ggplot2::scale_colour_manual(values = wong_palette)
ggplot2::scale_fill_manual(values = wong_palette)

# Sequential (ordered conditions):
ggplot2::scale_colour_viridis_d(option = "D", begin = 0.15, end = 0.85)

# Diverging (deviation from benchmark):
ggplot2::scale_colour_distiller(palette = "RdBu", direction = 1)
```

### Standard figure dimensions
| Type | Width | Height |
|---|---|---|
| Single panel | 6 in | 4 in |
| Faceted (2–3 columns) | 8 in | 4 in |
| Faceted (2 rows) | 6 in | 6 in |
| Coefficient plot (many rows) | 6 in | 5–7 in |

### Export
```r
# Always save as PDF for Overleaf (vector graphics, scales cleanly)
ggplot2::ggsave(
  "6_plots/plot_name.pdf",
  plot   = plot_object,
  width  = 6, height = 4   # adjust per table above
)
```

### Package notes
- `ggplot2` is the only required package for most plots
- `patchwork`: combine multiple ggplot objects into one figure (`plot1 + plot2` / `plot1 / plot2`)
- `ggrepel`: non-overlapping text labels (`geom_text_repel`, `geom_label_repel`)
- `scales`: axis formatting helpers (`label_percent()`, `label_comma()`, `squish()`)
- `ggdist`: distribution geoms (`stat_halfeye`, `geom_dotsinterval`) — excellent for
  showing posteriors or distributions alongside point estimates

---

## Python Implementation (seaborn + matplotlib / plotnine)

### seaborn + matplotlib (dominant in Python academic work)
```python
import matplotlib.pyplot as plt
import seaborn as sns

# Default theme — equivalent to theme_bw()
sns.set_theme(style="ticks", context="paper")
sns.despine()   # removes top and right spines

# Show-the-data combination
fig, ax = plt.subplots(figsize=(6, 4))
sns.stripplot(data=df, x="group", y="outcome",
              alpha=0.35, size=4, jitter=True, ax=ax)        # individual obs
ax.errorbar(x_positions, means, yerr=1.96 * ses,
            fmt="o", color="black", capsize=4, linewidth=1.5) # mean + 95% CI

# Colorblind-safe palette
palette = sns.color_palette("colorblind")   # Wong 8-colour set
# or:
palette = ["#E69F00", "#56B4E9", "#009E73", "#0072B2", "#D55E00"]

# Export as PDF
fig.savefig("plots/plot_name.pdf", bbox_inches="tight")
plt.close(fig)
```

### plotnine (ggplot2 grammar in Python)
```python
from plotnine import *

# Nearly identical to ggplot2; use when the team thinks in ggplot2 syntax
(ggplot(df, aes(x="group", y="outcome"))
 + geom_jitter(width=0.08, alpha=0.35, size=1.2)
 + geom_errorbar(df_summary, aes(ymin="ci_lo", ymax="ci_hi"), width=0.12)
 + geom_point(df_summary, size=3)
 + theme_bw()
 + theme(panel_grid_minor=element_blank())
)
```

### When to use which
- **seaborn**: faster for exploratory work, better integration with pandas DataFrames,
  larger ecosystem of statistical plot types
- **plotnine**: prefer when the codebase is ggplot2-first and you want near-identical
  syntax; useful for R↔Python cross-checking

---

## Common Mistakes to Avoid

- **Bar charts with error bars but no data points** — the bar encodes the mean redundantly
  (the top of the bar and the dot are the same value); the bar itself carries no
  information and hides the distribution. Use dot + CI instead.
- **Dual y-axes** — almost always misleading; the visual relationship between two series
  depends entirely on the arbitrary choice of axis scaling. Use small multiples instead.
- **Pie charts** — area and angle judgments are inaccurate (Cleveland hierarchy). Use a
  dot plot or bar chart to show proportions.
- **Gradient colour for categorical variables** — implies ordering that does not exist.
- **Default ggplot2 grey background** — high data-ink ratio violation; always override.
- **Truncated y-axes** — starting a bar chart at a non-zero baseline exaggerates
  differences. If using bars, start at zero; if using dots/lines, starting elsewhere is
  fine but label clearly.
- **Non-ASCII Unicode in `labs()` / axis labels when saving to PDF** — the PDF graphics
  device only supports ASCII reliably. Characters like Δ (U+0394), subscripts (U+2080–
  U+209C), or symbols like ◆ (U+25C6) cause `conversion failure in 'mbcsToSbcs'` warnings
  and render as blank or garbage. Two fixes: use `expression()` for mathematical notation
  (e.g. `expression(italic(w)[auto])`); for plain-text captions, spell out the symbol
  (e.g. `"diff"` instead of `"Δ"`, `"mean |auto[t] - auto[t-1]|"` instead of
  `"mean |Δ auto|"`).
