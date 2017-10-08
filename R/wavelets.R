install.packages("readr")
install.packages("wavelets")
library(wavelets)

x <- c(1,2,3,4,5,6,7,8,9,10,11,12,13)
wt <- dwt(x, filter="d4", n.levels=4, boundary="periodic", fast=FALSE)

View(wt@W)