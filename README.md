# Data Management Project

## Theme
How does population ageing impact the structure of local economies in Japan, and does this relationship differ between urban and rural municipalities?

## Data

Population census of Japan - Statistics Bureau of Japan 

- Official census website

- Table 2-7-2: Population composition by age

- Table 2-8: Population and population in Densely Inhabited Districts (DIDs)

Economic census for business activity- Statistics Bureau of Japan 

- Official census website and methodology

- Table 6-1: Establishments and persons engaged by industry, at municipality level

### Downloaded files

Raw files were downloaded from e-Stat (https://www.e-stat.go.jp/en) without modification.
The Excel files are published in Japanese only. Each file can be re-downloaded with
`https://www.e-stat.go.jp/stat-search/file-download?statInfId=<ID>&fileKind=0`.

| File | Survey | Table | statInfId |
|---|---|---|---|
| `data/raw/census2020_t2-7.xlsx` | 2020 Population Census, Basic Complete Tabulation | 2-7 Population by sex and age (5-year groups, 3 groups), composition ratio, mean/median age – Japan, prefectures, municipalities | 000032142410 |
| `data/raw/census2020_t2-8.xlsx` | 2020 Population Census, Basic Complete Tabulation | 2-8 Same as 2-7, DIDs (Densely Inhabited Districts) of each municipality | 000032142411 |
| `data/raw/census2025_t2-7.xlsx` | 2025 Population Census, Basic Complete Tabulation (original values) | 2-7 (same layout as 2020) | 000040506431 |
| `data/raw/census2025_t2-8.xlsx` | 2025 Population Census, Basic Complete Tabulation (original values) | 2-8 (same layout as 2020) | 000040506432 |
| `data/raw/ecensus2021_t6-1.xlsx` | 2021 Economic Census for Business Activity (latest edition) | 6-1 Privately owned establishments and persons engaged by industry (medium groups) – Japan, prefectures, municipalities | 000040067880 |
| `data/raw/frame2024_t4-1a.xlsx` | 2024 Economic Census for Business Frame | 4-1A Privately owned establishments by industry (minor groups) – municipalities (excl. sole proprietors without employees) | 000040389324 |
| `data/raw/frame2024_t4-1b.xlsx` | 2024 Economic Census for Business Frame | 4-1B Persons engaged by industry (minor groups) – municipalities (excl. sole proprietors without employees) | 000040389325 |

### CSV data

`Script/translate.R` converts each raw Excel file in `data/raw/` into an English CSV in `data/csv/`.

- Translates headers and identifier labels into English and drops Japanese area names.
- `frame2024_industries.csv` maps the industry column codes in `frame2024_t4-1a.csv` / `t4-1b.csv` to their English names.
- Full column definitions and translation sources: [`docs/codebook.md`](docs/codebook.md).

### Methodology documents

English documents from the Statistics Bureau of Japan, stored in `docs/official/` without modification.
For the 2025 Population Census, the Statistics Bureau links the 2020 outline and explanation of terms;
only the questionnaire is specific to 2025.

| File | Content | Source |
|---|---|---|
| `docs/official/census2020_outline.pdf` | 2020 Population Census – outline of the survey | https://www.stat.go.jp/english/data/kokusei/2020/pdf/outline.pdf |
| `docs/official/census2020_terms.pdf` | 2020 Population Census – explanation of terms | https://www.stat.go.jp/english/data/kokusei/2020/pdf/exp.pdf |
| `docs/official/census2025_questionnaire.pdf` | 2025 Population Census – questionnaire | https://www.stat.go.jp/english/data/kokusei/2025/pdf/qre.pdf |
| `docs/official/ecensus2021_outline.pdf` | 2021 Economic Census for Business Activity – outline | https://www.stat.go.jp/english/data/e-census/2021/pdf/k_gaikyoe.pdf |
| `docs/official/ecensus2021_terms.pdf` | 2021 Economic Census for Business Activity – explanation of terms | https://www.stat.go.jp/english/data/e-census/2021/pdf/k_term.pdf |
| `docs/official/ecensus2021_notes.pdf` | 2021 Economic Census for Business Activity – notes on the statistical tables | https://www.stat.go.jp/english/data/e-census/2021/pdf/k_note.pdf |
| `docs/official/ecensus2021_categories.pdf` | 2021 Economic Census for Business Activity – items of category used in the tables | https://www.stat.go.jp/english/data/e-census/2021/pdf/bunruie.pdf |
| `docs/official/ecensus2021_classification.xlsx` | 2021 Economic Census for Business Activity – industrial classification (English names of all industry codes in table 6-1) | https://www.stat.go.jp/english/data/e-census/2021/zuhyou/r3classification.xlsx |
| `docs/official/frame2024_outline.pdf` | 2024 Economic Census for Business Frame – outline | https://www.stat.go.jp/english/data/e-census/2024/pdf/kou_gaiyou_e.pdf |
| `docs/official/frame2024_terms.pdf` | 2024 Economic Census for Business Frame – explanation of terms | https://www.stat.go.jp/english/data/e-census/2024/pdf/kou_yougo_e.pdf |
| `docs/official/frame2024_notes.pdf` | 2024 Economic Census for Business Frame – notes on the statistical tables | https://www.stat.go.jp/english/data/e-census/2024/pdf/kou_riyou_e.pdf |
| `docs/official/frame2024_classification.pdf` | 2024 Economic Census for Business Frame – industrial classification, JSIC Rev. 14 (English names of all industry codes in tables 4-1A/4-1B) | https://www.stat.go.jp/english/data/e-census/2024/pdf/sangyou_e.pdf |


## git commands
1. Before working: `git pull`
2. Stage a changed file: `git add <filename>`
3. Commit the change: `git commit -m "Describe the change "`
4. Push the commit to main: `git push`
    - for the first push of a new branch: `git push -u origin <branch-name>`

commit regularly with each commit representing one logical change 


## AI Usage
- The raw data files in `data/raw/` and the methodology documents in `docs/official/` were retrieved from e-Stat and the Statistics Bureau of Japan website using Claude in Chrome.
- Because the downloaded e-Stat Excel files are in Japanese only, AI was used to write `Script/translate.R`, extract `data/csv/frame2024_industries.csv`, and draft `docs/codebook.md` using the official English classifications and glossaries in `docs/official/` (`ecensus2021_classification.xlsx`, `frame2024_classification.pdf`, `*_terms.pdf`). Only headers and labels were translated.
