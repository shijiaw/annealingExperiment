library(ggplot2)
library(Rmisc) 
library(Sleuth2)
library(ggpubr)


logZData2 <- data.frame(read.csv("beta2/logZout.csv"))
logZData2 <- logZData2[which(logZData2$Method == 'Adaptive'),]
logZData2$beta = 2
logZData3 <- data.frame(read.csv("beta3/logZout.csv"))
logZData3 <- logZData3[which(logZData3$Method == 'Adaptive'),]
logZData3$beta = 3
logZData4 <- data.frame(read.csv("beta4/logZout.csv"))
logZData4 <- logZData4[which(logZData4$Method == 'Adaptive'),]
logZData4$beta = 4
logZData5 <- data.frame(read.csv("beta5/logZout.csv"))
logZData5 <- logZData5[which(logZData5$Method == 'Adaptive'),]
logZData5$beta = 5
logZData6 <- data.frame(read.csv("beta6/logZout.csv"))
logZData6 <- logZData6[which(logZData6$Method == 'Adaptive'),]
logZData6$beta = 6
logZData7 <- data.frame(read.csv("beta7/logZout.csv"))
logZData7 <- logZData7[which(logZData7$Method == 'Adaptive'),]
logZData7$beta = 7


logZData = rbind(logZData2, logZData3, logZData4, logZData5, logZData6, logZData7)
logZData$beta = as.factor(logZData$beta)
logZsummary <- summarySE(logZData, measurevar="logZ", groupvars=c("beta","Method"))
logZsummary$beta = as.factor(logZsummary$beta)

gname = c("logZ.eps",sep="")  
postscript(gname,width=4.5,height=2.5,horizontal = FALSE, onefile = FALSE, paper = "special")
par(mfrow=c(1,1),oma=c(0.2,1.5,0.2,1.5),mar=c(3,2,0.2,2),cex.axis=1,las=1,mgp=c(1,0.5,0),adj=0.5)

#ggplot(logZsummary, aes(x=alpha, y=logZ, group = Method, colour=Method)) + 
ggplot(logZsummary, aes(x=beta, y=logZ, group = Method)) + 
  geom_errorbar(aes(ymin=logZ-ci, ymax=logZ+ci), width=.1) +
  geom_line() +
  geom_point()+ theme_bw()
dev.off()



results2 <- data.frame(read.csv("beta2/results.csv"))
results2 <- results2[which(results2$Adaptive == 'true'),]
results2$beta = 2
results2$T <- results2$T*4200

results3 <- data.frame(read.csv("beta3/results.csv"))
results3 <- results3[which(results3$Adaptive == 'true'),]
results3$beta = 3
results3$T <- results3$T*1300

results4 <- data.frame(read.csv("beta4/results.csv"))
results4 <- results4[which(results4$Adaptive == 'true'),]
results4$beta = 4
results4$T <- results4$T*350

results5 <- data.frame(read.csv("beta5/results.csv"))
results5 <- results5[which(results5$Adaptive == 'true'),]
results5$beta = 5
results5$T <- results5$T*100

results6 <- data.frame(read.csv("beta6/results.csv"))
results6 <- results6[which(results6$Adaptive == 'true'),]
results6$beta = 6
results6$T <- results6$T*37

results7 <- data.frame(read.csv("beta7/results.csv"))
results7 <- results7[which(results7$Adaptive == 'true'),]
results7$beta = 7
results7$T <- results7$T*15

results = rbind(results2, results3, results4, results5, results6, results7)
results$beta = as.factor(results$beta)


nrow2 <- which(results[,7] == 'BestSampledLogLL')
results <- results[-nrow2,]
results[,2] <- paste(results[,1], results[,2])
method = rep(NA, nrow(results))
method[which(results$Adaptive == 'ANNEALING true')] = 'Adaptive'
#method[which(results$Adaptive == 'ANNEALING false')] = 'Deterministic'
results$Adaptive = method

ConsensusLogLL = results[which(results[,7] == 'ConsensusLogLL'),]
PartitionMetric = results[which(results[,7] == 'PartitionMetric'),]
RobinsonFouldsMetric = results[which(results[,7] == 'RobinsonFouldsMetric'),]
KuhnerFelsenstein = results[which(results[,7] == 'KuhnerFelsenstein'),]


ConsensusLogLLsummary <- summarySE(ConsensusLogLL, measurevar="Value", groupvars=c("beta","Adaptive"))
ConsensusLogLLsummary$beta = as.factor(ConsensusLogLLsummary$beta)

