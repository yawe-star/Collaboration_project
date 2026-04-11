# Collaboration project

This project was created for a statistical consulting role-play project. It contains the data cleaning script, the main analysis report, and the output files used to summarise the FITFR dataset.

## Project aim

The aim of this project is to organise Karl's dataset in a reproducible project structure and carry out an initial statistical analysis.

The analysis focuses on:

-   data cleaning and preprocessing
-   descriptive summaries across treatment groups
-   adjusted analysis of AF
-   adjusted analysis of PR
-   exploratory SNP screening for AF and PR

## Main findings

After preprocessing, the dataset used for summary and modelling contained treatment groups A, B, and C.\
The main findings from the analysis were:

-   AF differed clearly across treatment groups, with group A showing lower values than groups B and C.
-   Age was positively associated with AF after adjustment.
-   For PR, age remained an important predictor after adjustment, while treatment was less clearly associated.
-   SNP screening was treated as exploratory because the sample size was limited relative to the number of genetic variables.
-   Smoking was not included in the adjusted models because all participants were coded as non-smokers in this dataset.

These findings are presented in more detail in `analysis.qmd` and summarised in the presentation slides.

## Project structure

``` text
collaboration-project/
├── analysis.qmd
├── collaboration-project.Rproj
├── readme.qmd
├── raw-data/
│   └── FITFR-final-data-v3.xlsx
├── data/
│   ├── fitfr_clean.csv
│   ├── fitfr_clean.rds
│   ├── fitfr_analysis.csv
│   └── fitfr_analysis.rds
├── figs/
│   ├── af_top10_snp.png
│   └── pr_top10_snp.png
├── output/
│   ├── af_snp_ranking.csv
│   └── pr_snp_ranking.csv
├── R/
│   └── 01-import-clean.R
├── resources/
├── tabs/
└── tasks/
```

## File description

### `raw-data/`

This folder contains the original Excel file received from the collaborator.

### `R/01-import-clean.R`

This script imports the raw Excel data, cleans variable names, handles missing and invalid values, standardises categorical variables, cleans SNP genotype coding, and writes cleaned datasets into the `data/` folder.

### `data/`

This folder contains cleaned datasets generated from the cleaning script.

-   `fitfr_clean.csv` and `fitfr_clean.rds`: cleaned full dataset
-   `fitfr_analysis.csv` and `fitfr_analysis.rds`: analysis-ready dataset used in the report

### `analysis.qmd`

This is the main analysis report.\
It reads the cleaned data and performs:

-   descriptive summary tables
-   exploratory plots for AF and PR
-   adjusted linear regression for AF
-   adjusted logistic regression for PR
-   exploratory SNP screening adjusted for treatment, age, and sex

### `figs/`

This folder contains figures generated from the exploratory SNP screening step.

### `output/`

This folder contains ranking tables from the exploratory SNP analysis.

### `resources/`, `tabs/`, and `tasks/`

These folders are kept as part of the project structure for organisation and possible future work.

## Reproducible workflow

To reproduce the project:

1.  Open `collaboration-project.Rproj`
2.  Run `R/01-import-clean.R`
3.  Render `analysis.qmd`

This workflow regenerates the cleaned data and the analysis outputs using the files stored in this project folder.

## Variables used in the main analysis

The main analysis focuses on the following variables:

-   `treatment`: treatment group, coded as A, B, or C
-   `age`: participant age
-   `sex`: participant sex
-   `af`: continuous outcome
-   `pr`: binary outcome
-   `rs...`: SNP variables used in exploratory genetic screening

## Notes

-   This project uses relative paths so that it can be run directly from the project folder.
-   Smoking was excluded from later models because it showed no variation after cleaning.
-   The SNP analysis is exploratory and should not be interpreted as confirmatory inference.

## Author

Jinzhuo Shen
