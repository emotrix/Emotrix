#Diego Jacobs - 13160
install.packages("e1071")

library("e1071")

#Example
head(iris,5)

attach(iris)

x <- subset(iris, select=-Species)
y <- Species

svm_model <- svm(Species ~ ., data=iris)
summary(svm_model)

pred <- predict(svm_model,x)
system.time(pred <- predict(svm_model,x))

table(pred,y)




#Emotrix
setwd("D:/Diego Jacobs/Documents/Emotrix/emotrix/2017/Data/Emotions-Unique-Data/Caracteristicas")

#Happy vs Sad
csv_happy <- read_csv("Training-Happy.csv")
csv_sad <- read_csv("Training-Sad.csv")
csv_cross_happy <- read_csv("Cross-Happy.csv")
csv_cross_sad <- read_csv("Cross-Sad.csv")


drops <- c("i","t")
csv_happy <- csv_happy[ , !(names(csv_happy) %in% drops)]
csv_sad <- csv_sad[ , !(names(csv_sad) %in% drops)]
csv_cross_happy <- csv_cross_happy[ , !(names(csv_cross_happy) %in% drops)]
csv_cross_sad <- csv_cross_sad[ , !(names(csv_cross_sad) %in% drops)]

csv_happy$ID <- 1
csv_sad$ID <- 0

training_hs <- rbind(csv_happy, csv_sad)

svm_model_hs <- svm(ID ~ ., data=training_hs)

csv_cross_happy$ID <- 1
csv_cross_sad$ID <- 0

test_hs <- rbind(csv_cross_happy, csv_cross_sad)

pred_hs <- predict(svm_model_hs, test_hs)

y_hs <- test_hs$ID
table(pred_hs, y_hs)

#Happy vs Other
csv_happy <- read_csv("Training-Happy.csv")
csv_other <- read_csv("Training-Other.csv")
csv_cross_happy <- read_csv("Cross-Happy.csv")
csv_cross_other <- read_csv("Cross-Other.csv")


drops <- c("i","t")
csv_happy <- csv_happy[ , !(names(csv_happy) %in% drops)]
csv_other <- csv_other[ , !(names(csv_other) %in% drops)]
csv_cross_happy <- csv_cross_happy[ , !(names(csv_cross_happy) %in% drops)]
csv_cross_other <- csv_cross_other[ , !(names(csv_cross_other) %in% drops)]

csv_happy$ID <- 1
csv_other$ID <- 0

training_ho <- rbind(csv_happy, csv_other)

svm_model_ho <- svm(ID ~ ., data=training_ho)

csv_cross_happy$ID <- 1
csv_cross_other$ID <- 0

test_ho <- rbind(csv_cross_happy, csv_cross_other)

pred_ho <- predict(svm_model_ho, test_ho)

y_ho <- test_ho$ID
table(pred_ho, y_ho)



#Sad vs Other
csv_sad <- read_csv("Training-Sad.csv")
csv_other <- read_csv("Training-Other.csv")
csv_cross_sad <- read_csv("Cross-Sad.csv")
csv_cross_other <- read_csv("Cross-Other.csv")


drops <- c("i","t")
csv_sad <- csv_sad[ , !(names(csv_sad) %in% drops)]
csv_other <- csv_other[ , !(names(csv_other) %in% drops)]
csv_cross_sad <- csv_cross_sad[ , !(names(csv_cross_sad) %in% drops)]
csv_cross_other <- csv_cross_other[ , !(names(csv_cross_other) %in% drops)]

csv_sad$ID <- 1
csv_other$ID <- 0

training_so <- rbind(csv_sad, csv_other)

svm_model_so <- svm(ID ~ ., data=training_so)

csv_cross_sad$ID <- 1
csv_cross_other$ID <- 0

test_so <- rbind(csv_cross_sad, csv_cross_other)

pred_so <- predict(svm_model_so, test_so)

y_so <- test_so$ID
table(pred_so, y_so)