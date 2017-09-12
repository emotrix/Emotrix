install.packages("e1071")

library("e1071")

head(iris,5)

attach(iris)

x <- subset(iris, select=-Species)
y <- Species

svm_model <- svm(Species ~ ., data=iris)
summary(svm_model)

pred <- predict(svm_model,x)
system.time(pred <- predict(svm_model,x))

table(pred,y)
