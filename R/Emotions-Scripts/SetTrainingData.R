#Diego Jacobs - 13160
library(readr)
library(wavelets)
library(data.table)
library(signal)

setwd("D:/Diego Jacobs/Documents/Emotrix/emotrix/2017/Data/Emotions-Unique-Data")
files <- list.files(path="D:/Diego Jacobs/Documents/Emotrix/emotrix/2017/Data/Emotions-Unique-Data", pattern="csv$", full.names=FALSE, recursive=FALSE)

#Values
count_happy <- 0
count_sad <- 0
count_other <- 0
count_training <- 480

count_co_happy <- 0
count_co_sad <- 0
count_co_other <- 0

#Trainning Tables
happy_table <- data.table()
other_table <- data.table()
sad_table <- data.table()

#Cross-Over Validation Tables
co_happy_table <- data.table()
co_other_table <- data.table()
co_sad_table <- data.table()

#Generar tablas de training y cross-over validation
#Happy, Sad y Other
for(i in 1:length(files)){
  csv <- read_csv(files[i], col_types = cols(`Exact Time` = col_double()))
  print(files[i])
  DT <- data.table(csv)
  
  table <- DT[`Selected Emotion` == "happy"]
  
  if(nrow(table) > 0) {
    if(count_happy < count_training){
      for(j in 1:nrow(table)) {
        if(count_happy == count_training){
          temp <- cbind(count_co_happy, DT[Time == table[j]$Time])
          co_happy_table <- rbind(co_happy_table, temp)
          count_co_happy <- count_co_happy + 1
        } else{
          temp <- cbind(count_happy, DT[Time == table[j]$Time])
          happy_table <- rbind(happy_table, temp)
          count_happy <- count_happy + 1
        }
      } 
    } else {
      
      for(j in 1:nrow(table)) {
        temp <- cbind(count_co_happy, DT[Time == table[j]$Time])
        co_happy_table <- rbind(co_happy_table, temp)
        count_co_happy <- count_co_happy + 1
      }
    } 
  }
  
  table <- DT[`Selected Emotion` == "sad"]
  if(nrow(table) > 0) {
    if(count_sad < count_training){
      
      
      for(j in 1:nrow(table)) {
        if(count_sad == count_training){
          temp <- cbind(count_co_sad, DT[Time == table[j]$Time])
          co_sad_table <- rbind(co_sad_table, temp)
          count_co_sad <- count_co_sad + 1
        } else{
          temp <- cbind(count_sad, DT[Time == table[j]$Time])
          sad_table <- rbind(sad_table, temp)
          count_sad <- count_sad + 1
        }
      }
    } else {
      
      for(j in 1:nrow(table)) {
        temp <- cbind(count_co_sad, DT[Time == table[j]$Time])
        co_sad_table <- rbind(co_sad_table, temp)
        count_co_sad <- count_co_sad + 1
      }
    } 
  }
  
  table <- DT[`Selected Emotion` == "other"]
  
  if(nrow(table) > 0){
    if(count_other < count_training){
      
      for(j in 1:nrow(table)) {
        if(count_other == count_training){
          temp <- cbind(count_co_other, DT[Time == table[j]$Time])
          co_other_table <- rbind(co_other_table, temp)
          count_co_other <- count_co_other + 1
        } else{
          temp <- cbind(count_other, DT[Time == table[j]$Time])
          other_table <- rbind(other_table, temp)
          count_other <- count_other + 1
        }
      }
    } else {
      
      for(j in 1:nrow(table)) {
        temp <- cbind(count_co_other, DT[Time == table[j]$Time])
        co_other_table <- rbind(co_other_table, temp)
        count_co_other <- count_co_other + 1
      }
    } 
  }
  
}

folder <- "Training-Data-1s"

dir.create(folder, showWarnings = FALSE)
write.csv(happy_table, file.path(folder, "Training-Happy.csv"), row.names=FALSE)

dir.create(folder, showWarnings = FALSE)
write.csv(other_table, file.path(folder, "Training-Other.csv"), row.names=FALSE)

dir.create(folder, showWarnings = FALSE)
write.csv(sad_table, file.path(folder, "Training-Sad.csv"), row.names=FALSE)

dir.create(folder, showWarnings = FALSE)
write.csv(co_happy_table, file.path(folder, "Cross-Happy.csv"), row.names=FALSE)

dir.create(folder, showWarnings = FALSE)
write.csv(co_other_table, file.path(folder, "Cross-Other.csv"), row.names=FALSE)

dir.create(folder, showWarnings = FALSE)
write.csv(co_sad_table, file.path(folder, "Cross-Sad.csv"), row.names=FALSE)


