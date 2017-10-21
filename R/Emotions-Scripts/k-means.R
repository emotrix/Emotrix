setwd("D:/Diego Jacobs/Documents/Emotrix/emotrix/2017/Data/Emotions-Unique-Data/Caracteristicas-v")

#Happy vs Sad
csv_happy <- read_csv("Training-Happy.csv")
csv_sad <- read_csv("Training-Sad.csv")
csv_cross_happy <- read_csv("Cross-Happy.csv")
csv_cross_sad <- read_csv("Cross-Sad.csv")


drops <- c("i","t")
csv_happy <- csv_happy[ , !(names(csv_happy) %in% drops)]
csv_sad <- csv_sad[ , !(names(csv_sad) %in% drops)]
csv_cross_happy <- csv_cross_happy[ , !(names(csv_cross_happy) %in% drops)]
csv_cross_sad <- csv_cross_sad[ , !(names(csv_cross_sad) %in% drops)]

training_hs <- rbind(csv_happy, csv_sad)

# K-Means Cluster Analysis
fit <- kmeans(training_hs, 2) # 2 cluster solution
# get cluster means 
aggregate(training_hs, by=list(fit$cluster),FUN=sd)
# append cluster assignment
mydata <- data.frame(training_hs, fit$cluster)

str(assign.cluster.labels(calculate.confusion(mydata, fit$cluster), 2))


calculate.confusion <- function(states, clusters)
{
  # generate a confusion matrix of cols C versus states S
  d <- data.frame(state = states, cluster = clusters)
  td <- as.data.frame(table(d))
  # convert from raw counts to percentage of each label
  pc <- matrix(ncol=max(clusters),nrow=0) # k cols
  for (i in 1:9) # 9 labels
  {
    total <- sum(td[td$state==td$state[i],3])
    pc <- rbind(pc, td[td$state==td$state[i],3]/total)
  }
  rownames(pc) <- td[1:9,1]
  return(pc)
}

assign.cluster.labels <- function(cm, k)
{
  # take the cluster label from the highest percentage in that column
  cluster.labels <- list()
  for (i in 1:k)
  {
    cluster.labels <- rbind(cluster.labels, row.names(cm)[match(max(cm[,i]), cm[,i])])
  }
  
  # this may still miss some labels, so make sure all labels are included
  for (l in rownames(cm)) 
  { 
    if (!(l %in% cluster.labels)) 
    { 
      cluster.number <- match(max(cm[l,]), cm[l,])
      cluster.labels[[cluster.number]] <- c(cluster.labels[[cluster.number]], l)
    } 
  }
  return(cluster.labels)
}
