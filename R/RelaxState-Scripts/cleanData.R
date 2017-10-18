#Script para sanitizar toda la data leida durante las experimentaciones
#utilizar solo data del estado de relajacion
#Mario Barrientos - 13039

#Librerias
library(readr)

setwd("C:/Users/mario/Desktop/resultados")
# setwd("C:/Users/mario/Desktop/DATAFIX")

X17F1817 <- read_csv("C:/Users/mario/Desktop/resultados/17F1817.csv")
sf1 <- X17F1817[(X17F1817$Emotion == "NON-RELAX" | X17F1817$Emotion == "RELAX"),]
sf1$`Selected Emotion` <- NULL
remove(X17F1817)
sf1 <- unique(sf1)
sf1$Teorico <- ifelse(sf1$Emotion == "NON-RELAX",0,1)


