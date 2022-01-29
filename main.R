---
author: "Pawe³ Pechta"
title: "Multinomial LR Model for predicting the outcomes of football matches"
---
  
install.packages("tidyverse")
install.packages("mice")
install.packages("caTools")
install.packages("corrplot")


# Source data import to create dataset

library(tidyverse)
dataset <- dir("data", full.names = T) %>% map_df(read_csv)



# Processing and Exploring Data (limiting number of variables and removing NA)

dataset <- dataset[c(2:10, 12:23)]


library(mice)
md.pattern(dataset)

dataset <- na.omit(dataset)

summary(dataset)
write.csv(dataset, "./dataset.csv", row.names=FALSE)


# Input Data preparation (removing multicollinear variables)

str(dataset)

df_corr <- dataset[,sapply(dataset, is.numeric)]

df_corr.cor = cor(df_corr, method = c("pearson"))

library(corrplot)
palette = colorRampPalette(c("green", "white", "red")) (20)
heatmap(x = df_corr.cor, col = palette, symm = TRUE)


df_corr <- df_corr[c(7:16)]

df_corr.cor = cor(df_corr, method = c("pearson"))

heatmap(x = df_corr.cor, col = palette, symm = TRUE)

input_data <- dataset[c(1:3, 6, 9, 12:21)]


# Splitting data into training and test sets to build and evaluate model

library(caTools)

set.seed(123)
sample = sample.split(input_data, SplitRatio = 0.70)
train = subset(input_data,sample == TRUE) 
test = subset(input_data, sample == FALSE)

write.csv(train, "./training/training.csv", row.names = FALSE)
write.csv(test, "./test/test.csv", row.names = FALSE)

# Building and Comparising Predictive Models (by AIC value)

train$FTR <- relevel(factor(train$FTR), ref = "D")
require(nnet)

# with all variables

multinom.model_1 <- multinom(FTR ~HST + AST + HF + AF + HC + AC + HY + AY
                             + HR + AR +1, data = train)
summary(multinom.model_1)  # coefficients and standard errors

summary <- summary(multinom.model_1)$coefficients/summary(multinom.model_1)$standard.errors
p <- (1 - pnorm(abs(summary), 0, 1)) * 2
head(p) # p-values

# with only relevant variables

multinom.model_2 <- multinom(FTR ~AST + HST + AF + HC + AC + HY + HR + AR +1,
                             data = train)
summary(multinom.model_2)

# model with only relevant variables has lower AIC value so should be better

summary <- summary(multinom.model_2)$coefficients/summary(multinom.model_2)$standard.errors
p <- (1 - pnorm(abs(summary), 0, 1)) * 2
head(p) # p-values

# 'HR' variables are relevant only for 'A' category of dependent variable,
# so can either be left or deleted from the model

exp(coef(multinom.model_2)) # odds ratio

multinom.model <- multinom.model_2 # rename model

# Predicting on Test Data

output <- test
output$Predicted <- predict(multinom.model, newdata = output, "class")
output <- output[c(1:4, 16)]
names(output)[4] <- "Actual"

write.csv(output, "./test/output.csv", row.names = FALSE)

# Evaluating the Model

install.packages('e1071', dependencies = TRUE)

observations <- factor(output$Actual,
                        levels = c("H", "A", "D"))

predicted <- factor(output$Predicted,
                       levels = c("H", "A", "D"))

conf <- table(predicted, observations)


library(caret) 
f.conf <- confusionMatrix(conf)


install.packages('yardstick')
library(yardstick)
library(ggplot2)

set.seed(123)
mat_conf <- data.frame(
  FTR = sample(0:1,1325, replace = T),
  predicted = sample(0:1,1325, replace = T)
)
mat_conf$FTR <- observations
mat_conf$predicted <- predicted

cm <- conf_mat(mat_conf, FTR, predicted)

# Confusion matrix  to assess the quality of classification on a test set

autoplot(cm, type = "heatmap") +
  scale_fill_gradient(low = "aquamarine1", high = "firebrick1")

print(f.conf)
