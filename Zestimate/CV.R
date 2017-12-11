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
  cv <- log(sqrt(sum(exp(log(n)+logZ - logsum(logZ))-1)^2/n))
  return(cv)
}

logZ10 <- data.frame(read.csv("MCMC10/results/logZout.csv"))
logZ10 <- logZ10[-which(logZ10[,2] == 'MCMC'),]
logZ10_A <- logZ10[-which(logZ10[,2] == 'Adaptive'),4]
logZ10_D <- logZ10[-which(logZ10[,2] == 'Deterministic'),4]
logZ10_L <- logZ10[-which(logZ10[,2] == 'LIS'),4]
logZ10_S <- logZ10[-which(logZ10[,2] == 'SS'),4]


logZ10_ACV <- CVlogZ(logZ10_A)
logZ10_DCV <- CVlogZ(logZ10_D)
logZ10_LCV <- CVlogZ(logZ10_L)
logZ10_SCV <- CVlogZ(logZ10_S)

col1 <- c(logZ10_ACV,logZ10_DCV, logZ10_LCV, logZ10_SCV )

logZ15 <- data.frame(read.csv("MCMC15_500/results/logZout.csv"))
logZ15 <- logZ15[-which(logZ15[,2] == 'MCMC'),]
logZ15_A <- logZ15[-which(logZ15[,2] == 'Adaptive'),4]
logZ15_D <- logZ15[-which(logZ15[,2] == 'Deterministic'),4]
logZ15_L <- logZ15[-which(logZ15[,2] == 'LIS'),4]
logZ15_S <- logZ15[-which(logZ15[,2] == 'SS'),4]


logZ15_ACV <- CVlogZ(logZ15_A)
logZ15_DCV <- CVlogZ(logZ15_D)
logZ15_LCV <- CVlogZ(logZ15_L)
logZ15_SCV <- CVlogZ(logZ15_S)

col2 <- c(logZ15_ACV,logZ15_DCV, logZ15_LCV, logZ15_SCV )

logZ20 <- data.frame(read.csv("MCMC20_500/results/logZout.csv"))
logZ20 <- logZ20[-which(logZ20[,2] == 'MCMC'),]
logZ20_A <- logZ20[-which(logZ20[,2] == 'Adaptive'),4]
logZ20_D <- logZ20[-which(logZ20[,2] == 'Deterministic'),4]
logZ20_L <- logZ20[-which(logZ20[,2] == 'LIS'),4]
logZ20_S <- logZ20[-which(logZ20[,2] == 'SS'),4]


logZ20_ACV <- CVlogZ(logZ20_A)
logZ20_DCV <- CVlogZ(logZ20_D)
logZ20_LCV <- CVlogZ(logZ20_L)
logZ20_SCV <- CVlogZ(logZ20_S)

col3 <- c(logZ20_ACV,logZ20_DCV, logZ20_LCV, logZ20_SCV )

###
logZ20_1000 <- data.frame(read.csv("MCMC20_1000/results/logZout.csv"))
logZ20_1000 <- logZ20_1000[-which(logZ20_1000[,2] == 'MCMC'),]
logZ20_1000_A <- logZ20_1000[-which(logZ20_1000[,2] == 'Adaptive'),4]
logZ20_1000_D <- logZ20_1000[-which(logZ20_1000[,2] == 'Deterministic'),4]
logZ20_1000_L <- logZ20_1000[-which(logZ20_1000[,2] == 'LIS'),4]
logZ20_1000_S <- logZ20_1000[-which(logZ20_1000[,2] == 'SS'),4]


logZ20_1000_ACV <- CVlogZ(logZ20_1000_A)
logZ20_1000_DCV <- CVlogZ(logZ20_1000_D)
logZ20_1000_LCV <- CVlogZ(logZ20_1000_L)
logZ20_1000_SCV <- CVlogZ(logZ20_1000_S)

col4 <- c(logZ20_1000_ACV,logZ20_1000_DCV, logZ20_1000_LCV, logZ20_1000_SCV )


