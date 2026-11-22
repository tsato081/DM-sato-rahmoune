# Translation

This document describes the CSV files in `data/csv/`, how each Japanese label in the raw
files was translated, and the official source of each translation.

The CSV files are produced by `Script/translate.R` (run `Rscript Script/translate.R` from the repository root).
Each raw Excel file gives one CSV file with the same rows and the same layout.
The script only translates headers and identifier labels and drops Japanese area names; it does not
convert symbols (`-`), cast types, filter, merge, reshape, or aggregate. `frame2024_industries.csv`
is stored as a static lookup table extracted from `docs/official/frame2024_classification.pdf`.

| Raw file (`data/raw/`) | Processed file (`data/csv/`) | Rows | Columns |
|---|---|---|---|
| `census2020_t2-7.xlsx` | `census2020_t2-7.csv` | 24,516 | 47 |
| `census2025_t2-7.xlsx` | `census2025_t2-7.csv` | 24,492 | 47 |
| `census2020_t2-8.xlsx` | `census2020_t2-8.csv` | 6,228 | 44 |
| `census2025_t2-8.xlsx` | `census2025_t2-8.csv` | 6,096 | 44 |
| `ecensus2021_t6-1.xlsx` | `ecensus2021_t6-1.csv` | 255,580 | 28 |
| `frame2024_t4-1a.xlsx` | `frame2024_t4-1a.csv` | 1,962 | 767 |
| `frame2024_t4-1b.xlsx` | `frame2024_t4-1b.csv` | 1,962 | 767 |
| header rows of `frame2024_t4-1a.xlsx` / `frame2024_t4-1b.xlsx` | `frame2024_industries.csv` | 765 | 4 |

## What is changed and what is dropped

- The title and notes rows at the top of each sheet and the multi-row Japanese header are replaced
  by one row of English column names.
- Japanese labels in identifier columns are translated (tables below). Codes are kept as they are.
- **Japanese area names (`地域名` / text after `_` in area columns) are dropped.** Areas are
  identified by their standard 5-digit `area_code` (and 2-digit `pref_code`).
- **Data values are not modified**: the symbol `-` ("no relevant figures" / empty cell) is kept as
  `-` in the CSVs so that missing-value handling and numeric casting can be done explicitly during
  data cleaning.

## Sources

Official English documents of the Statistics Bureau of Japan, stored in `docs/official/`:

| File | Used for |
|---|---|
| `docs/official/census2020_terms.pdf` | Population census terms (average age, median age, age not reported, DIDs, area units) |
| `docs/official/census2020_outline.pdf` | Population census outline |
| `docs/official/ecensus2021_terms.pdf` | Economic census terms (establishments, persons engaged, regular employees, loaned or dispatched employees, persons working at the location) |
| `docs/official/ecensus2021_notes.pdf` | Meaning of `-` in the 2021 economic census tables |
| `docs/official/ecensus2021_classification.xlsx` | English names of the industry codes in table 6-1 (JSIC Rev. 13) |
| `docs/official/frame2024_terms.pdf` | Business frame terms (establishments, persons engaged) |
| `docs/official/frame2024_notes.pdf` | Coverage of the 2024 survey and meaning of `-` |
| `docs/official/frame2024_classification.pdf` | English names of the industry codes in tables 4-1A/4-1B (JSIC Rev. 14) |

English table titles on e-Stat (the English list pages of each survey):

