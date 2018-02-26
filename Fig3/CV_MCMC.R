rm(list = ls())
library(ggplot2)
library(Rmisc) 
library(Sleuth2)
library(ggpubr)
library(xtable)

logsum <- function(logZ){
  maxLogZ <- max(logZ)
  logZtemp <- logZ - maxLogZ
  logS <- log(sum(exp(logZtemp))) + maxLogZ
  return(logS)
}

CVlogZ <- function(logZ){
  n <- length(logZ)
  logEZ <- logsum(logZ)-log(n)
  logP <- log((exp(logZ-logEZ)-1)^2)
  logcv <- 0.5*logsum(logP) - 0.5*log(n)
  return(exp(logcv))
}



###10 taxa ###
CV_LIS10 <- rep(NA, 10)
CV_SS10 <- rep(NA, 10)
for(i in 1:10){
  route_MCMC <- paste('Tree', i, '/MCMC10/results/logZout.csv', sep = '')
  logZ10MCMC_Tree1 <- data.frame(read.csv(route_MCMC))
  logZ10MCMC_Tree1$seed <- i
  logZ10MCMC_Tree1$taxa <- 10
  logZ10LIS <- logZ10MCMC_Tree1[which(logZ10MCMC_Tree1$Method == 'LIS'),]
  logZ10SS <- logZ10MCMC_Tree1[which(logZ10MCMC_Tree1$Method == 'SS'),]
  CV_LIS10[i] <- CVlogZ(logZ10LIS$logZ)
  CV_SS10[i] <- CVlogZ(logZ10SS$logZ)
}

###15 taxa ###
CV_LIS15 <- rep(NA, 10)
CV_SS15 <- rep(NA, 10)
for(i in 1:10){
  route_MCMC <- paste('Tree', i, '/MCMC15/results/logZout.csv', sep = '')
  logZ15MCMC_Tree1 <- data.frame(read.csv(route_MCMC))
  logZ15MCMC_Tree1$seed <- i
  logZ15MCMC_Tree1$taxa <- 15
  logZ15LIS <- logZ15MCMC_Tree1[which(logZ15MCMC_Tree1$Method == 'LIS'),]
  logZ15SS <- logZ15MCMC_Tree1[which(logZ15MCMC_Tree1$Method == 'SS'),]
  CV_LIS15[i] <- CVlogZ(logZ15LIS$logZ)
  CV_SS15[i] <- CVlogZ(logZ15SS$logZ)
}



###20 taxa ###
CV_LIS20 <- rep(NA, 10)
CV_SS20 <- rep(NA, 10)
for(i in 1:10){
  route_MCMC <- paste('Tree', i, '/MCMC20/results/logZout.csv', sep = '')
  logZ20MCMC_Tree1 <- data.frame(read.csv(route_MCMC))
  logZ20MCMC_Tree1$seed <- i
  logZ20MCMC_Tree1$taxa <- 20
  logZ20LIS <- logZ20MCMC_Tree1[which(logZ20MCMC_Tree1$Method == 'LIS'),]
  logZ20SS <- logZ20MCMC_Tree1[which(logZ20MCMC_Tree1$Method == 'SS'),]
  CV_LIS20[i] <- CVlogZ(logZ20LIS$logZ)
  CV_SS20[i] <- CVlogZ(logZ20SS$logZ)
}

###25 taxa ###
CV_LIS25 <- rep(NA, 10)
CV_SS25 <- rep(NA, 10)
for(i in 1:10){
  route_MCMC <- paste('Tree', i, '/MCMC25/results/logZout.csv', sep = '')
  logZ25MCMC_Tree1 <- data.frame(read.csv(route_MCMC))
  logZ25MCMC_Tree1$seed <- i
  logZ25MCMC_Tree1$taxa <- 25
  logZ25LIS <- logZ25MCMC_Tree1[which(logZ25MCMC_Tree1$Method == 'LIS'),]
  logZ25SS <- logZ25MCMC_Tree1[which(logZ25MCMC_Tree1$Method == 'SS'),]
  CV_LIS25[i] <- CVlogZ(logZ25LIS$logZ)
  CV_SS25[i] <- CVlogZ(logZ25SS$logZ)
}