####
logZ25 <- data.frame(read.csv("MCMC25_500/results/logZout.csv"))
logZ25 <- logZ25[-which(logZ25[,2] == 'MCMC'),]
logZ25_A <- logZ25[-which(logZ25[,2] == 'Adaptive'),4]
logZ25_D <- logZ25[-which(logZ25[,2] == 'Deterministic'),4]
logZ25_L <- logZ25[-which(logZ25[,2] == 'LIS'),4]
logZ25_S <- logZ25[-which(logZ25[,2] == 'SS'),4]

logZ25_ACV <- CVlogZ(logZ25_A)
logZ25_DCV <- CVlogZ(logZ25_D)
logZ25_LCV <- CVlogZ(logZ25_L)
logZ25_SCV <- CVlogZ(logZ25_S)

col5 <- c(logZ25_ACV,logZ25_DCV, logZ25_LCV, logZ25_SCV )



# logZ30 <- data.frame(read.csv("MCMC30/results/logZout.csv"))
# logZ30 <- logZ30[-which(logZ30[,2] == 'MCMC'),]
# logZ30_A <- logZ30[-which(logZ30[,2] == 'Adaptive'),4]
# logZ30_D <- logZ30[-which(logZ30[,2] == 'Deterministic'),4]
# logZ30_L <- logZ30[-which(logZ30[,2] == 'LIS'),4]
# logZ30_S <- logZ30[-which(logZ30[,2] == 'SS'),4]
# 
# logZ30_ACV <- CVlogZ(logZ30_A)
# logZ30_DCV <- CVlogZ(logZ30_D)
# logZ30_LCV <- CVlogZ(logZ30_L)
# logZ30_SCV <- CVlogZ(logZ30_S)
# 
# col5 <- c(logZ30_ACV,logZ30_DCV, logZ30_LCV, logZ30_SCV )




val <- c(col1, col2, col3, col4, col5)
xtable(matrix(val, nr= 4, nc = 5, byrow = FALSE))



vMatrix <- matrix(val, nr= 4, nc = 3, byrow = FALSE)
par(mfrow = c(1, 1))
plot(vMatrix[1,], ylim = range(vMatrix), type = 'l', ylab = 'log(CV)')
lines(vMatrix[2,], col = 2)
lines(vMatrix[3,], col = 3)
lines(vMatrix[4,], col = 4)
legend('bottomright', c('A', 'D', 'L', 'S'), col = 1:4, lty = 1)

par(mfrow = c(1, 1))
plot(vMatrix[1,c(3,5)], ylim = range(vMatrix), type = 'l', ylab = 'log(CV)')
lines(vMatrix[2,c(3,5)], col = 2)
lines(vMatrix[3,c(3,5)], col = 3)
lines(vMatrix[4,c(3,5)], col = 4)
legend('bottomright', c('A', 'D', 'L', 'S'), col = 1:4, lty = 1)


p <- ggplot(logZ20, aes(Method, logZ))
p + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = Method))+rremove("x.text")+rremove("ylab")+ xlab('logZ')

p <- ggplot(logZ25, aes(Method, logZ))
p + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = Method))+rremove("x.text")+rremove("ylab")+ xlab('logZ')

p <- ggplot(logZ30, aes(Method, logZ))
p + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = Method))+rremove("x.text")+rremove("ylab")+ xlab('logZ')

gname = c("logZSMCMCMC10.eps",sep="")  
postscript(gname,width=4,height=4,horizontal = FALSE, onefile = FALSE, paper = "special")
#par(mfrow=c(1,1),oma=c(0.2,1.5,0.2,1.5),mar=c(3,2,0.2,2),cex.axis=1,las=1,mgp=c(1,0.5,0),adj=0.5)

p <- ggplot(logZ30, aes(Method, logZ))
p + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = Method))+rremove("x.text")+rremove("ylab")+ xlab('logZ')
dev.off()

