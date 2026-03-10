# Skill: Project Organizer

**Load when:** structuring a script pipeline, organising Overleaf layout, or mapping analysis outputs to paper sections.
**Skip when:** the pipeline structure is settled and the task is running analysis or building individual outputs.

Bridges the analysis pipeline and the paper structure. Covers two domains:
(1) R script pipeline architecture, and (2) LaTeX/Overleaf organization.
Distinct from `research-paper` (which covers *how* to format individual outputs)
and `analysis-plan-planner` (which covers *what* to analyze).

---

## R Pipeline Architecture

### Setup / content / save split
Every pipeline stage should follow this three-file pattern:
- `*_0_Setup.R` — shared constants, helper functions, config used across the stage
- `*_N_Content.R` — the analysis or output logic; declares dependencies on setup at the top
- `*_M_Save_Objects.R` — serialization of results to `7_r_objects/`

Shared objects (significance stars, GOF maps, custom tidiers) always go in the
stage's `*_0_Setup.R`. Never inline them in content scripts.

### Cross-script dependencies
Content scripts should open with a comment block declaring:
- Which setup script(s) they depend on
- Which objects must be in memory (and which script produces them)

Example:
```r
# Depends on: 4_0_Tables_Setup.R (stars, gof_map, tidy_norm)
# Requires in memory: treatment_effect, treatment_effect_table (from 3_2)
```

### Output naming
R output filenames should map unambiguously to paper sections:
- Tables: `tab_{section}_{descriptor}.tex` (e.g., `tab_treatment_effect.tex`)
- Figures: `fig_{section}_{descriptor}.pdf`
- Objects: `{descriptor}.rds`

---

## LaTeX / Overleaf Organization

### Output-to-paper mapping
Before generating outputs, establish which table/figure goes in which paper section.
Document this in `output_spec.md` (one row per output: R filename, LaTeX label,
paper section).

### Label conventions
- Tables: `\label{tab:descriptor}` matching the R filename (e.g., `\label{tab:treatment_effect}`)
- Figures: `\label{fig:descriptor}`
- Keep labels consistent between R output filenames and LaTeX labels to avoid drift.

### Overleaf structure
- One main `.tex` file that `\input{}`s section files
- Tables and figures live in a dedicated subfolder (e.g., `tables/`, `figures/`)
- `\input{tables/tab_treatment_effect.tex}` — path matches R output filename exactly

---

## Open / to refine
- Conventions for appendix tables vs. main-text tables
- How to handle table versioning when analysis changes (suffix strategy vs. overwrite)
