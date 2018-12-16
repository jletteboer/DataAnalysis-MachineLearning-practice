model_selectin <- function(train_df, outcome, n_sample = 0.2) {
  ## Turning off warnings
  options(warn=-1)
  library(caret)

  outcomes.eq <- paste(outcome, "~.")
  outcomes.formula <- as.formula(outcomes.eq)

  # Define subset rows default: 20% of total train_df
  # train2 <- train_df[1:2000,]
  n <- round(nrow(train_df) * n_sample)
  train_subset <- train_df[sample(nrow(train_df), n), ]

  #x = nearZeroVar(train_subset, saveMetrics = TRUE)
  #x

  control <- trainControl(method="repeatedcv", number=10, repeats=3)
  seed <- 123
  metric <- "Accuracy"

  # Linear Discriminant Analysis
  message("Learning: Linear Discriminant Analysis")
  set.seed(seed)
  fit.lda <- train(outcomes.formula, data=train_subset, method="lda", metric=metric, preProc=c("center", "scale"), trControl=control)
  # Logistic Regression
  #message("Learning: Logistic Regression")
  #set.seed(seed)
  #fit.glm <- train(outcomes.formula, data=train_subset, method="glm", metric=metric, trControl=control)
  # GLMNET
  message("Learning: GLMNET")
  set.seed(seed)
  fit.glmnet <- train(outcomes.formula, data=train_subset, method="glmnet", metric=metric, preProc=c("center", "scale"), trControl=control)
  # SVM Radial
  message("Learning: SVM Radial")
  set.seed(seed)
  fit.svmRadial <- train(outcomes.formula, data=train_subset, method="svmRadial", metric=metric, preProc=c("center", "scale"), trControl=control, fit=FALSE)
  # kNN
  message("Learning: kNN")
  set.seed(seed)
  fit.knn <- train(outcomes.formula, data=train_subset, method="knn", metric=metric, preProc=c("center", "scale"), trControl=control)
  # Naive Bayes
  message("Learning: Naive Bayes")
  set.seed(seed)
  fit.nb <- train(outcomes.formula, data=train_subset, method="nb", metric=metric, trControl=control)
  # CART
  message("Learning: CART")
  set.seed(seed)
  fit.cart <- train(outcomes.formula, data=train_subset, method="rpart", metric=metric, trControl=control)
  # C5.0
  #set.seed(seed)
  #fit.c50 <- train(outcomes.formula, data=train_subset, method="C5.0", metric=metric, trControl=control)
  # Bagged CART
  message("Learning: Bagged CART")
  set.seed(seed)
  fit.treebag <- train(outcomes.formula, data=train_subset, method="treebag", metric=metric, trControl=control)
  # Random Forest
  message("Learning: Random Forest")
  set.seed(seed)
  fit.rf <- train(outcomes.formula, data=train_subset, method="rf", metric=metric, trControl=control)
  # Stochastic Gradient Boosting (Generalized Boosted Modeling)
  message("Learning: Stochastic Gradient Boosting (Generalized Boosted Modeling)")
  set.seed(seed)
  fit.gbm <- train(outcomes.formula, data=train_subset, method="gbm", metric=metric, trControl=control, verbose=FALSE)
  # Extreme Gradient Boosting
  #message("Learning: Extreme Gradient Boosting")
  #set.seed(seed)
  #fit.egb <- train(outcomes.formula, data=train_subset, method="xgbTree", metric=metric, trControl=control, verbose=FALSE)

  #
  message("Done Leearing!")

  # 
  #results <- resamples(list(lda=fit.lda, logistic=fit.glm, glmnet=fit.glmnet,
  #                      svm=fit.svmRadial, knn=fit.knn, nb=fit.nb, cart=fit.cart,
  #                      bagging=fit.treebag, rf=fit.rf, egb=fit.egb))
  
  results <- resamples(list(lda=fit.lda, glmnet=fit.glmnet,
                            svm=fit.svmRadial, knn=fit.knn, nb=fit.nb, cart=fit.cart,
                            bagging=fit.treebag, rf=fit.rf))

  results_sumary <- summary(results)
  print(results_sumary)
}
