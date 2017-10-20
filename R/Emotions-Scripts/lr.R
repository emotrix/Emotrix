#Codigo para correr Logistic Regression
#Diego Jacobs - 13160
#http://www.statmethods.net/advstats/glm.html

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

training <- rbind(csv_happy, csv_sad)

modelo_lr_hs<-glm(ID~., data=training, family=binomial())

csv_cross_happy$ID <- 1
csv_cross_sad$ID <- 0

test <- rbind(csv_cross_happy, csv_cross_sad)

final <- predict(modelo_lr_hs, test, type="response")


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

training <- rbind(csv_happy, csv_other)

modelo_lr_ho<-glm(ID~., data=training, family=binomial())

csv_cross_happy$ID <- 1
csv_cross_other$ID <- 0

test <- rbind(csv_cross_happy, csv_cross_other)

final <- predict(modelo_lr_ho, test, type="response")

#Other vs Sad
csv_sad <- read_csv("Training-Sad.csv")
csv_other <- read_csv("Training-Other.csv")
csv_cross_sad <- read_csv("Cross-Sad.csv")
csv_cross_other <- read_csv("Cross-Other.csv")

drops <- c("i","t")
csv_other <- csv_other[ , !(names(csv_other) %in% drops)]
csv_sad <- csv_sad[ , !(names(csv_sad) %in% drops)]
csv_cross_other <- csv_cross_other[ , !(names(csv_cross_other) %in% drops)]
csv_cross_sad <- csv_cross_sad[ , !(names(csv_cross_sad) %in% drops)]

csv_sad$ID <- 1
csv_other$ID <- 0

training <- rbind(csv_sad, csv_other)

modelo_lr_so<-glm(ID~., data=training, family=binomial())

csv_cross_sad$ID <- 1
csv_cross_other$ID <- 0

test <- rbind(csv_cross_sad, csv_cross_other)

final <- predict(modelo_lr_so, test, type="response")