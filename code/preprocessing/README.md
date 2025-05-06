# Data Preprocessing Pipeline

This folder contains scripts for collecting and cleaning raw health data for our project:  
**Predicting Chronic Illness & Lifespan in Aging Populations Using Physiological Markers.**

---

## Scripts Overview

### `01_pull_raw_data.R`
- **Purpose**: Pulls raw data from public APIs (e.g., WHO, CDC, NHANES) or downloads files.
- **Output**: Saves raw `.json` or `.csv` files to `data/raw/`.

### `02_clean_process_data.R`
- **Purpose**: Cleans, filters, transforms, and reshapes raw data for modeling.
- **Tasks**:
  - Handles missing values
  - Standardizes units (e.g., z-scores, BMI scaling)
  - Outputs clean `.csv` to `data/processed/`

---

## How to Run

1. Open `01_pull_raw_data.R`  
2. Run all chunks or use `source("01_pull_raw_data.R")`  
3. Once raw data is saved, run `02_clean_process_data.R` to clean and export

```r
# Example
source("01_pull_raw_data.R")
source("02_clean_process_data.R")
```

## File Structure Reference

```
Dream-Team/
├── data/
│   ├── raw/
│   │   └── api_vo2max_raw.json
│   └── processed/
│       └── vo2max_clean.csv
├── code/
│   └── preprocessing/
│       ├── 01_pull_raw_data.R
│       ├── 02_clean_process_data.R
│       └── README.md  ← ← ← (this file)
```
