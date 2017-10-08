#Script para obtener emociones presionadas por cada persona
install.packages("readr")
install.packages("data.table")

library(readr)
library(data.table)

setwd("~/Documents/Emotrix/emotrix/2017/Data")

alvaro_galindo <- read_csv("alvaro_galindo.csv",col_types = cols(`Exact Time` = col_double()))
DT <- data.table(alvaro_galindo)

first_second_emotions <- 224

images <-unique(DT[Emotion != "NON-RELAX"  & Emotion != "RELAX", c("Image/Color", "Time")])
emotions <- DT[Emotion != "NON-RELAX"  & Emotion != "RELAX" & `Selected Emotion` != "NA"]
table <- emotions[, c("Image/Color", "Time", "Emotion", "Selected Emotion")]

final_table <- merge(images, table, all.x=TRUE)

table_order <- final_table[order(final_table$Time)]
fwrite(table_order, "alvaro_galindo_emotions.csv")