setwd("D:/Diego Jacobs/Documents/Emotrix/emotrix/2017/Data/Emotions-Unique-Data")
#Generar las caracteristicas para entrenar algoritmos por electrodo
#Media y Desviacion Estandard
#Ondas Alfa, Beta, Delta y Theta
max_count <- max(co_other_table$count_co_other)
dwf <- data.frame(matrix(, nrow = 0,ncol = 10))
#BAND PASS FILTER 
#arguments
# n: filter order
# W: (low, high) / Nyquist Frequency
# type: Pass Band
# plane: analog filter
bf <- butter(n=1,W=c(8, 14)/1024, type="pass",plane="s")

for(i in 1:max_count){
  observation <- co_other_table[co_other_table$count_co_other == i]
  time1 <- min(observation$Time)
  time2 <- time1 + 1
  time3 <- time2 + 1
  
  for(j in time1:time3){
    DT <- co_other_table[(Time == j & count_co_other == i)]  
    
    f3 <- filter(bf, DT$F3)
    f4 <- filter(bf, DT$F4)
    af3 <- filter(bf, DT$AF3)
    af4 <- filter(bf, DT$AF4)
    o1 <- filter(bf, DT$O1)
    o2 <- filter(bf, DT$O2)
    
    result = tryCatch({
      wt_f3 <- dwt(as.numeric(f3), filter='d4', n.levels=1, boundary="periodic", fast=FALSE)
      wt_f4 <- dwt(as.numeric(f4), filter='d4', n.levels=1, boundary="periodic", fast=FALSE)
      wt_af3 <- dwt(as.numeric(af3), filter='d4', n.levels=1, boundary="periodic", fast=FALSE)
      wt_af4 <- dwt(as.numeric(af4), filter='d4', n.levels=1, boundary="periodic", fast=FALSE)
      wt_o1 <- dwt(as.numeric(o1), filter='d4', n.levels=1, boundary="periodic", fast=FALSE)
      wt_o2 <- dwt(as.numeric(o2), filter='d4', n.levels=1, boundary="periodic", fast=FALSE)
      
      mean_delta_f3 <- mean(as.numeric(wt_f3@W$W1))
      # mean_theta_f3 <- mean(as.numeric(wt_f3@V$V2))
      # mean_alfa_f3 <- mean(as.numeric(wt_f3@V$V3))
      # mean_beta_f3 <- mean(as.numeric(wt_f3@V$V4))
      sd_delta_f3 <- sd(as.numeric(wt_f3@W$W1))
      # sd_theta_f3 <- sd(as.numeric(wt_f3@V$V2))
      # sd_alfa_f3 <- sd(as.numeric(wt_f3@V$V3))
      # sd_beta_f3 <- sd(as.numeric(wt_f3@V$V4))
      
      mean_delta_f4 <- mean(as.numeric(wt_f4@W$W1))
      # mean_theta_f4 <- mean(as.numeric(wt_f4@V$V2))
      # mean_alfa_f4 <- mean(as.numeric(wt_f4@V$V3))
      # mean_beta_f4 <- mean(as.numeric(wt_f4@V$V4))
      sd_delta_f4 <- sd(as.numeric(wt_f4@W$W1))
      # sd_theta_f4 <- sd(as.numeric(wt_f4@V$V2))
      # sd_alfa_f4 <- sd(as.numeric(wt_f4@V$V3))
      # sd_beta_f4 <- sd(as.numeric(wt_f4@V$V4))
      
      mean_delta_af3 <- mean(as.numeric(wt_af3@W$W1))
      # mean_theta_af3 <- mean(as.numeric(wt_af3@V$V2))
      # mean_alfa_af3 <- mean(as.numeric(wt_af3@V$V3))
      # mean_beta_af3 <- mean(as.numeric(wt_af3@V$V4))
      sd_delta_af3 <- sd(as.numeric(wt_af3@W$W1))
      # sd_theta_af3 <- sd(as.numeric(wt_af3@V$V2))
      # sd_alfa_af3 <- sd(as.numeric(wt_af3@V$V3))
      # sd_beta_af3 <- sd(as.numeric(wt_af3@V$V4))
      
      mean_delta_af4 <- mean(as.numeric(wt_af4@W$W1))
      # mean_theta_af4 <- mean(as.numeric(wt_af4@V$V2))
      # mean_alfa_af4 <- mean(as.numeric(wt_af4@V$V3))
      # mean_beta_af4 <- mean(as.numeric(wt_af4@V$V4))
      sd_delta_af4 <- sd(as.numeric(wt_af4@W$W1))
      # sd_theta_af4 <- sd(as.numeric(wt_af4@V$V2))
      # sd_alfa_af4 <- sd(as.numeric(wt_af4@V$V3))
      # sd_beta_af4 <- sd(as.numeric(wt_af4@V$V4))
      
      mean_delta_o1 <- mean(as.numeric(wt_o1@W$W1))
      # mean_theta_o1 <- mean(as.numeric(wt_o1@V$V2))
      # mean_alfa_o1 <- mean(as.numeric(wt_o1@V$V3))
      # mean_beta_o1 <- mean(as.numeric(wt_o1@V$V4))
      sd_delta_o1 <- sd(as.numeric(wt_o1@W$W1))
      # sd_theta_o1 <- sd(as.numeric(wt_o1@V$V2))
      # sd_alfa_o1 <- sd(as.numeric(wt_o1@V$V3))
      # sd_beta_o1 <- sd(as.numeric(wt_o1@V$V4))
      
      mean_delta_o2 <- mean(as.numeric(wt_o2@W$W1))
      # mean_theta_o2 <- mean(as.numeric(wt_o2@V$V2))
      # mean_alfa_o2 <- mean(as.numeric(wt_o2@V$V3))
      # mean_beta_o2 <- mean(as.numeric(wt_o2@V$V4))
      sd_delta_o2 <- sd(as.numeric(wt_o2@W$W1))
      # sd_theta_o2 <- sd(as.numeric(wt_o2@V$V2))
      # sd_alfa_o2 <- sd(as.numeric(wt_o2@V$V3))
      # sd_beta_o2 <- sd(as.numeric(wt_o2@V$V4))
      t <- j - time1 + 1
      # temp <- data.frame(i, t, mean_delta_f3, mean_theta_f3, mean_alfa_f3, mean_beta_f3, sd_delta_f3, sd_theta_f3, sd_alfa_f3, sd_beta_f3,
      #         mean_delta_f4, mean_theta_f4, mean_alfa_f4, mean_beta_f4, sd_delta_f4, sd_theta_f4, sd_alfa_f4, sd_beta_f4,
      #         mean_delta_af3, mean_theta_af3, mean_alfa_af3, mean_beta_af3, sd_delta_af3, sd_theta_af3, sd_alfa_af3, sd_beta_af3,
      #         mean_delta_af4, mean_theta_af4, mean_alfa_af4, mean_beta_af4, sd_delta_af4, sd_theta_af4, sd_alfa_af4, sd_beta_af4,
      #         mean_delta_o1, mean_theta_o1, mean_alfa_o1, mean_beta_o1, sd_delta_o1, sd_theta_o1, sd_alfa_o1, sd_beta_o1,
      #         mean_delta_o2, mean_theta_o2, mean_alfa_o2, mean_beta_o2, sd_delta_o2, sd_theta_o2, sd_alfa_o2, sd_beta_o2)
      
      temp <- data.frame(i, t, mean_delta_f3,sd_delta_f3,
                         mean_delta_f4,sd_delta_f4,
                         mean_delta_af3, sd_delta_af3, 
                         mean_delta_af4, sd_delta_af4,
                         mean_delta_o1,  sd_delta_o1,
                         mean_delta_o2, sd_delta_o2)
      
      dwf <- rbind(dwf, temp)
      
    }, warning = function(w) {
      
    }, error = function(e) {
      
    }, finally = {
      
    })
  }
}

