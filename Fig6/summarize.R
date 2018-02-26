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


logZData999 <- data.frame(read.csv("SMC30_1000_999/logZout.csv"))
logZData999 <- logZData999[which(logZData999$Method == 'Adaptive'),]
logZData999$alpha = 0.999
logZData9999 <- data.frame(read.csv("SMC30_1000_9999/logZout.csv"))
logZData9999 <- logZData9999[which(logZData9999$Method == 'Adaptive'),]
logZData9999$alpha = 0.9999
logZData99995 <- data.frame(read.csv("SMC30_1000_99995/logZout.csv"))
logZData99995 <- logZData99995[which(logZData99995$Method == 'Adaptive'),]
logZData99995$alpha = 0.99995
logZData99999 <- data.frame(read.csv("SMC30_1000_99999/logZout.csv"))
logZData99999 <- logZData99999[which(logZData99999$Method == 'Adaptive'),]
logZData99999$alpha = 0.99999
logZData999995 <- data.frame(read.csv("SMC30_1000_999995/logZout.csv"))
logZData999995 <- logZData999995[which(logZData999995$Method == 'Adaptive'),]
logZData999995$alpha = 0.999995


logZData = rbind(logZData999, logZData9999, logZData99995, logZData99999, logZData999995)
logZData$alpha = as.factor(logZData$alpha)

logZsummary <- summarySE(logZData, measurevar="logZ", groupvars=c("alpha","Method"))
logZsummary$alpha = as.factor(logZsummary$alpha)

gname = c("logZ.eps",sep="")  
postscript(gname,width=4.5,height=2.5,horizontal = FALSE, onefile = FALSE, paper = "special")
par(mfrow=c(1,1),oma=c(0.2,1.5,0.2,1.5),mar=c(3,2,0.2,2),cex.axis=1,las=1,mgp=c(1,0.5,0),adj=0.5)

#ggplot(logZsummary, aes(x=alpha, y=logZ, group = Method, colour=Method)) + 
ggplot(logZsummary, aes(x=alpha, y=logZ, group = Method)) + 
  geom_errorbar(aes(ymin=logZ-ci, ymax=logZ+ci), width=.1) +
  geom_line() +
  geom_point()+ theme_bw()
dev.off()



results999 <- data.frame(read.csv("SMC30_1000_999/results.csv"))
results999 <- results999[which(results999$Adaptive == 'true'),]
results999$alpha = 0.999

results9999 <- data.frame(read.csv("SMC30_1000_9999/results.csv"))
results9999 <- results9999[which(results9999$Adaptive == 'true'),]
results9999$alpha = 0.9999

results99995 <- data.frame(read.csv("SMC30_1000_99995/results.csv"))
results99995 <- results99995[which(results99995$Adaptive == 'true'),]
results99995$alpha = 0.99995

results99999 <- data.frame(read.csv("SMC30_1000_99999/results.csv"))
results99999 <- results99999[which(results99999$Adaptive == 'true'),]
results99999$alpha = 0.99999

results999995 <- data.frame(read.csv("SMC30_1000_999995/results.csv"))
results999995 <- results999995[which(results999995$Adaptive == 'true'),]
results999995$alpha = 0.999995

results = rbind(results999, results9999, results99995, results99999, results999995)
results$alpha = as.factor(results$alpha)


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


ConsensusLogLLsummary <- summarySE(ConsensusLogLL, measurevar="Value", groupvars=c("alpha","Adaptive"))
ConsensusLogLLsummary$alpha = as.factor(ConsensusLogLLsummary$alpha)

PartitionMetricsummary <- summarySE(PartitionMetric, measurevar="Value", groupvars=c("alpha","Adaptive"))
PartitionMetricsummary$alpha = as.factor(PartitionMetricsummary$alpha)

RobinsonFouldsMetricsummary <- summarySE(RobinsonFouldsMetric, measurevar="Value", groupvars=c("alpha","Adaptive"))
RobinsonFouldsMetricsummary$alpha = as.factor(RobinsonFouldsMetricsummary$alpha)

