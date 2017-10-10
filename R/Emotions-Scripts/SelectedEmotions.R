#Script para obtener emociones presionadas por cada persona
install.packages("readr")
install.packages("data.table")

library(readr)
library(data.table)

setwd("~/Documents/Emotrix/emotrix/2017/Data")

folder <- "Selected-Emotions"

files <- list.files(path="~/Documents/Emotrix/emotrix/2017/Data", pattern="csv$", full.names=FALSE, recursive=FALSE)

for(i in 1:length(files)){
  csv <- read_csv(files[i], col_types = cols(`Exact Time` = col_double()))
  DT <- data.table(csv)
  
  images <-unique(DT[Emotion != "NON-RELAX"  & Emotion != "RELAX", c("Image/Color", "Time")])
  emotions <- DT[Emotion != "NON-RELAX"  & Emotion != "RELAX" & `Selected Emotion` != "NA"]
  table <- emotions[, c("Image/Color", "Time", "Emotion", "Selected Emotion")]
  
  final_table <- merge(images, table, all.x=TRUE)
  
  table_order <- unique(final_table[order(final_table$Time)])
  
  dir.create(folder, showWarnings = FALSE)
  write.csv(table_order, file.path(folder, files[i]), row.names=FALSE)
}

remove(csv)
remove(DT)
remove(images)
remove(emotions)
remove(table)
remove(final_table)
remove(table_order)