folder <- "Caracteristicas-ALFA-W"
dir.create(folder, showWarnings = FALSE)
write.csv(dwf, file.path(folder, "Cross-Other.csv"), row.names=FALSE)

setwd("D:/Diego Jacobs/Documents/Emotrix/emotrix/2017/Data/Emotions-Unique-Data/Caracteristicas")

#Join de las caracteristicas de los electrodos
csv_f3 <- read_csv("Training-Happy-F3.csv")
csv_f4 <- read_csv("Training-Happy-F4.csv")
csv_af3 <- read_csv("Training-Happy-AF3.csv")
csv_af4 <- read_csv("Training-Happy-AF4.csv")
csv_o1 <- read_csv("Training-Happy-O1.csv")
csv_o2 <- read_csv("Training-Happy-O2.csv")

happy_training <- merge(csv_f3, csv_f4, by=c("i", "t"))
happy_training <- merge(happy_training, csv_af3, by=c("i", "t"))
happy_training <- merge(happy_training, csv_af4, by=c("i", "t"))
happy_training <- merge(happy_training, csv_o1, by=c("i", "t"))
happy_training <- merge(happy_training, csv_o2, by=c("i", "t"))

csv_f3 <- read_csv("Training-Sad-F3.csv")
csv_f4 <- read_csv("Training-Sad-F4.csv")
csv_af3 <- read_csv("Training-Sad-AF3.csv")
csv_af4 <- read_csv("Training-Sad-AF4.csv")
csv_o1 <- read_csv("Training-Sad-O1.csv")
csv_o2 <- read_csv("Training-Sad-O2.csv")

