library(readr)
library(wavelets)
library(data.table)
library(signal)

setwd("D:/Diego Jacobs/Documents/Emotrix/emotrix/2017/Data/Emotions-Unique-Data")

files <- list.files(path="D:/Diego Jacobs/Documents/Emotrix/emotrix/2017/Data/Emotions-Unique-Data", pattern="csv$", full.names=FALSE, recursive=FALSE)

#BAND PASS FILTER 
#arguments
# n: filter order
# W: (low, high) / Nyquist Frequency
# type: Pass Band
# plane: analog filter
bf <- butter(n=1,W=c(0.1, 30)/1024, type="pass",plane="s")

for(i in 1:length(files)){
  csv <- read_csv(files[i], col_types = cols(`Exact Time` = col_double()))
  DT <- data.table(csv)
  
  file_name <- gsub(".csv", "", files[i])
  
  initial_time <- DT$Time[1]
  DT$Time <- DT$Time - initial_time
  
  final_time <- DT$Time[nrow(DT)]
  array_f3 <- c(0)
  for(j in 0:final_time) {
    second_dt <- DT[Time == j]
    
    second_dt$F3 <- filter(bf,second_dt$F3)
    second_dt$F4 <- filter(bf,second_dt$F4)
    second_dt$AF3 <- filter(bf,second_dt$AF3)
    second_dt$AF4 <- filter(bf,second_dt$AF4)
    second_dt$O1 <- filter(bf,second_dt$O1)
    second_dt$O2 <- filter(bf,second_dt$O2)
    
    result = tryCatch({
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
      
      max_f3 <- max(f3_delta, f3_theta, f3_alfa, f3_beta)
      
      if(f3_delta == max_f3){
        array_f3[j] <- 1
      }
      
      if(f3_theta == max_f3){
        array_f3[j] <- 2
      }
      
      if(f3_alfa == max_f3){
        array_f3[j] <- 3
      }
      
      if(f3_beta == max_f3){
        array_f3[j] <- 4
      }  
    }, warning = function(w) {
      array_f3[j] <- 0
    }, error = function(e) {
      array_f3[j] <- 0
    }, finally = {
      
    })
  }
  
  image_name <-  paste(file_name, ".png") 
  image_path  <- paste("D:/Diego Jacobs/Documents/Emotrix/emotrix/2017/Data/Graphics-Emotions/F3/", image_name)
  png(filename=image_path)
  plot(array_f3,xlab = "Tiempo", ylab = "Onda Mas Presente", col="blue", main="Lectura de Electrodo F3")
  dev.off()
}

remove(csv)
remove(DT)
remove(second_dt)
remove(array_f3)
remove(bf)
remove(f3_alfa)
remove(f3_beta)
remove(f3_delta)
remove(f3_theta)
remove(file_name)
remove(files)
remove(final_time)
remove(i)
remove(image_name)
remove(image_path)
remove(initial_time)
remove(j)
remove(max)
remove(max_f3)