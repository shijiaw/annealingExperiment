library(ggplot2)
library(Rmisc) 
library(Sleuth2)
library(ggpubr)


logZData2 <- data.frame(read.csv("K100/logZout.csv"))
#logZData2 <- logZData2[which(logZData2$Method == 'Adaptive'),]
logZData2$K = 100
logZData3 <- data.frame(read.csv("K300/logZout.csv"))
#logZData3 <- logZData3[which(logZData3$Method == 'Adaptive'),]
logZData3$K = 300
logZData4 <- data.frame(read.csv("K1000/logZout.csv"))
#logZData4 <- logZData4[which(logZData4$Method == 'Adaptive'),]
logZData4$K = 1000
logZData5 <- data.frame(read.csv("K3000/logZout.csv"))
#logZData5 <- logZData5[which(logZData5$Method == 'Adaptive'),]
logZData5$K = 3000
logZData6 <- data.frame(read.csv("K10000/logZout.csv"))
#logZData6 <- logZData6[which(logZData6$Method == 'Adaptive'),]
logZData6$K = 10000


logZData = rbind(logZData2, logZData3, logZData4, logZData5, logZData6)
logZData$K = as.factor(logZData$K)
logZsummary <- summarySE(logZData, measurevar="logZ", groupvars=c("K","Method"))
logZsummary$K = as.factor(logZsummary$K)

gname = c("logZ.eps",sep="")  
postscript(gname,width=4.5,height=2.5,horizontal = FALSE, onefile = FALSE, paper = "special")
par(mfrow=c(1,1),oma=c(0.2,1.5,0.2,1.5),mar=c(3,2,0.2,2),cex.axis=1,las=1,mgp=c(1,0.5,0),adj=0.5)

#ggplot(logZsummary, aes(x=alpha, y=logZ, group = Method, colour=Method)) + 
ggplot(logZsummary, aes(x=K, y=logZ, group = Method)) + 
  geom_errorbar(aes(ymin=logZ-ci, ymax=logZ+ci), width=.1) +
  geom_line() +
  geom_point()+ theme_bw()
dev.off()



results2 <- data.frame(read.csv("K100/results.csv"))
#results2 <- results2[which(results2$Adaptive == 'true'),]
results2$K = 100
#results2$T <- results2$T*4200

results3 <- data.frame(read.csv("K300/results.csv"))
#results3 <- results3[which(results3$Adaptive == 'true'),]
results3$K = 300
#results3$T <- results3$T*1300

results4 <- data.frame(read.csv("K1000/results.csv"))
#results4 <- results4[which(results4$Adaptive == 'true'),]
results4$K = 1000
#results4$T <- results4$T*350

results5 <- data.frame(read.csv("K3000/results.csv"))
#results5 <- results5[which(results5$Adaptive == 'true'),]
results5$K = 3000
#results5$T <- results5$T*100

results6 <- data.frame(read.csv("K10000/results.csv"))
#results6 <- results6[which(results6$Adaptive == 'true'),]
results6$K = 10000
#results6$T <- results6$T*37

results = rbind(results2, results3, results4, results5, results6)
results$K = as.factor(results$K)


nrow2 <- which(results[,7] == 'BestSampledLogLL')
results <- results[-nrow2,]
results[,2] <- paste(results[,1], results[,2])
#method = rep(NA, nrow(results))
#method[which(results$Adaptive == 'ANNEALING true')] = 'Adaptive'
#method[which(results$Adaptive == 'ANNEALING false')] = 'Deterministic'
#results$Adaptive = method

ConsensusLogLL = results[which(results[,7] == 'ConsensusLogLL'),]
PartitionMetric = results[which(results[,7] == 'PartitionMetric'),]
RobinsonFouldsMetric = results[which(results[,7] == 'RobinsonFouldsMetric'),]
KuhnerFelsenstein = results[which(results[,7] == 'KuhnerFelsenstein'),]


ConsensusLogLLsummary <- summarySE(ConsensusLogLL, measurevar="Value", groupvars=c("K","Adaptive"))
ConsensusLogLLsummary$K = as.factor(ConsensusLogLLsummary$K)

