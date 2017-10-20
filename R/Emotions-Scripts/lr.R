#Codigo para correr Logistic Regression
#Diego Jacobs - 13160
#http://www.statmethods.net/advstats/glm.html

setwd("D:/Diego Jacobs/Documents/Emotrix/emotrix/2017/Data/Emotions-Unique-Data/Caracteristicas")

csv_happy <- read_csv("Training-Happy.csv")
csv_sad <- read_csv("Training-Sad.csv")
csv_other <- read_csv("Training-Other.csv")

drops <- c("i","t")
csv_happy[ , !(names(csv_happy) %in% drops)]
csv_sad[ , !(names(csv_sad) %in% drops)]
csv_other[ , !(names(csv_other) %in% drops)]

csv_happy$ID <- 1
csv_sad$ID <- 0

training <- rbind(csv_happy, csv_sad)

modelo_lr_hs<-glm(ID~., data=training, family=binomial())

#summary(modeloLR) y puedo ver en excel por p-value que variables son las mas importantes,
#cuales son sus coeficientes, etc.
summary(modelo_lr_hs)

test<-predict(modeloLR, hongosTest, type="response")
