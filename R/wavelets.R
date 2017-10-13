install.packages("readr")
install.packages("wavelets")
install.packages("data.table")
install.packages("signal")
library(readr)
library(wavelets)
library(data.table)
library(signal)

setwd("D:/Diego Jacobs/Documents/Emotrix/emotrix/2017/Data")


csv <- read_csv("17M2311.csv", col_types = cols(`Exact Time` = col_double()))
csv2 <- csv[(csv$Emotion != "NON-RELAX" & csv$Emotion != "RELAX"),]

#Grafica de la lectura de un electrodo
csv2 <- csv[(csv$Emotion != "NON-RELAX" & csv$Emotion != "RELAX"),]
DT <- data.table(csv2)
graph <- DT[, list(cantidad = mean(F3)), by='Time']
plot(graph$Time, graph$intensidad, type='l')

#Cantidad de valores distintos por segundo
csv2 <- csv[(csv$Emotion != "NON-RELAX" & csv$Emotion != "RELAX"),]
DT <- data.table(csv2)
graph <- DT[, list(cantidad = length(unique(F3))), by='Time']


m_f3 <- as.matrix(csv3$F3)
m_af3 <- as.matrix(csv3$AF3)
m_af4 <- as.matrix(csv3$AF4)
m_f4 <- as.matrix(csv3$F4)
m_o1 <- as.matrix(csv3$O2)
m_o2 <- as.matrix(csv3$O1)

m <- cbind(m_f3, m_af3, m_f4, m_af4, m_o1, m_o2)

wt <- dwt(as.numeric(m), filter='d4', n.levels=4, boundary="periodic", fast=FALSE)

remove(csv)
remove(csv2)
remove(m_f3)
remove(m)
remove(wt)
remove(m_f3)
remove(m_af3)
remove(m_f4)
remove(m_af4)
remove(m_o1)
remove(m_o2)