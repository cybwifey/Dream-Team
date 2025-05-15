# Project Proposal – Predicting Chronic Illness and Lifespan Using Physiological Markers
Team: Sarina, Andrei, Adam, Adrian, Armarn

## Introduction
Finding early signs of chronic illness and functional decline is crucial for efficient healthcare planning and individualized interventions as populations age. Examining physiological measures that can be monitored and improved over time is an equally important and frequently overlooked method, even though much research concentrates on socioeconomic determinants of health (such as money, education, and access).
In this research, we investigate whether biophysical predictors—especially those that are trackable, accessible, and modifiable—can be used in a big data setting to estimate health-adjusted lifespan in aging adults and anticipate the development of chronic illness. Because they may be immediately altered by focused exercise, rehabilitation, and lifestyle modifications, metrics including VO₂ max, muscle mass, bone density, and resting heart rate (RHR) are effective public health levers.
Large-scale, standardized sources for these predictors are the World Health Organization's (WHO) Global Health Observatory³ and the National Health and Nutrition Examination Survey (NHANES)³. Our objective is to create an understandable and useful model that facilitates early risk identification and individualized aging care by combining machine learning, causal inference, and public health concepts.

## Research Question
Our goal is to find out if physiological measures like resting heart rate, muscle mass, bone density, and VO₂ max can be used to estimate lifespan outcomes and anticipate the emergence of chronic illnesses in aging populations. To find patterns in functional decline, we specifically want to simulate the direct and interactive impacts of these predictors over time. This involves assessing if simulations of specific health enhancements (such elevated VO₂ max) can produce quantifiable shifts in anticipated health risk. Additionally, we aim to investigate variation across subgroups, including socioeconomic background, age cohort, and sex. More proactive, individualized healthcare approaches for senior citizens can be made possible by a well-designed predictive framework based on physiological inputs.

## Methods Proposal

## Data Sources
Primary datasets:
- NHANES (U.S.)¹: Includes VO₂ max estimates, bone density, RHR, and disease status
- Canadian Health Measures Survey (CHMS)⁴: VO₂ max, body composition, lab results



## Supplemental APIs:
- WHO Global Health Observatory³
- CDC Chronic Disease Indicators (CDI)²
- Fitbit Web API⁶ and Garmin Health API⁷ (via open-source data proxies)


## Data Collection & Processing
We'll gather information through direct downloads and APIs, keeping track of all versions and saving raw files in a special subdirectory. Standardizing units (e.g., VO₂ max in ml/kg/min), normalizing across populations using z-scores, and imputing missing data using MICE or KNN techniques will all help to harmonize datasets. Domain-relevant thresholds will determine whether to include or exclude outliers. As part of feature engineering, time-based variables like resting heart rate stability or VO₂ max drop rate will be created.
Analysis & Modeling
Prior to moving on to machine learning techniques like random forests, gradient boosting (XGBoost), and deep learning, we will start with baseline statistical models (linear regression and logistic regression). Regularization and early halting will be incorporated into the models. Explainability will be attained by assessing feature importance using SHAP values. Directed acyclic graphs (DAGs) and counterfactual simulations (e.g., "What if VO₂ max were improved by 15%?") will be used to layer causal inference. If longitudinal data shows enough, time-series techniques like lag-based regressions or temporal convolutional networks (TCNs) may be investigated. The results' generalizability and equality will be evaluated through subgroup analysis by sex, age cohort, and socioeconomic position.
Evaluation
Sensitivity, specificity, F1-score, and AUC will be used to assess classification tasks. RMSE, MAE, and calibration curves will be used to assess lifespan prediction (regression). Performance assessments across subgroups and 10-fold cross-validation will be part of the validation process. When feasible, secondary testing may make use of other datasets (such as OpenML or wearable data supplied from GitHub).
Visual Outputs
We'll produce visuals like model calibration plots, correlation heatmaps, SHAP plots, and simulated result scenarios. Predicted risk by age group or by combinations of physiological markers will be shown on visual dashboards.

## Ethics & Equity
Every piece of data utilized in this project is de-identified and openly accessible, following the ethical guidelines established by WHO³ and NHANES¹. No personally identifiable information (PII) will be used by us. Using GitHub, our workflow will be completely replicable and version-controlled. To reduce algorithmic bias and enhance health equity in our modeling results, we will implement fairness checks across important demographic categories.

## Summary
This project's focus on physiological variables that are readily controllable provides a fresh, data-driven viewpoint on healthy aging. Our goal is to produce actionable insights to enable early chronic illness identification, lifespan extension, and equity in aging healthcare outcomes by fusing interpretable machine learning with extensive epidemiological data and causal reasoning.

## References
1. Centers for Disease Control and Prevention (CDC). National Health and Nutrition Examination Survey (NHANES) [Internet]. Atlanta (GA): CDC; 2024 [cited 2025 May 15]. Available from: https://wwwn.cdc.gov/nchs/nhanes/default.aspx

2. Centers for Disease Control and Prevention (CDC). U.S. Chronic Disease Indicators (CDI) [Internet]. Atlanta (GA): CDC; 2023 [cited 2025 May 15]. Available from: https://data.cdc.gov/Chronic-Disease-Indicators/U-S-Chronic-Disease-Indi/g4ie-h725

3. World Health Organization. Global Health Observatory (GHO) Indicator: Prevalence of insufficient physical activity among adults aged 18+ years (%), age-standardized estimate [Internet]. Geneva: WHO; 2023 [cited 2025 May 15]. Available from: https://www.who.int/data/gho/data/indicators/indicator-details/GHO/prevalence-of-insufficient-physical-activity-among-adults-aged-18-years-(age-standardized-estimate)-(-)

4. Statistics Canada. Canadian Health Measures Survey (CHMS) [Internet]. Ottawa: Government of Canada; 2024 [cited 2025 May 15]. Available from: https://www.statcan.gc.ca/en/subjects-start/health/chms

5. Fitbit Developers. Fitbit Web API Documentation [Internet]. San Francisco (CA): Fitbit Inc.; 2024 [cited 2025 May 15]. Available from: https://dev.fitbit.com/build/reference/web-api/

6. Garmin Developers. Garmin Health API [Internet]. Olathe (KS): Garmin Ltd.; 2024 [cited 2025 May 15]. Available from: https://developer.garmin.com/health-api/
