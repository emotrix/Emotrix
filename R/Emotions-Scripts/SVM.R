install.packages("e1071")
install.packages("caret")
install.packages("lava")

library("e1071")
library(caret)


head(iris,5)

attach(iris)

x <- subset(iris, select=-Species)
y <- Species

svm_model <- svm(Species ~ ., data=iris)
summary(svm_model)

pred <- predict(svm_model,x)
system.time(pred <- predict(svm_model,x))

table(pred,y)