sad_training <- merge(csv_f3, csv_f4, by=c("i", "t"))
sad_training <- merge(sad_training, csv_af3, by=c("i", "t"))
sad_training <- merge(sad_training, csv_af4, by=c("i", "t"))
sad_training <- merge(sad_training, csv_o1, by=c("i", "t"))
sad_training <- merge(sad_training, csv_o2, by=c("i", "t"))

csv_f3 <- read_csv("Training-Other-F3.csv")
csv_f4 <- read_csv("Training-Other-F4.csv")
csv_af3 <- read_csv("Training-Other-AF3.csv")
csv_af4 <- read_csv("Training-Other-AF4.csv")
csv_o1 <- read_csv("Training-Other-O1.csv")
csv_o2 <- read_csv("Training-Other-O2.csv")

other_training <- merge(csv_f3, csv_f4, by=c("i", "t"))
other_training <- merge(other_training, csv_af3, by=c("i", "t"))
other_training <- merge(other_training, csv_af4, by=c("i", "t"))
other_training <- merge(other_training, csv_o1, by=c("i", "t"))
other_training <- merge(other_training, csv_o2, by=c("i", "t"))

dir.create(folder, showWarnings = FALSE)
write.csv(happy_training, file.path(folder, "Training-Happy.csv"), row.names=FALSE)

dir.create(folder, showWarnings = FALSE)
write.csv(sad_training, file.path(folder, "Training-Sad.csv"), row.names=FALSE)

dir.create(folder, showWarnings = FALSE)
write.csv(other_training, file.path(folder, "Training-Other.csv"), row.names=FALSE)


#Cross-Over
#Join de las caracteristicas de los electrodos
csv_f3 <- read_csv("Cross-Happy-F3.csv")
csv_f4 <- read_csv("Cross-Happy-F4.csv")
csv_af3 <- read_csv("Cross-Happy-AF3.csv")
csv_af4 <- read_csv("Cross-Happy-AF4.csv")
csv_o1 <- read_csv("Cross-Happy-O1.csv")
csv_o2 <- read_csv("Cross-Happy-O2.csv")

happy_cross <- merge(csv_f3, csv_f4, by=c("i", "t"))
happy_cross <- merge(happy_cross, csv_af3, by=c("i", "t"))
happy_cross <- merge(happy_cross, csv_af4, by=c("i", "t"))
happy_cross <- merge(happy_cross, csv_o1, by=c("i", "t"))
happy_cross <- merge(happy_cross, csv_o2, by=c("i", "t"))

csv_f3 <- read_csv("Cross-Sad-F3.csv")
csv_f4 <- read_csv("Cross-Sad-F4.csv")
csv_af3 <- read_csv("Cross-Sad-AF3.csv")
csv_af4 <- read_csv("Cross-Sad-AF4.csv")
csv_o1 <- read_csv("Cross-Sad-O1.csv")
csv_o2 <- read_csv("Cross-Sad-O2.csv")

sad_cross <- merge(csv_f3, csv_f4, by=c("i", "t"))
sad_cross <- merge(sad_cross, csv_af3, by=c("i", "t"))
sad_cross <- merge(sad_cross, csv_af4, by=c("i", "t"))
sad_cross <- merge(sad_cross, csv_o1, by=c("i", "t"))
sad_cross <- merge(sad_cross, csv_o2, by=c("i", "t"))

csv_f3 <- read_csv("Cross-Other-F3.csv")
csv_f4 <- read_csv("Cross-Other-F4.csv")
csv_af3 <- read_csv("Cross-Other-AF3.csv")
csv_af4 <- read_csv("Cross-Other-AF4.csv")
csv_o1 <- read_csv("Cross-Other-O1.csv")
csv_o2 <- read_csv("Cross-Other-O2.csv")

other_cross <- merge(csv_f3, csv_f4, by=c("i", "t"))
other_cross <- merge(other_cross, csv_af3, by=c("i", "t"))
other_cross <- merge(other_cross, csv_af4, by=c("i", "t"))
other_cross <- merge(other_cross, csv_o1, by=c("i", "t"))
other_cross <- merge(other_cross, csv_o2, by=c("i", "t"))

dir.create(folder, showWarnings = FALSE)
write.csv(happy_cross, file.path(folder, "Cross-Happy.csv"), row.names=FALSE)

dir.create(folder, showWarnings = FALSE)
write.csv(sad_cross, file.path(folder, "Cross-Sad.csv"), row.names=FALSE)

dir.create(folder, showWarnings = FALSE)
write.csv(other_cross, file.path(folder, "Cross-Other.csv"), row.names=FALSE)