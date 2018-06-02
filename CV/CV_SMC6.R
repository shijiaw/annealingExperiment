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


nreplicates <- 10

###10 taxa ###
logZ10SMC_Tree <- NULL
CV_SMC10 <- rep(NA, 10)
for(i in 1:10){
  route_SMC <- paste('ASMC/Tree_taxa10_SMC/results', i, '/logZout.csv', sep = '')
  logZ10SMC_Tree1 <- data.frame(read.csv(route_SMC))
  logZ10SMC_Tree1$seed <- i
  logZ10SMC_Tree1$taxa <- 10
  logZ10SMC_Tree1 <- logZ10SMC_Tree1[which(logZ10SMC_Tree1$Method == 'Adaptive'),]
  CV_SMC10[i] <- CVlogZ(logZ10SMC_Tree1$logZ)
  #logZ10SMC_Tree <- rbind(logZ10SMC_Tree ,logZ10SMC_Tree1)
  
}

###15 taxa ###
logZ15SMC_Tree <- NULL
CV_SMC15 <- rep(NA, 10)
for(i in 1:10){
  route_SMC <- paste('ASMC/Tree_taxa15_SMC/results', i, '/logZout.csv', sep = '')
  logZ15SMC_Tree1 <- data.frame(read.csv(route_SMC))
  logZ15SMC_Tree1$seed <- i
  logZ15SMC_Tree1$taxa <- 15
  logZ15SMC_Tree1 <- logZ15SMC_Tree1[which(logZ15SMC_Tree1$Method == 'Adaptive'),]
  CV_SMC15[i] <- CVlogZ(logZ15SMC_Tree1$logZ)
  #logZ10SMC_Tree <- rbind(logZ10SMC_Tree ,logZ10SMC_Tree1)
  
}

###20 taxa ###
logZ20SMC_Tree <- NULL
CV_SMC20 <- rep(NA, 10)
for(i in 1:10){
  route_SMC <- paste('ASMC/Tree_taxa20_SMC/results', i, '/logZout.csv', sep = '')
  logZ20SMC_Tree1 <- data.frame(read.csv(route_SMC))
  logZ20SMC_Tree1$seed <- i
  logZ20SMC_Tree1$taxa <- 20
  logZ20SMC_Tree1 <- logZ20SMC_Tree1[which(logZ20SMC_Tree1$Method == 'Adaptive'),]
  CV_SMC20[i] <- CVlogZ(logZ20SMC_Tree1$logZ)
}

###25 taxa ###
logZ25SMC_Tree <- NULL
CV_SMC25 <- rep(NA, 10)
for(i in 1:10){
  route_SMC <- paste('ASMC/Tree_taxa25_SMC/results', i, '/logZout.csv', sep = '')
  logZ25SMC_Tree1 <- data.frame(read.csv(route_SMC))
  logZ25SMC_Tree1$seed <- i
  logZ25SMC_Tree1$taxa <- 25
  logZ25SMC_Tree1 <- logZ25SMC_Tree1[which(logZ25SMC_Tree1$Method == 'Adaptive'),]
  CV_SMC25[i] <- CVlogZ(logZ25SMC_Tree1$logZ)
}

###30 taxa ###
logZ30SMC_Tree <- NULL
CV_SMC30 <- rep(NA, 10)
for(i in 1:10){
  route_SMC <- paste('ASMC/Tree_taxa30_SMC/results', i, '/logZout.csv', sep = '')
  logZ30SMC_Tree1 <- data.frame(read.csv(route_SMC))
  logZ30SMC_Tree1$seed <- i
  logZ30SMC_Tree1$taxa <- 30
  logZ30SMC_Tree1 <- logZ30SMC_Tree1[which(logZ30SMC_Tree1$Method == 'Adaptive'),]
  CV_SMC30[i] <- CVlogZ(logZ30SMC_Tree1$logZ)
}

###35 taxa ###
logZ35SMC_Tree <- NULL
CV_SMC35 <- rep(NA, 10)
for(i in 1:10){
  route_SMC <- paste('ASMC/Tree_taxa35_SMC/results', i, '/logZout.csv', sep = '')
  logZ35SMC_Tree1 <- data.frame(read.csv(route_SMC))
  logZ35SMC_Tree1$seed <- i
  logZ35SMC_Tree1$taxa <- 35
  logZ35SMC_Tree1 <- logZ35SMC_Tree1[which(logZ35SMC_Tree1$Method == 'Adaptive'),]
  CV_SMC35[i] <- CVlogZ(logZ35SMC_Tree1$logZ)
}


