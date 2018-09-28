setwd("/Users/lwa68/source/annealingExperiment/modelComparison/deliverables/dataFromGTR2/")

logZoutRe <- read.csv("aggregatedLogZout.csv")
head(logZoutRe)
ncol(logZoutRe)
annealMethods <- c("ANNEALINGJC","ANNEALINGEvolK2P","ANNEALINGEvolGTR")
ssMethods <- c("SSJC","SSEvolK2P","SSEvolGTR")
uniqueTrees <- unique(logZoutRe[,"X.treeName"])
modelSelectionSummary <- matrix(0,length(uniqueTrees),3)
colnames(modelSelectionSummary) <- c("treeName","modelByASMC","modelBySS")
k <- 1
for(i in uniqueTrees)
{
  subData <- logZoutRe[logZoutRe[,"X.treeName"]==i,]
  if(length(unique(subData[,"Method"]))==6){  
    logZAnnealledMethod <- subData[which(subData[,"Method"] %in% annealMethods),c("Method","logZ")]
    logZSSMethod <- subData[which(subData[,"Method"] %in% ssMethods),c("Method","logZ")]
    annealedRe <- unlist(by(logZAnnealledMethod[,"logZ"], logZAnnealledMethod[,"Method"], mean, simplify=FALSE))
    ssRe <- unlist(by(logZSSMethod[,"logZ"], logZSSMethod[,"Method"], mean, simplify=FALSE))
    modelSelectionSummary[k,] <- c(i, names(annealedRe)[which(annealedRe==max(unlist(annealedRe)))], names(ssRe)[which(ssRe==max(unlist(ssRe)))])
    k <- k+1
  }
}