KuhnerFelsensteinsummary <- summarySE(KuhnerFelsenstein, measurevar="Value", groupvars=c("alpha","Adaptive"))
KuhnerFelsensteinsummary$alpha = as.factor(KuhnerFelsensteinsummary$alpha)

Tsummary <- summarySE(ConsensusLogLL, measurevar="T", groupvars=c("alpha","Adaptive"))
Tsummary$alpha = as.factor(Tsummary$alpha)


#p <- ggplot(ConsensusLogLLsummary, aes(x=alpha, y=Value, group = Adaptive, colour=Adaptive))
#p2 <- ggplot(PartitionMetricsummary, aes(x=alpha, y=Value, group = Adaptive, colour=Adaptive))
#p3 <- ggplot(RobinsonFouldsMetricsummary, aes(x=alpha, y=Value, group = Adaptive, colour=Adaptive))
#p4 <- ggplot(KuhnerFelsensteinsummary, aes(x=alpha, y=Value, group = Adaptive, colour=Adaptive))
#p5 <- ggplot(Tsummary, aes(x=alpha, y=T, group = Adaptive, colour=Adaptive))


p <- ggplot(ConsensusLogLLsummary, aes(x=alpha, y=Value, group = Adaptive))
p2 <- ggplot(PartitionMetricsummary, aes(x=alpha, y=Value, group = Adaptive))
p3 <- ggplot(RobinsonFouldsMetricsummary, aes(x=alpha, y=Value, group = Adaptive))
p4 <- ggplot(KuhnerFelsensteinsummary, aes(x=alpha, y=Value, group = Adaptive))
p5 <- ggplot(Tsummary, aes(x=alpha, y=T, group = Adaptive))



gname = c("SMCalpha.eps",sep="")  
postscript(gname,width=10,height=3,horizontal = FALSE, onefile = FALSE, paper = "special")
par(mfrow=c(1,1),oma=c(0.2,1.5,0.2,1.5),mar=c(3,2,0.2,2),cex.axis=1,las=1,mgp=c(1,0.5,0),adj=0.5)

ggarrange(ggplot(logZsummary, aes(x=alpha, y=logZ, group = Method)) + 
            geom_errorbar(aes(ymin=logZ-ci, ymax=logZ+ci), width=.3) +
            geom_line() +rremove("ylab")+ geom_point()+ xlab('logZ')+ theme_bw()+ylab(NULL) + theme(
              axis.text.x = element_blank()),
          p +  geom_errorbar(aes(ymin=Value-ci, ymax=Value+ci), width=.3) +
            geom_line() +
            geom_point()+rremove("ylab")+rremove("legend")+ xlab('ConsensusLogLL')+ theme_bw()+ylab(NULL) + theme(
              axis.text.x = element_blank())
          ,p2 +  geom_errorbar(aes(ymin=max(0, Value-ci), ymax=Value+ci), width=.3) +
            geom_line() + geom_point()+rremove("ylab") + xlab('PartitionMetric')+ theme_bw()+ylab(NULL) + theme(
              axis.text.x = element_blank())
          ,p3 +  geom_errorbar(aes(ymin=Value-ci, ymax=Value+ci), width=.3) +
            geom_line() + geom_point()+rremove("ylab") + xlab('RobinsonFouldsMetric')+ theme_bw()+ylab(NULL) + theme(
              axis.text.x = element_blank())
          ,p4 +  geom_errorbar(aes(ymin=Value-ci, ymax=Value+ci), width=.3) +
            geom_line() + geom_point()+rremove("ylab") + xlab('KuhnerFelsenstein')+ theme_bw()+ylab(NULL) + theme(
              axis.text.x = element_blank())
          ,p5 +  geom_errorbar(aes(ymin=T-ci, ymax=T+ci), width=.3) +
            geom_line() + geom_point()+rremove("ylab") + xlab('R')+ theme_bw()+ylab(NULL) + theme(
              axis.text.x = element_blank())
          ,ncol = 6, nrow = 1)

dev.off()






