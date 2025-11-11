##############################################################
# Title: Multi-Label Chronic Illness Classifier (Wearable Data)
# Author: Sarina Etminan
#
# Description:
# This script builds predictive models to classify four chronic illnesses 
# (Parkinsonism, Osteoporosis, Heart Failure, Dementia) in older adults 
# using wearable and physiological data from the All of Us dataset.
#
# Workflow:
# - Filters complete cases only (no missing predictors)
# - Loops over four binary target conditions (has_*)
# - For each condition:
#   - Trains 3 classifiers:
#     • Logistic Regression
#     • Random Forest
#     • XGBoost
#   - Performs 5-fold cross-validation using caret
#   - Evaluates test set performance: Accuracy, F1, AUC
#   - Extracts top 5 most important features from XGBoost and RF
#
# Notes:
# - The dataset is filtered to ~2,000 participants with full wearable data
# - No imputation is performed — only complete cases are modeled
# - Results can be used to assess which physiological/behavioral markers
#   best predict specific chronic illness outcomes
##############################################################


# Load libraries
library(caret)
library(dplyr)
library(pROC)
library(xgboost)
library(randomForest)

# Set seed
set.seed(123)

# Filter to complete cases (excluding person_id and label columns)
predictor_cols <- c(
  "avg_steps", "avg_calories_out", "avg_bmr", "avg_sedentary",
  "avg_very_active", "avg_lightly_active", "avg_fairly_active",
  "avg_floors", "avg_elevation", "avg_hr_min", "avg_hr_max",
  "total_minutes_in_zone", "avg_calories_hr", "avg_sleep_minutes",
  "avg_time_in_bed", "avg_deep_sleep", "avg_light_sleep",
  "avg_rem_sleep", "avg_wake_minutes", "Body weight", 
  "Diastolic blood pressure", "Systolic blood pressure", 
  "Body mass index (BMI) [Ratio]"
)

label_cols <- c("has_4140090", "has_80502", "has_316139", "has_4182210")

# Ensure all required columns exist
stopifnot(all(c(predictor_cols, label_cols) %in% names(df)))

# Drop rows with any NA in predictors
df_clean <- df %>%
  filter(if_all(all_of(predictor_cols), ~ !is.na(.)))

# Loop through conditions
for (label in label_cols) {
  
  cat("\n========== Modeling for", label, "==========\n")

  # Prepare dataset
  data_model <- df_clean %>%
    select(all_of(c(label, predictor_cols)))
  data_model[[label]] <- factor(data_model[[label]], levels = c(0, 1), labels = c("No", "Yes"))
  
  # Train/test split
  train_index <- createDataPartition(data_model[[label]], p = 0.75, list = FALSE)
  train_data <- data_model[train_index, ]
  test_data  <- data_model[-train_index, ]
  
  # Set up 5-fold CV
  ctrl <- trainControl(
    method = "cv",
    number = 5,
    summaryFunction = twoClassSummary,
    classProbs = TRUE,
    savePredictions = "final"
  )
  
  ### Logistic Regression
  logit_model <- train(
    reformulate(predictor_cols, response = label),
    data = train_data,
    method = "glm",
    family = "binomial",
    trControl = ctrl,
    metric = "ROC"
  )
  
  ### Random Forest
  rf_model <- train(
    reformulate(predictor_cols, response = label),
    data = train_data,
    method = "rf",
    trControl = ctrl,
    metric = "ROC"
  )
  
  ### XGBoost
  xgb_model <- train(
    reformulate(predictor_cols, response = label),
    data = train_data,
    method = "xgbTree",
    trControl = ctrl,
    metric = "ROC",
    tuneLength = 5
  )
  
  ### Evaluate on test set
  models <- list(Logit = logit_model, RF = rf_model, XGB = xgb_model)
  
  for (model_name in names(models)) {
    model <- models[[model_name]]
    probs <- predict(model, newdata = test_data, type = "prob")[, "Yes"]
    preds <- predict(model, newdata = test_data)
    
    roc_obj <- roc(test_data[[label]], probs)
    auc_val <- auc(roc_obj)
    
    cm <- confusionMatrix(preds, test_data[[label]], positive = "Yes")
    acc <- cm$overall["Accuracy"]
    f1 <- 2 * (cm$byClass["Precision"] * cm$byClass["Recall"]) / 
              (cm$byClass["Precision"] + cm$byClass["Recall"])
    
    cat(sprintf("\n--- %s ---\n", model_name))
    cat(sprintf("Accuracy: %.3f | F1: %.3f | AUC: %.3f\n", acc, f1, auc_val))
  }
  
  ### Feature importance (XGB + RF)
  cat("\nTop Features:\n")
  cat("XGBoost:\n")
  print(varImp(xgb_model)$importance %>% arrange(desc(Overall)) %>% head(5))
  
  cat("\nRandom Forest:\n")
  print(varImp(rf_model)$importance %>% arrange(desc(Overall)) %>% head(5))
  
  cat("\n===============================\n")
}
