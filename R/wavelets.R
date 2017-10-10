install.packages("readr")
install.packages("wavelets")
install.packages("data.table")
library(readr)
library(wavelets)
library(data.table)

setwd("D:/Diego Jacobs/Documents/Emotrix/emotrix/2017/Data")


csv <- read_csv("17F2142.csv", col_types = cols(`Exact Time` = col_double()))
csv2 <- csv[(csv$Emotion == "NON-RELAX" & csv$Emotion == "RELAX"),]

m_f3 <- as.matrix(csv2$F3)
m_af3 <- as.matrix(csv2$AF3)
m_af4 <- as.matrix(csv2$AF4)
m_f4 <- as.matrix(csv2$F4)
m_o1 <- as.matrix(csv2$O2)
m_o2 <- as.matrix(csv2$O1)

m <- cbind(m_f3, m_af3, m_f4, m_af4, m_o1, m_o2)

wt <- dwt(as.numeric(m), "d4", n.levels=3, boundary="periodic", fast=FALSE)

View(wt@V$V3)

remove(csv)
remove(csv2)
remove(m_f3)
remove(array)
remove(wt)
