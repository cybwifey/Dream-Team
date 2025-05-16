# Data Sources and APIs

This document tracks all datasets and APIs used or planned for use in our project:  
**Predicting Chronic Disease Risk and Lifespan in Aging Populations Using Physiological Markers.**

---

## ✅ Active Data Sources (Used)

### 1. **NHANES (USA)** ✅ *(Collected & Parsed)*
- **Source**: Centers for Disease Control and Prevention (CDC)
- **URL**: [NHANES Portal](https://www.cdc.gov/nchs/nhanes/)
- **Contains**: VO₂ max, bone density, lab values, disease status
- **Format**: XPT (SAS export), parsed using R
- **Status**: ✅ Data collected, cleaned, and in use

### 2. **WHO Global Health Observatory (GHO) API** ✅ *(Used in modeling pipeline)*
- **URL**: [WHO GHO API](https://ghoapi.azureedge.net/api/NCD_PA_001)
- **Provides**: Global estimates of physical inactivity, VO₂ max, and chronic disease prevalence
- **Status**: ✅ Integrated into `fetch_who_inactivity.R` using `httr`

### 3. **CDC Chronic Disease Indicators (CDI) API** ✅ *(Used in preprocessing)*
- **URL**: [CDC CDI Portal](https://chronicdata.cdc.gov/Chronic-Disease-Indicators/U.S.-Chronic-Disease-Indicators-CDI-/g4ie-h725)
- **Provides**: U.S. stratified data on inactivity, obesity, diabetes, and more
- **Status**: ✅ Used in data enrichment and feature development

---

## Restricted or Pending Access

### 4. **Canadian Health Measures Survey (CHMS)** ❌ *(Not used – restricted access)*
- **Source**: Statistics Canada
- **URL**: [CHMS](https://www.statcan.gc.ca/en/subjects-start/health/chms)
- **Note**: Access requires institutional approval — not pursued

### 5. **UK Biobank** ❌ *(Not used – application required)*
- **Source**: UK Biobank Consortium
- **URL**: [UK Biobank](https://www.ukbiobank.ac.uk/)
- **Note**: Requires formal access application and ethics clearance

---

## Optional / Future Sources

### OpenML Biomedical Datasets
- **URL**: [OpenML Medical Data](https://www.openml.org/search?type=data&status=active&tag=medical)
- **Use Case**: Supplementary testing or benchmark modeling

### Fitbit Web API
- **URL**: [Fitbit Developer Portal](https://dev.fitbit.com/build/reference/web-api/)
- **Note**: OAuth setup required; may be used for future simulation or validation

### Garmin Health API (via open-source proxies)
- **Official API**: [Garmin Health API Docs](https://developer.garmin.com/health-api/)
- **Note**: Closed API, but we may use datasets published by GitHub users who have scraped or shared anonymized Garmin data
- **Use Case**: Supplemental physiological metrics (VO₂ max, HR, activity trends)

---

## File Workflow

- `data/raw/` – Original files from APIs and downloads
- `data/processed/` – Cleaned, reshaped, and feature-ready datasets
- `docs/` – Data source tracking, proposal drafts, and research logs

---

## Next Steps

- [x] Automate WHO and CDC fetches via `httr` scripts
- [x] Continue NHANES parsing and feature selection
- [ ] Document variable joins and assumptions in data dictionary
- [ ] Evaluate OpenML, Fitbit, and Garmin-derived GitHub data for enrichment

---


## Notes
- Raw CSV files will be saved in `data/raw/`
- Processed CSV versions will be saved in `data/processed/`
- We will maintain metadata tracking inside `docs/` or a project-level README section
