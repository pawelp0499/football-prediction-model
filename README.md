# Multinomial Logistic Regression Model to predict football outcomes
Multinomial logistic regression model for predicting the outcomes of football matches developed in R

### Purpose of Project

**The main goal of this project is to present usability and build Machine Learning Model based on Multinomial Logistic Regression for predicting the results of football matches (the English Premier League was used as an example for the analysis). Script presents the process of data exploring and cleansing, model building and evaluation and practical use to predict the outcomes of future football matches. 
Source data includes statistics since the 2011/2012 season to the mid-2021/2022 season.**

🔸 Source CSV files come from the site https://www.football-data.co.uk/

### Description of used variables

◾ Date - Match date (dd/mm/yy format)

◾ HomeTeam - Name of Home Team

◾ AwayTeam - Name of Away Team

◾ FTHG and FTAG - Full Time Home and Away Team Goals

◾ FTR - Full Time Result (H - Home Team Win, D - Draw, A - Away Team Win)

◾ HTHG and HTAG - Half Time Home and Away Team Goals

◾ HTR - Half Time Result

◾ HS and AS - Home and Away Team Shots

◾ HST and AST - Home and Away Team Shots on Target

◾ HF and AF - Home and Away Team Fouls Committed

◾ HC and AC - Home and Away Team Corners

◾ HY and AY - Home and Away Team Yellow Cards

◾ HR and AR - Home and Away Team Red Cards

Full description of variables and dataset available at [Football-Data Notes](https://www.football-data.co.uk/notes.txt).

### Minimal Code to build Model

```
train <- read.csv("./training/training.csv")

test <- read.csv("./test/test.csv")

multinom.model <- multinom(FTR ~AST + HST + AF + HC + AC + HY + HR + AR +1,
                             data = train)       
```

### Prediction Quality
**Model Accuracy:** 0.5955
<p align="center">
  <img src="https://i.postimg.cc/qR2Qhn30/Confusion-Matrix.png" />
</p>

### Pros and Cons of Model

️
➕ High sensitivity of Home Team victory result prediction

➕ High specificity of Draw result prediction

➕ Lot possibilities to improve prediction efficiency for example, by extending the model with new variables

➖ Low sensitivity of Draw result prediction

➖ Medium level of overall accuracy

MIT License

Copyright (c) 2021 Paweł Pechta
