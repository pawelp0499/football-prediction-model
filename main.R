---
author: "Pawe³ Pechta"
title: "Multinomial LR Model for predicting the outcomes of football matches"
---
  
install.packages("tidyverse")
install.packages("mice")
install.packages("caTools")
install.packages("corrplot")
install.packages("styler")


# Source data import to create dataset

library(tidyverse)
dataset <- dir("source_data", full.names = T) %>% map_df(read_csv)



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


# Splitting data into training and testing datasets to build and evaluate model

library(caTools)

set.seed(123)
sample = sample.split(input_data,SplitRatio = 0.70)
train = subset(input_data,sample == TRUE) 
test = subset(input_data, sample == FALSE)

write.csv(train, "./training/training.csv", row.names = FALSE)
write.csv(test, "./testing/test.csv", row.names = FALSE)
