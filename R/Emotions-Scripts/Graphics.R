library(readr)
library(wavelets)
library(data.table)
library(signal)

setwd("D:/Diego Jacobs/Documents/Emotrix/emotrix/2017/Data/Emotions-Unique-Data")

files <- list.files(path="D:/Diego Jacobs/Documents/Emotrix/emotrix/2017/Data/Emotions-Unique-Data", pattern="csv$", full.names=FALSE, recursive=FALSE)


for(i in 1:length(files)){
  csv <- read_csv(files[i], col_types = cols(`Exact Time` = col_double()))
  DT <- data.table(csv)
  
  #Starting Time at 0
  initial_time <- DT$Time[1]
  DT$Time <- DT$Time - initial_time
  
  #BAND PASS FILTER 
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
}


#######################INICIO###########################################
csv <- read_csv("17M2311.csv", col_types = cols(`Exact Time` = col_double()))
DT <- data.table(csv)

#BAND PASS FILTER 
#arguments
# n: filter order
# W: (low, high) / Nyquist Frequency
# type: Pass Band
# plane: analog filter
bf <- butter(n=1,W=c(0.1, 30)/1024, type="pass",plane="s")

initial_time <- DT$Time[1]
DT$Time <- DT$Time - initial_time

final_time <- DT$Time[nrow(DT)]

for(j in 0:final_time) {
    second_dt <- DT[Time == j]
  
    second_dt$F3 <- filter(bf,second_dt$F3)
    second_dt$F4 <- filter(bf,second_dt$F4)
    second_dt$AF3 <- filter(bf,second_dt$AF3)
    second_dt$AF4 <- filter(bf,second_dt$AF4)
    second_dt$O1 <- filter(bf,second_dt$O1)
    second_dt$O2 <- filter(bf,second_dt$O2)
    
    wt_f3 <- dwt(as.numeric(second_dt$F3), filter='d4', n.levels=4, boundary="periodic", fast=FALSE)
    wt_f4 <- dwt(as.numeric(second_dt$F4), filter='d4', n.levels=4, boundary="periodic", fast=FALSE)
    wt_af3 <- dwt(as.numeric(second_dt$AF3), filter='d4', n.levels=4, boundary="periodic", fast=FALSE)
    wt_af4 <- dwt(as.numeric(second_dt$AF4), filter='d4', n.levels=4, boundary="periodic", fast=FALSE)
    wt_o1 <- dwt(as.numeric(second_dt$O1), filter='d4', n.levels=4, boundary="periodic", fast=FALSE)
    wt_o2 <- dwt(as.numeric(second_dt$O2), filter='d4', n.levels=4, boundary="periodic", fast=FALSE)
    
    f3_delta <- mean(as.numeric(wt_f3@W$W1))
    f3_theta <- mean(as.numeric(wt_f3@W$W2))
    f3_alfa <- mean(as.numeric(wt_f3@W$W3))
    f3_beta <- mean(as.numeric(wt_f3@W$W4))
    
    max <- max(f3_delta, f3_theta, f3_alfa, f3_beta)
    
    if(f3_delta == max){
        append(array_f3, 1)
    }
    
    if(f3_theta == max){
      append(array_f3, 2)
    }
    
    if(f3_alfa == max){
      append(array_f3, 3)
    }
    
    if(f3_beta == max){
      append(array_f3, 4)
    }
}

plot(array_f3, col="blue", main="Lectura de Electrodo F3")

##############################FIN##########################

graph_f3 <- DT[, list(Frecuencia = abs(mean(F3))), by='Time']
graph_f4 <- DT[, list(Frecuencia = abs(mean(F4))), by='Time']
graph_af3 <- DT[, list(Frecuencia = abs(mean(AF3))), by='Time']
graph_af4 <- DT[, list(Frecuencia = abs(mean(AF4))), by='Time']
graph_o1 <- DT[, list(Frecuencia = abs(mean(O1))), by='Time']
graph_o2 <- DT[, list(Frecuencia = abs(mean(O2))), by='Time']

plot(graph_f3, col="blue", type="l", main="Lectura de Electrodo F3")
plot(graph_f4, col="blue", type="l", main="Lectura de Electrodo F4")
plot(graph_af3, col="blue", type="l", main="Lectura de Electrodo AF3")
plot(graph_af3, col="blue", type="l", main="Lectura de Electrodo AF4")
plot(graph_o1, col="blue", type="l", main="Lectura de Electrodo O1")
plot(graph_o2, col="blue", type="l", main="Lectura de Electrodo O2")
