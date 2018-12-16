library(dplyr)
library(caret)

# Load datasets
train <- read.csv("data/train.csv", header = TRUE, stringsAsFactors = FALSE)
test <- read.csv("data/test.csv", header = TRUE, stringsAsFactors = FALSE)

# Change AnimalID to ID
names(train)[1] <- "ID"

# Change test$ID to character
test$ID <- as.character(test$ID)

# Add extra column for classify is its train or test set before combing
train$istrain <- TRUE
test$istrain <- FALSE

# Combine datasets into one full
full <- bind_rows(train, test)

# Has no name
full$has_name <- 1
full$has_name[full$Name == ""] <- 0

# Age unknown
full$AgeuponOutcome[full$AgeuponOutcome == ""] <- "Unknown"

# Sex unknown to Most
table(train$SexuponOutcome)
full$SexuponOutcome[full$SexuponOutcome == ""] <- "Male"

# Date and time convertion, including leap year
is.leapyear=function(year){
  #http://en.wikipedia.org/wiki/Leap_year
  return(((year %% 4 == 0) & (year %% 100 != 0)) | (year %% 400 == 0))
}

full$year <- year(full$DateTime)
full$month <- month(full$DateTime)
full$wday <- wday(full$DateTime)
full$hour <- hour(full$DateTime)
full$leap_year <- is.leapyear(full$year)

# calculate the age of the animal in days by converting TimeValue in days using the appropriate multiplier based on UnitofTime
multiplier <- ifelse(grepl("day", full$AgeuponOutcome) , 1, 
                     ifelse(grepl("week", full$AgeuponOutcome) , 7, 
                            ifelse(grepl("month", full$AgeuponOutcome), 30,
                                   ifelse(grepl("year", full$AgeuponOutcome) & grepl("FALSE", full$leap_year) , 365,
                                          ifelse(grepl("year", full$AgeuponOutcome) & grepl("TRUE", full$leap_year) , 366,
                                                 NA)))))

# get the time value
full$TimeValue <- sapply(full$AgeuponOutcome, function(x) strsplit(x, split = ' ')[[1]][1])
full$TimeValue <- as.numeric(full$TimeValue)
full$AgeinDays <- multiplier * full$TimeValue
# Impute missing age values by replacing the NAs with th mean age
full$AgeinDays <- ifelse(is.na(full$AgeinDays), mean(full$AgeinDays, na.rm = T), full$AgeinDays)

full1 <- full

# Factorize the data for Classification
factorize = c('OutcomeType', 'AnimalType', 'SexuponOutcome', 
              'Breed', 'Color')

full1[factorize] <- lapply(full1[factorize], function(x) as.factor(x))

# Split to train and test
train1 <- full1[full1$istrain == TRUE,]
test1 <- full1[full1$istrain == FALSE,]
test1 <- subset(test1, select = -c(OutcomeType, OutcomeSubtype))

# Define model variables
outcomes.eq <- "OutcomeType ~."
outcomes.formula <- as.formula(outcomes.eq)
train2 <- subset_train1[1:5000,]
x = nearZeroVar(train2, saveMetrics = TRUE)
x

control <- trainControl(method="repeatedcv", number=10, repeats=3, summaryFunction = mnLogLoss,)
seed <- 123
metric <- "Accuracy"

# Stochastic Gradient Boosting (Generalized Boosted Modeling)
set.seed(seed)
fit.gbm_full <- train(outcomes.formula, data=train1, method="gbm", metric=metric, trControl=control, verbose=FALSE)

pred <- predict(fit.gbm_full, test1, type="prob")
pred_outcome <- bind_cols(test1["ID"], pred)
pred_outcome %>% write.csv("sub_full.csv", row.names=FALSE)

