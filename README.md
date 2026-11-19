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

Methodology documents (English, Statistics Bureau of Japan) are in `docs/`:
census outline and definitions (https://www.stat.go.jp/english/data/kokusei/2020/),
economic census outline, terms, notes and industry classification (https://www.stat.go.jp/english/data/e-census/2021/).


## git commands
1. Before working: `git pull`
2. Stage a changed file: `git add <filename>`
3. Commit the change: `git commit -m "Describe the change "`
4. Push the commit to main: `git push`
    - for the first push of a new branch: `git push -u origin <branch-name>`

commit regularly with each commit representing one logical change 
