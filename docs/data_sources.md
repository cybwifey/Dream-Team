# 📊 Data Sources and APIs

This file lists all datasets and APIs used in this project for modeling chronic disease risk and lifespan outcomes in aging populations.

---

## Public Datasets

### 1. **NHANES (USA)** (!!!DONE: COLLECTED AND PARSED!!!)
- **Source**: CDC
- **URL**: https://www.cdc.gov/nchs/nhanes/
- **Contains**: VO₂ max, bone density, lab values, disease status
- **Format**: XPT (SAS), requires pre-cleaning

### 2. **Canadian Health Measures Survey (CHMS)**
- **Source**: Statistics Canada (restricted access)
- **URL**: https://www.statcan.gc.ca/en/subjects-start/health/chms
- **Contains**: VO₂ max, bone/muscle density, heart rate
- **Access**: Requires institutional approval

### 3. **UK Biobank**
- **Source**: UK Biobank
- **URL**: https://www.ukbiobank.ac.uk/
- **Contains**: Longitudinal health + demographic data for 500k participants
- **Access**: Application required

---

## APIs

### 1. **Simulated API (placeholder)**
- **URL**: `https://api.example.org/data?country=CAN&indicator=VO2MAX`
- **Use**: Demo + testing JSON fetch and flattening

### 2. **Wearable APIs (optional/expansion)**
- **Fitbit Web API**: https://dev.fitbit.com/build/reference/web-api/
- **Strava API**: https://developers.strava.com/
- **Garmin Health API**: https://developer.garmin.com/health-api/
- **Use**: Real-time VO₂ max, resting HR, step count

---

## Notes
- Raw files will be saved in `data/raw/`
- Processed versions will be saved in `data/processed/`
- We will maintain metadata tracking inside `docs/` or a project-level README section