###30 taxa ###
CV_LIS30 <- rep(NA, 10)
CV_SS30 <- rep(NA, 10)
for(i in 1:10){
  route_MCMC <- paste('Tree', i, '/MCMC30/results/logZout.csv', sep = '')
  logZ30MCMC_Tree1 <- data.frame(read.csv(route_MCMC))
  logZ30MCMC_Tree1$seed <- i
  logZ30MCMC_Tree1$taxa <- 30
  logZ30LIS <- logZ30MCMC_Tree1[which(logZ30MCMC_Tree1$Method == 'LIS'),]
  logZ30SS <- logZ30MCMC_Tree1[which(logZ30MCMC_Tree1$Method == 'SS'),]
  CV_LIS30[i] <- CVlogZ(logZ30LIS$logZ)
  CV_SS30[i] <- CVlogZ(logZ30SS$logZ)
}

###35 taxa ###
CV_LIS35 <- rep(NA, 10)
CV_SS35 <- rep(NA, 10)
for(i in 1:10){
  route_MCMC <- paste('Tree', i, '/MCMC35/results/logZout.csv', sep = '')
  logZ35MCMC_Tree1 <- data.frame(read.csv(route_MCMC))
  logZ35MCMC_Tree1$seed <- i
  logZ35MCMC_Tree1$taxa <- 35
  logZ35LIS <- logZ35MCMC_Tree1[which(logZ35MCMC_Tree1$Method == 'LIS'),]
  logZ35SS <- logZ35MCMC_Tree1[which(logZ35MCMC_Tree1$Method == 'SS'),]
  CV_LIS35[i] <- CVlogZ(logZ35LIS$logZ)
  CV_SS35[i] <- CVlogZ(logZ35SS$logZ)
}


###40 taxa ###
CV_LIS40 <- rep(NA, 10)
CV_SS40 <- rep(NA, 10)
for(i in 1:10){
  route_MCMC <- paste('Tree', i, '/MCMC40/results/logZout.csv', sep = '')
  logZ40MCMC_Tree1 <- data.frame(read.csv(route_MCMC))
  logZ40MCMC_Tree1$seed <- i
  logZ40MCMC_Tree1$taxa <- 40
  logZ40LIS <- logZ40MCMC_Tree1[which(logZ40MCMC_Tree1$Method == 'LIS'),]
  logZ40SS <- logZ40MCMC_Tree1[which(logZ40MCMC_Tree1$Method == 'SS'),]
  CV_LIS40[i] <- CVlogZ(logZ40LIS$logZ)
  CV_SS40[i] <- CVlogZ(logZ40SS$logZ)
  
}

CV_LIS <- c(CV_LIS10, CV_LIS15, CV_LIS20, CV_LIS25, CV_LIS30, CV_LIS35, CV_LIS40)
CV_SS <- c(CV_SS10, CV_SS15, CV_SS20, CV_SS25, CV_SS30, CV_SS35, CV_SS40)

CVmatrix <- data.frame(CV = c(CV_LIS, CV_SS))
CVmatrix$Method <- c(rep('LIS', 70), rep('SS', 70)) 
CVmatrix$ntaxa <- rep(c(rep(10, 10), rep(15, 10), rep(20, 10), rep(25, 10), rep(30, 10), rep(35, 10), rep(40, 10)) ,2)
#CVmatrix$CV <- c(CV_ASMC, CV_DSMC)
#logZ <- rbind(logZ10MCMC_Tree, logZ15MCMC_Tree,               logZ20MCMC_Tree, logZ25MCMC_Tree,               logZ30MCMC_Tree, logZ35MCMC_Tree, logZ40MCMC_Tree)

#logZ <- logZ[,-c(1,3)]

#CVmatrix <- aggregate(x = logZ$logZ, by = list(logZ$Method, logZ$seed, logZ$taxa), FUN = function(x)(CVlogZ(x)))
#colnames(CVmatrix) <- c("Method", "Seed", "taxa", "CV")
CVse <- summarySE(CVmatrix, measurevar="CV", groupvars=c("Method","ntaxa"))
#CVse$Method <- rep(c('LIS', 'SS'), each = 7)

gname = c("CV_MCMC.eps",sep="")  
postscript(gname,width=5,height=3.5,horizontal = FALSE, onefile = FALSE, paper = "special")
par(mfrow=c(1,1),oma=c(0.2,1.5,0.2,1.5),mar=c(3,2,0.2,2),cex.axis=1,las=1,mgp=c(1,0.5,0),adj=0.5)

ggplot(CVse, aes(x=ntaxa, y=CV, colour=Method)) + 
  geom_errorbar(aes(ymin=CV-ci, ymax=CV+ci), width=1.3) +
  geom_line() +
  geom_point()+ theme_bw()

dev.off()





