# Translate the raw Japanese e-Stat Excel files in data/raw/ into English CSVs in data/csv/.
#
# Run from the repository root:  Rscript Script/translate.R
# Required packages: readxl, dplyr, readr
#
# What this script does (and nothing else):
#   1. Drops the title / multi-row Japanese header and adds 1 row of English column names.
#   2. Translates Japanese labels in identifier columns (nationality, sex, area_type, industry_name).
#   3. Drops Japanese area names (keeps the standard area codes only).
#
# Values (including "-" for missing/empty cells) are NOT modified or converted.
# See docs/codebook.md for the mapping of all column names and labels.

suppressPackageStartupMessages({
  library(readxl)
  library(dplyr)
  library(readr)
})

dir.create("data/csv", showWarnings = FALSE, recursive = TRUE)

# Helper: keep only the code before "_" (e.g. "01100_札幌市" -> "01100")
code_only <- function(x) sub("_.*", "", x)

# Dictionaries for Japanese identifier labels
area_types <- c(
  "a" = "japan_prefecture",
  "1" = "designated_city",
  "0" = "ward",
  "2" = "city",
  "3" = "town_village",
  "9" = "municipality_2000"
)
nationalities <- c("0_国籍総数" = "total", "1_うち日本人" = "japanese")
sexes         <- c("0_総数" = "total", "1_男" = "male", "2_女" = "female")

# ---------------------------------------------------------------------------
# 1. Population Census 2020 & 2025 (Tables 2-7 and 2-8)
# ---------------------------------------------------------------------------

census_value_cols <- c(
  "pop_total",
  "pop_0_4", "pop_5_9", "pop_10_14", "pop_15_19", "pop_20_24",
  "pop_25_29", "pop_30_34", "pop_35_39", "pop_40_44", "pop_45_49",
  "pop_50_54", "pop_55_59", "pop_60_64", "pop_65_69", "pop_70_74",
  "pop_75_79", "pop_80_84", "pop_85_89", "pop_90_94", "pop_95_99",
  "pop_100plus", "pop_age_not_reported",
  "pop_under15", "pop_15_64", "pop_65plus", "pop_75plus", "pop_85plus", "pop_20_69",
  "ratio_under15", "ratio_15_64", "ratio_65plus",
  "ratio_60plus", "ratio_75plus", "ratio_85plus", "ratio_100plus", "ratio_20_69",
  "average_age", "median_age"
)

# Table 2-7 (2020 & 2025): 12 header rows, column 9 is Japanese area name (dropped)
t27_cols <- c(
  "nationality", "sex", "area_type",
  "pref_code_2000", "area_code_2000", "area_2000",
  "pref_code", "area_code", "area_name_jp",
  census_value_cols
)

for (name in c("census2020_t2-7", "census2025_t2-7")) {
  df <- read_excel(paste0("data/raw/", name, ".xlsx"),
                   skip = 12, col_names = t27_cols, col_types = "text") |>
    mutate(
      nationality    = unname(nationalities[nationality]),
      sex            = unname(sexes[sex]),
      area_type      = unname(area_types[area_type]),
      pref_code_2000 = code_only(pref_code_2000),
      pref_code      = code_only(pref_code)
    ) |>
    select(-area_name_jp)

  write_csv(df, paste0("data/csv/", name, ".csv"))
  message("Wrote ", name, ".csv (", nrow(df), " rows, ", ncol(df), " cols)")
}

# Table 2-8 (2020 & 2025, DIDs): 12 header rows
t28_cols <- c("nationality", "sex", "area_type", "pref_code", "area_code", census_value_cols)

for (name in c("census2020_t2-8", "census2025_t2-8")) {
  df <- read_excel(paste0("data/raw/", name, ".xlsx"),
                   skip = 12, col_names = t28_cols, col_types = "text") |>
    mutate(
      nationality = unname(nationalities[nationality]),
      sex         = unname(sexes[sex]),
      area_type   = unname(area_types[area_type]),
      pref_code   = code_only(pref_code),
      area_code   = code_only(area_code)
    )

  write_csv(df, paste0("data/csv/", name, ".csv"))
  message("Wrote ", name, ".csv (", nrow(df), " rows, ", ncol(df), " cols)")
}

# ---------------------------------------------------------------------------
# 2. 2021 Economic Census for Business Activity (Table 6-1)
# ---------------------------------------------------------------------------

# Official English industry names from docs/ecensus2021_classification.xlsx (cols 9 & 10)
cls21 <- read_excel("docs/ecensus2021_classification.xlsx",
                    sheet = 1, skip = 8, col_names = FALSE, col_types = "text",
                    .name_repair = "minimal")
ind21 <- tibble(code = trimws(cls21[[9]]), name = trimws(cls21[[10]])) |>
  filter(!is.na(code), !is.na(name)) |>
  distinct(code, .keep_all = TRUE)

# Aggregate codes are written with "～" in the classification file (e.g. AR -> A～R)
agg_map <- c(AS = "A～S", AR = "A～R", AB = "A～B", CR = "C～R")

t61_cols <- c(
  "area_type", "area_code", "industry_hierarchy", "industry_division", "industry_code",
  "establishments",
  "persons_engaged", "persons_engaged_male", "persons_engaged_female",
  "regular_employees", "regular_employees_male", "regular_employees_female",
  "loaned_dispatched_to_others", "loaned_dispatched_to_others_male", "loaned_dispatched_to_others_female",
  "loaned_dispatched_from_others", "loaned_dispatched_from_others_male", "loaned_dispatched_from_others_female",
  "loaned_from_others", "loaned_from_others_male", "loaned_from_others_female",
  "dispatched_from_others", "dispatched_from_others_male", "dispatched_from_others_female",
  "persons_working", "persons_working_male", "persons_working_female"
)

df61 <- read_excel("data/raw/ecensus2021_t6-1.xlsx",
                   skip = 9, col_names = t61_cols, col_types = "text") |>
  mutate(
    area_type     = unname(area_types[area_type]),
    area_code     = code_only(area_code),
    industry_code = code_only(industry_code),
    lookup_code   = ifelse(industry_code %in% names(agg_map), agg_map[industry_code], industry_code),
    industry_name = ind21$name[match(lookup_code, ind21$code)]
  ) |>
  select(-lookup_code) |>
  relocate(industry_name, .after = industry_code)

write_csv(df61, "data/csv/ecensus2021_t6-1.csv")
message("Wrote ecensus2021_t6-1.csv (", nrow(df61), " rows, ", ncol(df61), " cols)")

# ---------------------------------------------------------------------------
# 3. 2024 Economic Census for Business Frame (Tables 4-1A and 4-1B)
# ---------------------------------------------------------------------------

# Industry column codes are read from the lookup table frame2024_industries.csv
ind24 <- read_csv("data/csv/frame2024_industries.csv", show_col_types = FALSE)
f24_cols <- c("area_type", "area_code", ind24$industry_code)

for (name in c("frame2024_t4-1a", "frame2024_t4-1b")) {
  df <- read_excel(paste0("data/raw/", name, ".xlsx"),
                   skip = 11, col_names = f24_cols, col_types = "text") |>
    mutate(
      area_type = unname(area_types[area_type]),
      area_code = code_only(area_code)
    )

  write_csv(df, paste0("data/csv/", name, ".csv"))
  message("Wrote ", name, ".csv (", nrow(df), " rows, ", ncol(df), " cols)")
}
