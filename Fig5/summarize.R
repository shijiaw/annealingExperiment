library(ggplot2)
library(Rmisc) 
library(Sleuth2)
library(ggpubr)

tg <- ToothGrowth
tgc <- summarySE(tg, measurevar="len", groupvars=c("supp","dose"))
ggplot(tgc, aes(x=dose, y=len, colour=supp)) + 
  geom_errorbar(aes(ymin=len-se, ymax=len+se), width=.1) +
  geom_line() +
  geom_point()


logZData100 <- data.frame(read.csv("SMC30_100_99999/logZout.csv"))
logZData100 <- logZData100[which(logZData100$Method == 'Adaptive'),]
logZData100$Particle = 100
logZData300 <- data.frame(read.csv("SMC30_300_99999/logZout.csv"))
logZData300 <- logZData300[which(logZData300$Method == 'Adaptive'),]
logZData300$Particle = 300
logZData1000 <- data.frame(read.csv("SMC30_1000_99999/logZout.csv"))
logZData1000 <- logZData1000[which(logZData1000$Method == 'Adaptive'),]
logZData1000$Particle = 1000
logZData3000 <- data.frame(read.csv("SMC30_3000_99999/logZout.csv"))
logZData3000 <- logZData3000[which(logZData3000$Method == 'Adaptive'),]
logZData3000$Particle = 3000



logZData = rbind(logZData100, logZData300, logZData1000, logZData3000)
logZData$Particle = as.factor(logZData$Particle)

logZsummary <- summarySE(logZData, measurevar="logZ", groupvars=c("Particle","Method"))
logZsummary$Particle = as.factor(logZsummary$Particle)

gname = c("logZ.eps",sep="")  
postscript(gname,width=4.5,height=2.5,horizontal = FALSE, onefile = FALSE, paper = "special")
par(mfrow=c(1,1),oma=c(0.2,1.5,0.2,1.5),mar=c(3,2,0.2,2),cex.axis=1,las=1,mgp=c(1,0.5,0),adj=0.5)

ggplot(logZsummary, aes(x=Particle, y=logZ, group = Method)) + 
  geom_errorbar(aes(ymin=logZ-ci, ymax=logZ+ci), width=.1) +
  geom_line() +
  geom_point()+ theme_bw()
dev.off()



results100 <- data.frame(read.csv("SMC30_100_99999/results.csv"))
results100 <- results100[which(results100$Adaptive == 'true'),]
results100$Particle = 100

results300 <- data.frame(read.csv("SMC30_300_99999/results.csv"))
results300 <- results300[which(results300$Adaptive == 'true'),]
results300$Particle = 300

results1000 <- data.frame(read.csv("SMC30_1000_99999/results.csv"))
results1000 <- results1000[which(results1000$Adaptive == 'true'),]
results1000$Particle = 1000

results3000 <- data.frame(read.csv("SMC30_3000_99999/results.csv"))
results3000 <- results3000[which(results3000$Adaptive == 'true'),]
results3000$Particle = 3000

results = rbind(results100, results300, results1000, results3000)
results$Particle = as.factor(results$Particle)


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


ConsensusLogLLsummary <- summarySE(ConsensusLogLL, measurevar="Value", groupvars=c("Particle","Adaptive"))
ConsensusLogLLsummary$Particle = as.factor(ConsensusLogLLsummary$Particle)

PartitionMetricsummary <- summarySE(PartitionMetric, measurevar="Value", groupvars=c("Particle","Adaptive"))
PartitionMetricsummary$Particle = as.factor(PartitionMetricsummary$Particle)

RobinsonFouldsMetricsummary <- summarySE(RobinsonFouldsMetric, measurevar="Value", groupvars=c("Particle","Adaptive"))
RobinsonFouldsMetricsummary$Particle = as.factor(RobinsonFouldsMetricsummary$Particle)

KuhnerFelsensteinsummary <- summarySE(KuhnerFelsenstein, measurevar="Value", groupvars=c("Particle","Adaptive"))
KuhnerFelsensteinsummary$Particle = as.factor(KuhnerFelsensteinsummary$Particle)

p <- ggplot(ConsensusLogLLsummary, aes(x=Particle, y=Value, group = Adaptive))
p2 <- ggplot(PartitionMetricsummary, aes(x=Particle, y=Value, group = Adaptive))
p3 <- ggplot(RobinsonFouldsMetricsummary, aes(x=Particle, y=Value, group = Adaptive))
p4 <- ggplot(KuhnerFelsensteinsummary, aes(x=Particle, y=Value, group = Adaptive))

gname = c("SMCParticle.eps",sep="")  
postscript(gname,width=10,height=3,horizontal = FALSE, onefile = FALSE, paper = "special")
par(mfrow=c(1,1),oma=c(0.2,1.5,0.2,1.5),mar=c(3,2,0.2,2),cex.axis=1,las=1,mgp=c(1,0.5,0),adj=0.5)

ggarrange(ggplot(logZsummary, aes(x=Particle, y=logZ, group = Method)) + 
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
          ,ncol = 5, nrow = 1)

dev.off()







