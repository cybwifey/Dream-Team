# Project Proposal – Predicting Chronic Illness and Lifespan Using Physiological Markers  
*Team: Sarina, Andrei, Adam, Adrian, Armarn*

---

## Introduction

As populations age, identifying early indicators of chronic illness and functional decline becomes essential for effective healthcare planning and personalized interventions. While many studies focus on social determinants of health (e.g., income, education, access), an equally critical — and often underutilized — approach is to examine physiological metrics that can be measured and improved over time.

In this project, we explore whether biophysical predictors—particularly those that are accessible, trackable, and modifiable—can be used in a big data context to predict chronic illness onset and estimate health-adjusted lifespan in aging adults. Metrics such as VO₂ max, muscle mass, bone density, and resting heart rate (RHR) are directly modifiable through targeted exercise, rehabilitation, and lifestyle changes, making them powerful levers for public health. Data from the **National Health and Nutrition Examination Survey (NHANES)** and **World Health Organization (WHO)** open-access repositories offer large-scale, standardized inputs for this work. By integrating machine learning, causal inference, and public health principles, our goal is to build an explainable and actionable model that supports early risk identification and personalized aging care.

---

## Research Question

We aim to investigate whether physiological metrics such as VO₂ max, muscle mass, bone density, and resting heart rate can be used to predict chronic illness onset and estimate lifespan outcomes in aging populations. Specifically, we are interested in modeling both direct and interactive effects of these predictors over time to identify trends in functional decline. This includes evaluating whether simulations of targeted health improvements (e.g., increased VO₂ max) can yield measurable changes in predicted health risk. We also seek to explore variation across subgroups such as sex, age cohort, and socioeconomic background. A well-formulated predictive framework based on physiological inputs can enable more proactive, personalized healthcare strategies for older adults.

---

## Methods Proposal

### Data Sources
- **Primary Datasets**:
  - NHANES (U.S.): Includes VO₂ max estimates, bone density, RHR, disease status
  - Canadian Health Measures Survey (CHMS): VO₂ max, body composition, lab results
  - UK Biobank: Longitudinal cohort data with phenotype + health outcomes

- **Supplemental APIs**:
  - WHO Global Health Observatory API (e.g., physical inactivity, VO₂ max estimates)
  - CDC Chronic Disease Indicators (CDI)
  - Fitbit and Garmin APIs (via open-source GitHub data for simulation/benchmarking)

---

### Data Collection & Processing
- Collect via APIs and direct downloads, saving to `data/raw/`
- Standardize units and values across datasets (e.g., z-scores for VO₂ max, BMI normalization)
- Handle missingness with MICE/KNN; drop or winsorize outliers
- Derive features like rate of change in VO₂ max or muscle mass over time
- Optionally enrich with socioeconomic metadata (e.g., income, education, geographic access)

---

### Analysis & Modeling

#### Machine Learning Models
- **Baseline**: Logistic + linear regression
- **Advanced**: Random forests, gradient boosting, deep learning (with dropout + early stopping)
- **Explainability**: SHAP values for local + global interpretability

#### Causal Inference
- DAGs to understand predictor relationships
- Counterfactual simulation (e.g., predicted benefit of fitness improvements)

#### Time-Series/Longitudinal (if feasible)
- Lagged predictors, TCNs, change-point detection

#### Subgroup Modeling
- Stratify by sex, age, health status
- Include interaction terms (e.g., VO₂ max × muscle mass)

---

### Evaluation
- **Metrics**:
  - Classification: AUC, sensitivity/specificity, F1
  - Regression: RMSE, MAE, R², calibration curves
- **Validation**:
  - 10-fold CV
  - Model fairness across subgroups
  - External test data (if available)

---

### Visual Outputs
- Correlation plots, SHAP variable importance
- Simulated health scenarios (e.g., "What if VO₂ max ↑15%?")
- Risk stratification dashboards by age group

---

## Ethics & Equity

All data used in this project are publicly available and de-identified, adhering to ethical use standards set by **NHANES** (CDC) and **WHO** data use guidelines. We will not use any personally identifiable information (PII), and all analysis will be reproducible and transparent via GitHub. We will also examine subgroup performance to ensure model fairness and equity across demographic strata.

---

## Summary

This project offers a novel, data-driven perspective on healthy aging by focusing on directly modifiable physiological predictors. By combining interpretable machine learning with large-scale epidemiological data and causal reasoning, we aim to generate actionable insights to support early chronic illness detection, lifespan extension, and equity in aging healthcare outcomes.

---
## References

1. Centers for Disease Control and Prevention (CDC). National Health and Nutrition Examination Survey (NHANES) [Internet]. Atlanta (GA): CDC; 2024 [cited 2025 May 15]. Available from: https://wwwn.cdc.gov/nchs/nhanes/default.aspx

2. Centers for Disease Control and Prevention (CDC). U.S. Chronic Disease Indicators (CDI) [Internet]. Atlanta (GA): CDC; 2023 [cited 2025 May 15]. Available from: https://data.cdc.gov/Chronic-Disease-Indicators/U-S-Chronic-Disease-Indi/g4ie-h725

3. World Health Organization. Global Health Observatory (GHO) Indicator: Prevalence of insufficient physical activity among adults aged 18+ years (%), age-standardized estimate [Internet]. Geneva: WHO; 2023 [cited 2025 May 15]. Available from: https://www.who.int/data/gho/data/indicators/indicator-details/GHO/prevalence-of-insufficient-physical-activity-among-adults-aged-18-years-(age-standardized-estimate)-(-)

4. Statistics Canada. Canadian Health Measures Survey (CHMS) [Internet]. Ottawa: Government of Canada; 2024 [cited 2025 May 15]. Available from: https://www.statcan.gc.ca/en/subjects-start/health/chms

5. Fitbit Developers. Fitbit Web API Documentation [Internet]. San Francisco (CA): Fitbit Inc.; 2024 [cited 2025 May 15]. Available from: https://dev.fitbit.com/build/reference/web-api/

6. Garmin Developers. Garmin Health API [Internet]. Olathe (KS): Garmin Ltd.; 2024 [cited 2025 May 15]. Available from: https://developer.garmin.com/health-api/



