
install.packages("tidyverse")
install.packages("mice")
install.packages("caTools")
install.packages("corrplot")


# Source data import



library(tidyverse)

dataset <- dir("source_data", full.names = T) %>% map_df(read_csv) # Import of source data files about 2011/2012 - 2020/2021 seasons



# Processing and Exploring Data


dataset <- dataset[c(2:10, 12:23)] # Keep only game statistics in dataset
# What means delete of qualitative variables and statistics about betting from source datasets 

library(mice)
md.pattern(dataset) # Checking for missing values in dataset

dataset <- na.omit(dataset) # Removing empty row


summary(dataset)


write.csv(dataset, "./dataset.csv", row.names=FALSE)



# Input Data preparation



# Removing multicollinear variables as an assumption of logistic regression

str(dataset)

df_corr <- dataset[,sapply(dataset, is.numeric)] # Leaving only numeric type variables 

df_corr.cor = cor(df_corr, method = c("pearson")) # Creating correlation matrix

library(corrplot)

palette = colorRampPalette(c("green", "white", "red")) (20)
heatmap(x = df_corr.cor, col = palette, symm = TRUE) # Visualizing the correlation matrix

df_corr <- df_corr[c(7:16)] # Removing multicollinear variables 

df_corr.cor = cor(df_corr, method = c("pearson"))

heatmap(x = df_corr.cor, col = palette, symm = TRUE)



# Splitting the data into training and test datasets



input_data <- dataset[c(1:3, 6, 9, 12:21)]
write.csv(input_data, "./input_data.csv", row.names = FALSE) # Creating set without multicollinear variables


library(caTools)

set.seed(123)   #  Setting seed to ensure have same random numbers generated
sample = sample.split(input_data,SplitRatio = 0.70) # Splitting the data 70:30 ratio into training and test set
train = subset(input_data,sample == TRUE) 
test = subset(input_data, sample == FALSE)

write.csv(train, "./training/training.csv", row.names = FALSE) # Export training dataframe to csv file
write.csv(test, "./testing/test.csv", row.names = FALSE) # Export test dataframe to csv file
