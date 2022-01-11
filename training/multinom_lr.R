train$FTR <- relevel(factor(train$FTR), ref = "D")
require(nnet)

multinom.model <- multinom(FTR ~AST + HST + AF + HC + AC + HY + HR + AR +1,
                             data = train)
summary(multinom.model)

summary <- summary(multinom.model_2)$coefficients/summary(multinom.model_2)$standard.errors
p <- (1 - pnorm(abs(summary), 0, 1)) * 2
head(p) 

exp(coef(multinom.model_2))

multinom.model <- multinom.model_2
