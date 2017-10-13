install.packages("readr")
install.packages("wavelets")
install.packages("data.table")
install.packages("signal")
library(readr)
library(wavelets)
library(data.table)
library(signal)

# setwd("D:/Diego Jacobs/Documents/Emotrix/emotrix/2017/Data")
setwd("C:/Users/mario/Desktop/resultados")



csv <- read_csv("17M2311.csv", col_types = cols(`Exact Time` = col_double()))
# csv2 <- csv[(csv$Emotion != "NON-RELAX" & csv$Emotion != "RELAX"),]
csv2 <- csv[(csv$Emotion == "NON-RELAX" | csv$Emotion == "RELAX"),]


#---------------------------------------------------
#PLAN B, tomar 30 muestras por segundo
time <- csv2$Time
unicotime <- unique(time)

remove(csv)
datafinal <- data.frame(NA,NA)
tempdata <- data.frame(rep(NA,30),rep(NA,30))
colnames(tempdata) <- c("Time","Frequency")
colnames(datafinal) <- c("Time","Frequency")
for (i in 0:nrow(as.data.frame(unicotime))){
  print(i)
  temp <- csv2[(csv2$Time == i),]
  unicafrec <- temp$O1
  filtered <- sample(unicafrec, 30)
  tempdata$Time = rep(i,30)
  tempdata$Frequency = filtered
  datafinal <- rbind(datafinal, tempdata)
}
datafinal <- na.omit(datafinal)
# --------------------------------------------------

#LOW PASS FILTER 
#arguments
# n: filter order
# W: (low, high) / Nyquist Frequency
# type: Pass Band
# plane: analog filter
bf <- butter(n=1,W=c(0.1, 30)/1024, type="pass",plane="s")

f3 <- filter(bf,csv2$F3)
f4 <- filter(bf,csv2$F4)
af3 <- filter(bf,csv2$AF3)
af4 <- filter(bf,csv2$AF4)
o1 <- filter(bf,csv2$O1)
o2 <- filter(bf,csv2$O2)

m <- cbind(f3,af3, f4, af4, o1, o2)

remove(csv)

wt <- dwt(as.numeric(m), filter='d4', n.levels=4, boundary="periodic", fast=FALSE)
View(wt@V$V1)

#GRAFICAS
plot(f3, type="l")
plot(f3,csv2$Time, col="blue", type="l")
plot(wt@W$W1)
plot(wt@W$W2)
plot(wt@W$W3)
plot(wt@W$W4)




#Grafica de la lectura de un electrodo
csv2 <- csv[(csv$Emotion != "NON-RELAX" & csv$Emotion != "RELAX"),]
DT <- data.table(csv2)
graph <- DT[, list(cantidad = mean(F3)), by='Time']
plot(graph$Time, graph$intensidad, type='l')

#Cantidad de valores distintos por segundo
csv2 <- csv[(csv$Emotion != "NON-RELAX" & csv$Emotion != "RELAX"),]
DT <- data.table(csv)
graph <- DT[, list(cantidad = length(unique(F3))), by='Time']

remove(csv)
remove(csv2)