| Table | English title on e-Stat | List page |
|---|---|---|
| Census 2-7 (2020, 2025) | Population and Population composition ratio (by age) by Sex, Age (five-year groups and 3 groups) and All nationality or Japanese, and Average age and Median age by Sex and All nationality or Japanese - Japan, Prefectures, Municipalities (including Municipalities as of 2000) | [2020](https://www.e-stat.go.jp/en/stat-search/files?page=1&layout=datalist&toukei=00200521&tstat=000001136464&cycle=0&tclass1=000001136466&tclass2val=0), [2025](https://www.e-stat.go.jp/en/stat-search/files?page=1&layout=datalist&toukei=00200521&tstat=000001230925&cycle=0&tclass1=000001230926&tclass2=000001232187&tclass3val=0) |
| Census 2-8 (2020, 2025) | Same title, ending with "- Japan, Prefectures, Municipalities (DIDs)" | same as above |
| Economic census 6-1 | Privately Owned Establishments, Persons Engaged by Sex, Regular Employees by Sex, Loaned or Dispatched Employees by Sex and Persons Working at the Location by Sex by Industry Major Groups - Japan, Prefectures and Municipalities | [2021](https://www.e-stat.go.jp/en/stat-search/files?page=1&layout=datalist&toukei=00200553&tstat=000001145590&cycle=0&tclass1=000001145649&tclass2=000001145667&tclass3=000001145670&tclass4val=0) |
| Business frame 4-1A | Privately Owned Establishments by Industry Groups (Excluding Individual Proprietorships with No Employees) - Japan, Prefectures and Municipalities | [2024](https://www.e-stat.go.jp/en/stat-search/files?page=1&layout=datalist&toukei=00200552&tstat=000001223942&cycle=0&tclass1=000001223947&tclass2=000001223949&tclass3=000001223953&tclass4val=0) |
| Business frame 4-1B | Persons Engaged by Industry Groups (Excluding Individual Proprietorships with No Employees) - Japan, Prefectures and Municipalities | same as above |

## Columns common to several files

### Area identification code (地域識別コード) → `area_type`

| Source value | `area_type` | Meaning | Source of the English term |
|---|---|---|---|
| `a` | `japan_prefecture` | Japan (`area_code` 00000) or a prefecture (`area_code` pp000) | e-Stat titles: "Japan, Prefectures" |
| `1` | `designated_city` | City designated by the Cabinet Order (政令指定都市) or the ku-area of Tokyo (特別区部) | census2020_terms.pdf p.34: "ku-area of Tokyo and the cities designated by the Cabinet Order" |
| `0` | `ward` | Ku (ward) of a designated city or of Tokyo | census2020_terms.pdf p.3: "shi, ku, machi and mura" |
| `2` | `city` | Shi (city) other than designated cities | census2020_terms.pdf p.3 |
| `3` | `town_village` | Machi (town) or mura (village) | census2020_terms.pdf p.3 |
| `9` | `municipality_2000` | Municipality as of 2000 (census table 2-7 only) | e-Stat title: "Municipalities as of 2000"; census2020_terms.pdf p.5 |

Note: municipalities in the usual sense are `designated_city` + `city` + `town_village`, plus the
Tokyo wards (`ward` with `area_code` 13101–13123). `ward` rows of designated cities are parts of
the `designated_city` row with the same first three digits.

### Area codes

| Source column | Column | Content |
|---|---|---|
| 地域コード / 地域区分 / 地域名（人口集中地区） (code part) | `area_code` | 5-digit standard area code. The Japanese name after `_` is dropped |
| 都道府県 (code part) | `pref_code` | 2-digit prefecture code (`00` = Japan) |

### Nationality and sex (census tables)

| Source value | Column | Value | Source of the English term |
|---|---|---|---|
| 0_国籍総数 | `nationality` | `total` | e-Stat title: "All nationality or Japanese" |
| 1_うち日本人 | `nationality` | `japanese` | e-Stat title; census2020_terms.pdf p.6 ("Nationality") |
| 0_総数 / 1_男 / 2_女 | `sex` | `total` / `male` / `female` | e-Stat title: "by Sex" |

### Symbol "-"

The symbol `-` is **kept as-is** in `data/csv/` (not converted to `0` or `NA` by
`Script/translate.R`). Its meaning in the source surveys is documented below for downstream cleaning:

| File | Meaning in the source | Source |
|---|---|---|
| Economic census 6-1 | "lack relevant numbers" | ecensus2021_notes.pdf p.2 |
| Business frame 4-1A/4-1B | "lack relevant numbers" | frame2024_notes.pdf p.3 |
| Census 2-7/2-8, `pop_*` columns | no person in the category | checked on source data: age groups + `pop_age_not_reported` sum to `pop_total` |
| Census 2-7/2-8, `ratio_*`, `average_age`, `median_age` | cannot be calculated (population 0, e.g. Futaba-machi `07546` in 2020) | source table structure |

## Census tables 2-7 and 2-8 (`census20XX_t2-7.csv`, `census20XX_t2-8.csv`)

Identifier columns of table 2-7:

| Source column | Column | Content |
|---|---|---|
| 国籍総数か日本人 | `nationality` | see above |
| 男女 | `sex` | see above |
| 地域識別コード | `area_type` | see above |
| 2000年_都道府県 | `pref_code_2000` | prefecture of the area as of 2000 |
| 2000年_地域コード | `area_code_2000` | area code as of 2000 |
| 2000年地域 | `area_2000` | as in the source: `2000` (the area belongs to the set of municipalities as of 2000) or empty |
| 2020年(2025年)_都道府県 | `pref_code` | current prefecture |
| 2020年(2025年)_地域コード | `area_code` | current area code (for `municipality_2000` rows: the current municipality the 2000 municipality belongs to) |
| 地域名 | dropped | Japanese area name |

Identifier columns of table 2-8: `nationality`, `sex`, `area_type`, `pref_code` (都道府県),
`area_code` (地域名（人口集中地区）). Values are for the DID part of each area.
Source of "Densely Inhabited Districts (DIDs)": census2020_terms.pdf p.40, e-Stat title.

Value columns (same in both tables):

| Source label | Column | Unit | Source of the English term |
|---|---|---|---|
| 人口 / 00_総数 | `pop_total` | persons | e-Stat title: "Population" |
| 人口 / 01_0～4歳 … 20_95～99歳 | `pop_0_4` … `pop_95_99` | persons | e-Stat title: "Age (five-year groups)" |
| 人口 / 21_100歳以上 | `pop_100plus` | persons | same |
| 人口 / 22_年齢「不詳」 | `pop_age_not_reported` | persons | census2020_terms.pdf p.6: "Age not reported" |
| 人口 / R1_（再掲）15歳未満 | `pop_under15` | persons | e-Stat title: "Age (… 3 groups)"; 再掲 = subtotal repeated from the groups above |
| 人口 / R2_（再掲）15～64歳 | `pop_15_64` | persons | same |
| 人口 / R3_（再掲）65歳以上 | `pop_65plus` | persons | same |
| 人口 / R4_（再掲）75歳以上 | `pop_75plus` | persons | same |
| 人口 / R5_（再掲）85歳以上 | `pop_85plus` | persons | same |
| 人口 / R6_（再掲）20～69歳 | `pop_20_69` | persons | same |
| 人口構成比［年齢別］ / 1_15歳未満, 2_15～64歳, 3_65歳以上 | `ratio_under15`, `ratio_15_64`, `ratio_65plus` | % | e-Stat title: "Population composition ratio (by age)" |
| 人口構成比［年齢別］ / R1–R5 (60, 75, 85, 100 and over; 20–69) | `ratio_60plus`, `ratio_75plus`, `ratio_85plus`, `ratio_100plus`, `ratio_20_69` | % | same |
| 平均年齢 | `average_age` | years | census2020_terms.pdf p.6: "Average Age" |
| 年齢中位数 | `median_age` | years | census2020_terms.pdf p.6: "Median Age" |

Composition ratios, average age and median age exclude persons whose age is not reported
(note 1 of the source table; census2020_terms.pdf p.6).

## Economic census 2021, table 6-1 (`ecensus2021_t6-1.csv`)

One row per area × industry, as in the source.

| Source column / label | Column | Source of the English term |
|---|---|---|
| 地域識別コード | `area_type` | see above |
| 地域区分 (code part) | `area_code` | see above |
| 階層 | `industry_hierarchy` | 1 = aggregate (AR, AB, CR), 2 = division, 3 = subdivision (e.g. G1, I1), 4 = major group (2 digits) |
| 産業大分類 | `industry_division` | division code of the industry |
| 産業中分類 (code part) | `industry_code` | code as in the source |
| 産業中分類 (name part) | `industry_name` | docs/official/ecensus2021_classification.xlsx. AR, AB and CR are written A～R, A～B and C～R there |
| 事業所数 | `establishments` | ecensus2021_terms.pdf p.1: "Establishments" |
| 従業者数 | `persons_engaged` | ecensus2021_terms.pdf p.1: "Persons engaged" |
| 従業者数_うち常用雇用者 | `regular_employees` | ecensus2021_terms.pdf p.2: "Regular employees" |
| 従業者数_うち他への出向・派遣従業者数 | `loaned_dispatched_to_others` | ecensus2021_terms.pdf p.2: "Loaned or dispatched employees to other establishments" |
| 他からの出向・派遣従業者数 | `loaned_dispatched_from_others` | ecensus2021_terms.pdf p.2: "Loaned or dispatched employees from other establishments" |
| 他からの出向者数 | `loaned_from_others` | same section (出向 = loaned) |
| 他からの派遣者数 | `dispatched_from_others` | same section (派遣 = dispatched under the Worker Dispatch Act) |
| 事業従事者数 | `persons_working` | ecensus2021_terms.pdf p.2: "Persons working at the location" |

Each count column exists for both sexes (男女計, no suffix), `_male` (男) and `_female` (女).
Totals for both sexes include persons whose sex is not reported (note 1 of the source table).

## Business frame 2024, tables 4-1A and 4-1B (`frame2024_t4-1a.csv`, `frame2024_t4-1b.csv`)

One row per area; one column per industry, as in the source.
Values are establishments (4-1A; frame2024_terms.pdf p.1 "Establishments") or persons engaged
(4-1B; frame2024_terms.pdf p.1 "Persons engaged"). The survey excludes individual proprietorships
with no employees (frame2024_notes.pdf p.1).

| Source column / label | Column |
|---|---|
| 地域識別コード | `area_type` |
| 地域区分 (code part) | `area_code` |
| 項目名 (code part) of each industry column | column name = industry code (e.g. `AR`, `01`, `011`, `60C`) |

The English names of the industry columns are in `frame2024_industries.csv`, which translates the
header rows of the source:

| Source header row | Column | Content |
|---|---|---|
| 項目名 (code part) | `industry_code` | column name in `frame2024_t4-1a.csv` / `frame2024_t4-1b.csv` |
| 階層 | `industry_hierarchy` | 1 = aggregate, 2 = division, 3 = subdivision, 4 = major group, 5 = group, 6 = group used only in the economic census (letter in the 3rd digit) |
| 産業大分類 | `industry_division` | division code |
| 項目名 (name part) | `industry_name` | docs/official/frame2024_classification.pdf |

The 2021 and 2024 industry codes follow different revisions of the Japan Standard Industrial
Classification (Rev. 13 and Rev. 14), so the same code does not always mean the same industry.