###40 taxa ###
logZ40SMC_Tree <- NULL
CV_SMC40 <- rep(NA, 7)
for(i in 1:7){
  route_SMC <- paste('ASMC/Tree_taxa40_SMC/results', i, '/logZout.csv', sep = '')
  logZ40SMC_Tree1 <- data.frame(read.csv(route_SMC))
  logZ40SMC_Tree1$seed <- i
  logZ40SMC_Tree1$taxa <- 40
  logZ40SMC_Tree1 <- logZ40SMC_Tree1[which(logZ40SMC_Tree1$Method == 'Adaptive'),]
  #logZ40SMC_Tree <- rbind(logZ40SMC_Tree ,logZ40SMC_Tree1)
  CV_SMC40[i] <- CVlogZ(logZ40SMC_Tree1$logZ)
}


CV_ASMC <- c(CV_SMC10, CV_SMC15, CV_SMC20, CV_SMC25, CV_SMC30, CV_SMC35, CV_SMC40)

#logZ <- rbind(logZ10SMC_Tree, logZ15SMC_Tree,logZ20SMC_Tree, logZ25SMC_Tree, logZ30SMC_Tree, logZ35SMC_Tree,logZ40SMC_Tree)

#A_logZ <- logZ[which(logZ$Method == 'Adaptive'),]


###DSMC 10 taxa ###
logZ10DSMC_Tree <- NULL
CV_DSMC10 <- rep(NA, 10)
for(i in 1:10){
  route_DSMC10 <- paste('DSMC/Tree_taxa10_SMC/results', i, '/logZout.csv', sep = '')
  logZ10DSMC_Tree1 <- data.frame(read.csv(route_DSMC10))
  logZ10DSMC_Tree1$seed <- i
  logZ10DSMC_Tree1$taxa <- 10
  #logZ10DSMC_Tree <- rbind(logZ10DSMC_Tree ,logZ10DSMC_Tree1)
  CV_DSMC10[i] <- CVlogZ(logZ10DSMC_Tree1$logZ)
}

###DSMC 15 taxa ###
logZ15DSMC_Tree <- NULL
CV_DSMC15 <- rep(NA, 10)
for(i in 1:10){
  route_DSMC15 <- paste('DSMC/Tree_taxa15_SMC/results', i, '/logZout.csv', sep = '')
  logZ15DSMC_Tree1 <- data.frame(read.csv(route_DSMC15))
  logZ15DSMC_Tree1$seed <- i
  logZ15DSMC_Tree1$taxa <- 15
  #logZ10DSMC_Tree <- rbind(logZ10DSMC_Tree ,logZ10DSMC_Tree1)
  CV_DSMC15[i] <- CVlogZ(logZ15DSMC_Tree1$logZ)
}


###DSMC 20 taxa ###
logZ20DSMC_Tree <- NULL
CV_DSMC20 <- rep(NA, 10)
for(i in 1:10){
  route_DSMC20 <- paste('DSMC/Tree_taxa20_SMC/results', i, '/logZout.csv', sep = '')
  logZ20DSMC_Tree1 <- data.frame(read.csv(route_DSMC20))
  logZ20DSMC_Tree1$seed <- i
  logZ20DSMC_Tree1$taxa <- 20
  CV_DSMC20[i] <- CVlogZ(logZ20DSMC_Tree1$logZ)
  #logZ20DSMC_Tree <- rbind(logZ20DSMC_Tree ,logZ20DSMC_Tree1)
}

###DSMC 25 taxa ###
logZ25DSMC_Tree <- NULL
CV_DSMC25 <- rep(NA, 10)
for(i in 1:10){
  route_DSMC25 <- paste('DSMC/Tree_taxa25_SMC/results', i, '/logZout.csv', sep = '')
  logZ25DSMC_Tree1 <- data.frame(read.csv(route_DSMC25))
  logZ25DSMC_Tree1$seed <- i
  logZ25DSMC_Tree1$taxa <- 25
  CV_DSMC25[i] <- CVlogZ(logZ25DSMC_Tree1$logZ)
  #logZ20DSMC_Tree <- rbind(logZ20DSMC_Tree ,logZ20DSMC_Tree1)
}


