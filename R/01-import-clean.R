# 01-import-clean.R
# Import and clean FITFR data
library(readxl)
library(dplyr)
library(stringr)
library(janitor)

raw_file <- "raw-data/FITFR-final-data-v3.xlsx"

dir.create("data", showWarnings = FALSE)

dat_raw <- read_excel(raw_file, skip = 1)

cat("Original column names:\n")
print(names(dat_raw))

dat <- dat_raw %>%
  clean_names()

cat("\nCleaned column names:\n")
print(names(dat))

to_na_string <- function(x) {
  x <- as.character(x)
  x <- str_trim(x)
  x[x %in% c("", "NA", "N/A", "NULL", ".", "-", "--", "missing", "Missing")] <- NA_character_
  x
}

dat <- dat %>%
  filter(!if_all(everything(), ~ is.na(.)))

if ("id" %in% names(dat)) {
  dat <- dat %>% filter(!is.na(id))
} else {
  stop("Column 'id' not found after cleaning names.")
}

dat <- dat %>%
  mutate(
    id = suppressWarnings(as.integer(id)),

    age = to_na_string(age),
    age = suppressWarnings(as.numeric(age)),
    age = if_else(age == -99, NA_real_, age),

    sex = to_na_string(sex),
    sex = str_to_lower(sex),
    sex = case_when(
      sex %in% c("female", "f") ~ "Female",
      sex %in% c("male", "m") ~ "Male",
      TRUE ~ NA_character_
    ),

    treatment = to_na_string(treatment),
    treatment = str_to_upper(treatment),
    treatment = case_when(
      treatment %in% c("A", "B", "C") ~ treatment,
      TRUE ~ NA_character_
    ),

    smoker = to_na_string(smoker),
    smoker = str_to_upper(smoker),
    smoker = case_when(
      smoker %in% c("Y", "YES") ~ "Yes",
      smoker %in% c("N", "NO") ~ "No",
      TRUE ~ NA_character_
    ),

    af = to_na_string(af),
    af = suppressWarnings(as.numeric(af)),

    pr = to_na_string(pr),
    pr = str_to_lower(pr),
    pr = case_when(
      pr %in% c("yes", "y", "1") ~ "Yes",
      pr %in% c("no", "n", "0") ~ "No",
      TRUE ~ NA_character_
    )
  )

dat <- dat %>%
  mutate(
    sex = factor(sex, levels = c("Female", "Male")),
    treatment = factor(treatment, levels = c("A", "B", "C")),
    smoker = factor(smoker, levels = c("No", "Yes")),
    pr = factor(pr, levels = c("No", "Yes"))
  )

snp_cols <- names(dat)[str_detect(names(dat), "^rs")]

cat("\nSNP columns:\n")
print(snp_cols)
cat("Number of SNP columns:", length(snp_cols), "\n")

clean_snp <- function(x) {
  x <- to_na_string(x)
  x <- str_to_upper(x)

  x[!str_detect(x, "^[ACGT]{2}$")] <- NA_character_

  x <- ifelse(
    is.na(x),
    NA_character_,
    sapply(x, function(g) {
      alleles <- strsplit(g, "")[[1]]
      paste(sort(alleles), collapse = "")
    })
  )

  x
}

if (length(snp_cols) > 0) {
  dat <- dat %>%
    mutate(across(all_of(snp_cols), clean_snp))
}

cat("\n=========================\n")
cat("DATA CHECK\n")
cat("=========================\n")

cat("Number of rows:", nrow(dat), "\n")
cat("Number of columns:", ncol(dat), "\n\n")

cat("Duplicate IDs:", sum(duplicated(dat$id)), "\n\n")

cat("Missing values in key variables:\n")
print(colSums(is.na(dat[, c("id", "age", "sex", "treatment", "smoker", "af", "pr")])))

cat("\nTreatment counts:\n")
print(table(dat$treatment, useNA = "ifany"))

cat("\nSex counts:\n")
print(table(dat$sex, useNA = "ifany"))

cat("\nSmoker counts:\n")
print(table(dat$smoker, useNA = "ifany"))

cat("\nPR counts:\n")
print(table(dat$pr, useNA = "ifany"))

cat("\nAge summary:\n")
print(summary(dat$age))

cat("\nAF summary:\n")
print(summary(dat$af))

smoker_nonmissing <- dat %>% filter(!is.na(smoker))
use_smoker <- n_distinct(smoker_nonmissing$smoker) > 1

cat("\nCan smoker be used in models? ", use_smoker, "\n")
if (!use_smoker) {
  cat("Reason: smoker has no variation.\n")
}

analysis_dat <- dat %>%
  filter(
    !is.na(treatment),
    !is.na(age),
    !is.na(sex),
    !is.na(af),
    !is.na(pr)
  )

cat("\nAnalysis dataset rows:", nrow(analysis_dat), "\n")

if (use_smoker) {
  analysis_dat_with_smoker <- dat %>%
    filter(
      !is.na(treatment),
      !is.na(age),
      !is.na(sex),
      !is.na(smoker),
      !is.na(af),
      !is.na(pr)
    )

  cat("Analysis dataset with smoker rows:", nrow(analysis_dat_with_smoker), "\n")
}

write.csv(dat, "data/fitfr_clean.csv", row.names = FALSE)
saveRDS(dat, "data/fitfr_clean.rds")

write.csv(analysis_dat, "data/fitfr_analysis.csv", row.names = FALSE)
saveRDS(analysis_dat, "data/fitfr_analysis.rds")

if (exists("analysis_dat_with_smoker")) {
  write.csv(analysis_dat_with_smoker, "data/fitfr_analysis_with_smoker.csv", row.names = FALSE)
  saveRDS(analysis_dat_with_smoker, "data/fitfr_analysis_with_smoker.rds")
}

cat("\nCleaned data saved to:\n")
cat("- data/fitfr_clean.csv\n")
cat("- data/fitfr_clean.rds\n")
cat("- data/fitfr_analysis.csv\n")
cat("- data/fitfr_analysis.rds\n")

if (exists("analysis_dat_with_smoker")) {
  cat("- data/fitfr_analysis_with_smoker.csv\n")
  cat("- data/fitfr_analysis_with_smoker.rds\n")
}