PartitionMetricsummary <- summarySE(PartitionMetric, measurevar="Value", groupvars=c("K","Adaptive"))
PartitionMetricsummary$K = as.factor(PartitionMetricsummary$K)

RobinsonFouldsMetricsummary <- summarySE(RobinsonFouldsMetric, measurevar="Value", groupvars=c("K","Adaptive"))
RobinsonFouldsMetricsummary$K = as.factor(RobinsonFouldsMetricsummary$K)

KuhnerFelsensteinsummary <- summarySE(KuhnerFelsenstein, measurevar="Value", groupvars=c("K","Adaptive"))
KuhnerFelsensteinsummary$K = as.factor(KuhnerFelsensteinsummary$K)

#Tsummary <- summarySE(ConsensusLogLL, measurevar="T", groupvars=c("beta","Adaptive"))
#Tsummary$beta = as.factor(Tsummary$beta)


#p <- ggplot(ConsensusLogLLsummary, aes(x=alpha, y=Value, group = Adaptive, colour=Adaptive))
#p2 <- ggplot(PartitionMetricsummary, aes(x=alpha, y=Value, group = Adaptive, colour=Adaptive))
#p3 <- ggplot(RobinsonFouldsMetricsummary, aes(x=alpha, y=Value, group = Adaptive, colour=Adaptive))
#p4 <- ggplot(KuhnerFelsensteinsummary, aes(x=alpha, y=Value, group = Adaptive, colour=Adaptive))
#p5 <- ggplot(Tsummary, aes(x=alpha, y=T, group = Adaptive, colour=Adaptive))


#p <- ggplot(ConsensusLogLLsummary, aes(x=K, y=Value, group = Adaptive))
#p2 <- ggplot(PartitionMetricsummary, aes(x=K, y=Value, group = Adaptive))
#p3 <- ggplot(RobinsonFouldsMetricsummary, aes(x=K, y=Value, group = Adaptive))
p4 <- ggplot(KuhnerFelsensteinsummary, aes(x=K, y=Value, group = Adaptive))
#p5 <- ggplot(Tsummary, aes(x=beta, y=T, group = Adaptive))



gname = c("SMCsquare.eps",sep="")  
postscript(gname,width=7,height=2.5,horizontal = FALSE, onefile = FALSE, paper = "special")
par(mfrow=c(1,1),oma=c(0.2,1.5,0.2,1.5),mar=c(3,2,0.2,2),cex.axis=1,las=1,mgp=c(1,0.5,0),adj=0.5)

ggarrange(ggplot(logZsummary, aes(x=K, y=logZ, group = Method)) + 
            geom_errorbar(aes(ymin=logZ-ci, ymax=logZ+ci), width=.3) +
            geom_line() + geom_point()+ ylab('logZ')+ theme_bw()+xlab(NULL) + theme(
              ),
          # p +  geom_errorbar(aes(ymin=Value-ci, ymax=Value+ci), width=.3) +
          #   geom_line() +
          #   geom_point()+rremove("ylab")+rremove("legend")+ xlab('ConsensusLogLL')+ theme_bw()+ylab(NULL) + theme(
          #     axis.text.x = element_blank())
          # ,p2 +  geom_errorbar(aes(ymin=Value-ci, ymax=Value+ci), width=.3) +
          #   geom_line() + geom_point()+rremove("ylab") + xlab('PartitionMetric')+ theme_bw()+ylab(NULL) + theme(
          #     axis.text.x = element_blank())
          # ,p3 +  geom_errorbar(aes(ymin=Value-ci, ymax=Value+ci), width=.3) +
          #   geom_line() + geom_point()+rremove("ylab") + xlab('RobinsonFouldsMetric')+ theme_bw()+ylab(NULL) + theme(
          #     axis.text.x = element_blank())
          p4 +  geom_errorbar(aes(ymin=Value-ci, ymax=Value+ci), width=.3) +
            geom_line() + geom_point() + ylab('KuhnerFelsenstein')+ theme_bw()+xlab(NULL) + theme()
          ,ncol = 2, nrow = 1)

dev.off()






