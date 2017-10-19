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

#Trainning Tables
happy_table <- data.table()
other_table <- data.table()
sad_table <- data.table()

#Cross-Over Validation Tables
co_happy_table <- data.table()
co_other_table <- data.table()
co_sad_table <- data.table()

for(i in 1:length(files)){
  csv <- read_csv(files[i], col_types = cols(`Exact Time` = col_double()))
  DT <- data.table(csv)

  if(count_happy < count_training){
    table <- DT[`Selected Emotion` == "happy"]
    
    for(i in 1:nrow(table)) {
      if(count_happy == count_training){
        co_happy_table <- rbind(co_happy_table, DT[Time == table[i]$Time | Time == (table[i]$Time - 1) | Time == (table[i]$Time + 1)])
      } else{
        happy_table <- rbind(happy_table, DT[Time == table[i]$Time | Time == (table[i]$Time - 1) | Time == (table[i]$Time + 1)])
        count_happy <- count_happy + 1
      }
    } 
  } else {
    table <- DT[`Selected Emotion` == "happy"]
    
    for(i in 1:nrow(table)) {
      co_happy_table <- rbind(co_happy_table, DT[Time == table[i]$Time | Time == (table[i]$Time - 1) | Time == (table[i]$Time + 1)])
    }
  }
  
  if(count_sad < count_training){
    table <- DT[`Selected Emotion` == "sad"]
    
    for(i in 1:nrow(table)) {
      if(count_sad == count_training){
        co_sad_table <- rbind(co_sad_table, DT[Time == table[i]$Time | Time == (table[i]$Time - 1) | Time == (table[i]$Time + 1)])
      } else{
        sad_table <- rbind(sad_table, DT[Time == table[i]$Time | Time == (table[i]$Time - 1) | Time == (table[i]$Time + 1)])
        count_sad <- count_sad + 1
      }
    }
  } else {
    table <- DT[`Selected Emotion` == "happy"]
    
    for(i in 1:nrow(table)) {
      co_sad_table <- rbind(co_sad_table, DT[Time == table[i]$Time | Time == (table[i]$Time - 1) | Time == (table[i]$Time + 1)])
    }
  }
  
  
  if(count_other < count_training){
    table <- DT[`Selected Emotion` == "other"]
    
    for(i in 1:nrow(table)) {
      if(count_other == count_training){
        co_other_table <- rbind(co_other_table, DT[Time == table[i]$Time | Time == (table[i]$Time - 1) | Time == (table[i]$Time + 1)])
      } else{
        other_table <- rbind(other_table, DT[Time == table[i]$Time | Time == (table[i]$Time - 1) | Time == (table[i]$Time + 1)])
        count_other <- count_other + 1
      }
    }
  } else {
    table <- DT[`Selected Emotion` == "happy"]
    
    for(i in 1:nrow(table)) {
      co_other_table <- rbind(co_other_table, DT[Time == table[i]$Time | Time == (table[i]$Time - 1) | Time == (table[i]$Time + 1)])
    }
  }
}
