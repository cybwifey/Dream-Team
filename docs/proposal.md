# Project Proposal – Predicting Chronic Illness and Lifespan Using Physiological Markers (Sarina Etminan)

## Introduction

As populations age, identifying early indicators of chronic illness and functional decline becomes essential for effective healthcare planning and personalized interventions. While many studies focus on social determinants of health (e.g., income, education, access), an equally critical — and often underutilized — approach is to examine physiological metrics that can be measured and improved over time.

This project investigates whether biophysical predictors such as VO₂ max, muscle mass, bone density, and resting heart rate (RHR) can be used to accurately predict chronic illness onset and estimate health-adjusted lifespan in aging adults. These variables are directly modifiable through targeted exercise, rehabilitation, and lifestyle changes, making them powerful levers for public health.

By integrating big data, machine learning, and causal inference, our goal is to build an explainable, actionable AI model that supports early risk identification and personalized aging care.

---

## Research Question

**Primary Question**:  
*Can physiological metrics like VO₂ max, muscle mass, bone density, and resting heart rate predict chronic disease onset and lifespan outcomes in aging populations?*

**Sub-questions**:
- How do these predictors interact across time to signal increased health risk?
- Can targeted simulations show how improving these markers changes predicted outcomes?
- Do results vary by sex, age cohort, or socioeconomic context?

---

## Methods Proposal

### Data Sources
- **Primary Datasets**:
  - NHANES (U.S.): Includes fitness, lab values, chronic illness status
  - Canadian Health Measures Survey (CHMS): VO₂ max, bone/muscle density, heart rate
  - UK Biobank: Large-scale aging data with rich phenotype info

- **Supplemental APIs**:
  - Open wearable APIs (e.g., Garmin, Fitbit) for time-series data (if feasible)
  - WHO/CDC for chronic disease classification

---

### Data Collection & Processing
- Standardize across datasets (e.g., z-scores for VO₂ max, BMI normalization)
- Handle missingness using imputation (e.g., MICE or KNN)
- Drop or winsorize extreme outliers
- Transform time-based data into features (e.g., rate of decline in VO₂ max)
- Optional: join socioeconomic metadata (income, access to exercise facilities, etc.)

---

### Analysis & Modeling

#### Machine Learning Models
- **Baseline**: Logistic regression, linear regression
- **Advanced**:
  - Random Forests, Gradient Boosting (e.g., XGBoost)
  - Neural networks (with dropout + early stopping)
  - Multi-task learning for lifespan + chronic illness prediction
- **Explainability**:
  - SHAP values to identify top predictors per person
  - Visual risk profiles for interpretability

#### Causal Inference Layer
- DAGs (Directed Acyclic Graphs) to explore causal structure
- Counterfactual analysis (e.g., “What if VO₂ max were improved by 15%?”)

#### Time-Series/Longitudinal Methods (if data allows)
- Lagged regression for physiological decline
- Temporal convolutional networks (TCNs)
- Change-point detection for sudden drops in metrics

#### Subgroup Modeling
- Separate models by sex, age, or baseline health status
- Test for interaction effects (e.g., VO₂ max * muscle mass)

---

### Evaluation
- **Metrics**:
  - Chronic illness prediction: AUC, F1, sensitivity/specificity
  - Lifespan prediction: RMSE, MAE, calibration plots
- **Validation**:
  - 10-fold cross-validation
  - External test sets if available
  - Model fairness analysis across subgroups

---

### Visual Outputs
- Correlation matrices of physiological predictors
- Risk score dashboards by age group
- Simulated scenario plots (e.g., predicted risk pre/post fitness improvement)

---

## Ethics & Equity
- Data use follows all privacy and consent guidelines (public datasets only)
- Equity lens: test performance gaps across vulnerable subgroups
- Transparent documentation + reproducible workflow via Git/GitHub

---

## Summary
This project offers a novel perspective on aging by shifting the focus from passive risk identification to **actionable, personalized prediction** based on physiological metrics. With a blend of interpretable AI, causal reasoning, and public health relevance, it aims to contribute meaningfully to the field of data-driven healthy aging.