###DSMC 30 taxa ###
logZ30DSMC_Tree <- NULL
CV_DSMC30 <- rep(NA, 10)
for(i in 1:10){
  route_DSMC30 <- paste('DSMC/Tree_taxa30_SMC/results', i, '/logZout.csv', sep = '')
  logZ30DSMC_Tree1 <- data.frame(read.csv(route_DSMC30))
  logZ30DSMC_Tree1$seed <- i
  logZ30DSMC_Tree1$taxa <- 30
  CV_DSMC30[i] <- CVlogZ(logZ30DSMC_Tree1$logZ)
  #logZ30DSMC_Tree <- rbind(logZ30DSMC_Tree ,logZ30DSMC_Tree1)
}

###DSMC 35 taxa ###
logZ35DSMC_Tree <- NULL
CV_DSMC35 <- rep(NA, 10)
for(i in 1:10){
  route_DSMC35 <- paste('DSMC/Tree_taxa35_SMC/results', i, '/logZout.csv', sep = '')
  logZ35DSMC_Tree1 <- data.frame(read.csv(route_DSMC35))
  logZ35DSMC_Tree1$seed <- i
  logZ35DSMC_Tree1$taxa <- 35
  CV_DSMC35[i] <- CVlogZ(logZ35DSMC_Tree1$logZ)
  #logZ30DSMC_Tree <- rbind(logZ30DSMC_Tree ,logZ30DSMC_Tree1)
}

###DSMC 40 taxa ###
logZ40DSMC_Tree <- NULL
CV_DSMC40 <- rep(NA, 10)
for(i in 1:10){
  route_DSMC40 <- paste('DSMC/Tree_taxa40_SMC/results', i, '/logZout.csv', sep = '')
  logZ40DSMC_Tree1 <- data.frame(read.csv(route_DSMC40))
  logZ40DSMC_Tree1$seed <- i
  logZ40DSMC_Tree1$taxa <- 40
  CV_DSMC40[i] <- CVlogZ(logZ40DSMC_Tree1$logZ)
  #logZ40DSMC_Tree <- rbind(logZ40DSMC_Tree,logZ40DSMC_Tree1)
}


CV_DSMC <- c(CV_DSMC10, CV_DSMC15, CV_DSMC20, CV_DSMC25, CV_DSMC30, CV_DSMC35, CV_DSMC40)
CVmatrix <- data.frame(CV = c(CV_ASMC, CV_DSMC))
CVmatrix$Method <- c(rep('ASMC', 67), rep('DSMC', 70)) 
CVmatrix$ntaxa <- c(rep(c(rep(10, 10), rep(15, 10), rep(20, 10), rep(25, 10), rep(30, 10), rep(35, 10), rep(40, 7)) ,2), rep(40, 3))
#CVmatrix$CV <- c(CV_ASMC, CV_DSMC)
#D_logZ <- rbind(logZ10DSMC_Tree, logZ15DSMC_Tree,logZ20DSMC_Tree, logZ25DSMC_Tree,
#              logZ30DSMC_Tree, logZ35DSMC_Tree,
#              logZ40DSMC_Tree)

#D_logZ <- D_logZ[which(D_logZ$Method == 'Deterministic'),]

#SMC_logZ <- rbind(D_logZ, A_logZ)
#CVmatrix <- aggregate(x = logZ$logZ, by = list(logZ$Method, logZ$seed, logZ$taxa), FUN = function(x)(CVlogZ(x)))
#colnames(CVmatrix) <- c("Method", "Seed", "taxa", "CV")
CVse <- summarySE(CVmatrix, measurevar="CV", groupvars=c("Method","ntaxa"))
#CVse$Method <- rep(c('ASMC', 'DSMC'), each = 7)

gname = c("CV_SMC6.eps",sep="")  
postscript(gname,width=5,height=3.5,horizontal = FALSE, onefile = FALSE, paper = "special")
par(mfrow=c(1,1),oma=c(0.2,1.5,0.2,1.5),mar=c(3,2,0.2,2),cex.axis=1,las=1,mgp=c(1,0.5,0),adj=0.5)

ggplot(CVse, aes(x=ntaxa, y=CV, colour=Method)) + 
  geom_errorbar(aes(ymin=CV-ci, ymax=CV+ci), width=1.3) +
  geom_line() +
  geom_point()+ theme_bw()

dev.off()





