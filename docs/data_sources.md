# Data Sources and APIs

This file lists all datasets and APIs used in this project for modeling chronic disease risk and lifespan outcomes in aging populations.

---

## Public Datasets

### 1. **NHANES (USA)** (!!!DONE: COLLECTED AND PARSED!!!)
- **Source**: CDC
- **URL**: https://www.cdc.gov/nchs/nhanes/
- **Contains**: VO₂ max, bone density, lab values, disease status
- **Format**: XPT (SAS), requires pre-cleaning

### 2. **Canadian Health Measures Survey (CHMS)** (!! NO PUBLIC ACCESS!!)
- **Source**: Statistics Canada (restricted access)
- **URL**: https://www.statcan.gc.ca/en/subjects-start/health/chms
- **Contains**: VO₂ max, bone/muscle density, heart rate
- **Access**: Requires institutional approval

### 3. **UK Biobank** (!! NEED TO APPLY FOR ACCESS!!)
- **Source**: UK Biobank
- **URL**: https://www.ukbiobank.ac.uk/
- **Contains**: Longitudinal health + demographic data for 500k participants
- **Access**: Application required

---

## 🌐 Data Sources & APIs

Our project integrates multiple real-world data sources to support the prediction of chronic disease risk using physiological markers. Since full access to CHMS and UK Biobank is restricted, we are leveraging a mix of open APIs and public datasets:

### ✅ Primary Open-Access Sources

| Source | Type | What It Provides |
|--------|------|------------------|
| **WHO Global Health Observatory (GHO) API** | API | Chronic disease prevalence, risk factors (e.g., inactivity, obesity), VO₂ max estimates by country, age, and sex |
| **CDC Chronic Disease Indicators (CDI)** | API | U.S.-based chronic illness data with stratification by state, age group, sex, and ethnicity |
| **OpenML Biomedical Datasets** | Public CSV/Online API | Ready-to-model datasets covering physiological measures and health outcomes |
| **Fitbit Web API** | OAuth API | Individual-level VO₂ max, resting HR, sleep, and activity data (requires developer token) |

---

### 🔗 API Access Details

- **WHO GHO API:**  
  https://www.who.int/data/gho/info/gho-odata-api  
  (Access via `httr` or `jsonlite` in R)

- **CDC CDI API:**  
  https://chronicdata.cdc.gov/Chronic-Disease-Indicators/U.S.-Chronic-Disease-Indicators-CDI-/g4ie-h725  
  (Download CSV or use `RSocrata`/`httr`)

- **OpenML Biomedical Datasets:**  
  https://www.openml.org/search?type=data&status=active&tag=medical  
  (Use R packages `OpenML` or `mlr3oml`)

- **Fitbit Developer Portal:**  
  https://dev.fitbit.com/build/reference/web-api/  
  (OAuth access required for custom test accounts)

---

### 🛠️ Next Steps

We will begin by integrating WHO and CDC API calls into our pipeline using `R/httr`. Fitbit and OpenML may be used for simulation, benchmarking, or user-specific modeling.


---

## Notes
- Raw files will be saved in `data/raw/`
- Processed versions will be saved in `data/processed/`
- We will maintain metadata tracking inside `docs/` or a project-level README section