PartitionMetricsummary <- summarySE(PartitionMetric, measurevar="Value", groupvars=c("beta","Adaptive"))
PartitionMetricsummary$beta = as.factor(PartitionMetricsummary$beta)

RobinsonFouldsMetricsummary <- summarySE(RobinsonFouldsMetric, measurevar="Value", groupvars=c("beta","Adaptive"))
RobinsonFouldsMetricsummary$beta = as.factor(RobinsonFouldsMetricsummary$beta)

KuhnerFelsensteinsummary <- summarySE(KuhnerFelsenstein, measurevar="Value", groupvars=c("beta","Adaptive"))
KuhnerFelsensteinsummary$beta = as.factor(KuhnerFelsensteinsummary$beta)

Tsummary <- summarySE(ConsensusLogLL, measurevar="T", groupvars=c("beta","Adaptive"))
Tsummary$beta = as.factor(Tsummary$beta)


#p <- ggplot(ConsensusLogLLsummary, aes(x=alpha, y=Value, group = Adaptive, colour=Adaptive))
#p2 <- ggplot(PartitionMetricsummary, aes(x=alpha, y=Value, group = Adaptive, colour=Adaptive))
#p3 <- ggplot(RobinsonFouldsMetricsummary, aes(x=alpha, y=Value, group = Adaptive, colour=Adaptive))
#p4 <- ggplot(KuhnerFelsensteinsummary, aes(x=alpha, y=Value, group = Adaptive, colour=Adaptive))
#p5 <- ggplot(Tsummary, aes(x=alpha, y=T, group = Adaptive, colour=Adaptive))


p <- ggplot(ConsensusLogLLsummary, aes(x=beta, y=Value, group = Adaptive))
p2 <- ggplot(PartitionMetricsummary, aes(x=beta, y=Value, group = Adaptive))
p3 <- ggplot(RobinsonFouldsMetricsummary, aes(x=beta, y=Value, group = Adaptive))
p4 <- ggplot(KuhnerFelsensteinsummary, aes(x=beta, y=Value, group = Adaptive))
p5 <- ggplot(Tsummary, aes(x=beta, y=T, group = Adaptive))



gname = c("SMCsquare.eps",sep="")  
postscript(gname,width=8,height=6,horizontal = FALSE, onefile = FALSE, paper = "special")
par(mfrow=c(1,1),oma=c(0.2,1.5,0.2,1.5),mar=c(3,2,0.2,2),cex.axis=1,las=1,mgp=c(1,0.5,0),adj=0.5)

ggarrange(ggplot(logZsummary, aes(x=beta, y=logZ, group = Method)) + 
            geom_errorbar(aes(ymin=logZ-ci, ymax=logZ+ci), width=.3) +
            geom_line() +rremove("ylab")+ geom_point()+ xlab('logZ')+ theme_bw()+ylab(NULL) + theme(
              axis.text.x = element_blank()),
          p +  geom_errorbar(aes(ymin=Value-ci, ymax=Value+ci), width=.3) +
            geom_line() +
            geom_point()+rremove("ylab")+rremove("legend")+ xlab('ConsensusLogLL')+ theme_bw()+ylab(NULL) + theme(
              axis.text.x = element_blank())
          ,p2 +  geom_errorbar(aes(ymin=Value-ci, ymax=Value+ci), width=.3) +
            geom_line() + geom_point()+rremove("ylab") + xlab('PartitionMetric')+ theme_bw()+ylab(NULL) + theme(
              axis.text.x = element_blank())
          ,p3 +  geom_errorbar(aes(ymin=Value-ci, ymax=Value+ci), width=.3) +
            geom_line() + geom_point()+rremove("ylab") + xlab('RobinsonFouldsMetric')+ theme_bw()+ylab(NULL) + theme(
              axis.text.x = element_blank())
          ,p4 +  geom_errorbar(aes(ymin=Value-ci, ymax=Value+ci), width=.3) +
            geom_line() + geom_point()+rremove("ylab") + xlab('KuhnerFelsenstein')+ theme_bw()+ylab(NULL) + theme(
              axis.text.x = element_blank())
          ,p5 +  geom_errorbar(aes(ymin=T-ci, ymax=T+ci), width=.3) +
            geom_line() + geom_point()+rremove("ylab") + xlab('K*R')+ theme_bw()+ylab(NULL) + theme(
              axis.text.x = element_blank())
          ,ncol = 3, nrow = 2)

dev.off()






