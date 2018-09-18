logZoutRe <- read.csv("../modelComparison2/aggregatedLogZout.csv")
head(logZoutRe)
ncol(logZoutRe)

annealMethods <- c("ANNEALINGJC","ANNEALINGEvolK2P","ANNEALINGEvolGTR")
ssMethods <- c("SSJC","SSEvolK2P","SSEvolGTR")
uniqueTrees <- unique(logZoutRe$X.treeName)
modelSelectionSummary <- matrix(0,length(uniqueTrees),3)
colnames(modelSelectionSummary) <- c("treeName","modelByASMC","modelBySS")
k <- 1
for(i in uniqueTrees)
{
  subData <- logZoutRe[logZoutRe$X.treeName==i,]
  if(nrow(subData)==6){  
  logZAnnealledMethod <- subData$logZ[which(subData$Method %in% annealMethods)]
  logZSSMethod <- subData$logZ[which(subData$Method %in% ssMethods)]
  modelSelectionSummary[k,] <- c(i, annealMethods[logZAnnealledMethod==max(logZAnnealledMethod)], ssMethods[logZSSMethod==max(logZSSMethod)])
  k <- k+1
  }
}
modelSelectionSummary