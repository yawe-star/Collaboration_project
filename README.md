# FITFR Statistical Consulting Report

This repository contains the final STAT 4001 statistical consulting report for the FITFR project.

## Main Files

- `final_report.qmd`: Quarto source for the final report.
- `final_report.pdf`: rendered PDF version of the final report.
- `references.bib` and `ieee.csl`: bibliography and citation style files used by the report.
- `R/01-import-clean.R`: data cleaning script used to prepare the analysis datasets.
- `output/`: selected derived SNP ranking outputs used by the report.
- `figs/`: supporting figures from exploratory SNP checks.

## Data Note

The original FITFR data and cleaned individual-level datasets are treated as confidential/unpublished project data. They are excluded from GitHub via `.gitignore`. The report can be rendered locally when the required data files are present in `raw-data/` and `data/`.

## Reproducibility

The report uses Quarto and R. From the project root, render the report with:

```bash
quarto render final_report.qmd
```

R scripts are included for cleaning, analysis, and modelling steps used in the final report.
