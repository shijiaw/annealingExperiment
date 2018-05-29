library(ggplot2)
library(Rmisc) 
library(Sleuth2)
library(ggpubr)

logZALWAYS <- data.frame(read.csv("Resampling/ALWAYS/results/logZout.csv"))
logZESS <- data.frame(read.csv("Resampling/ESS/results/logZout.csv"))
logZNEVER <- data.frame(read.csv("Resampling/NEVER/results/logZout.csv"))

logZALWAYS$Threshold <- '1'
logZESS$Threshold <- '0.5'
logZNEVER$Threshold <- '0'

logZ <- rbind(logZALWAYS, logZESS, logZNEVER)
p0 <- ggplot(logZ, aes(Threshold, logZ))


resultsESS <- data.frame(read.csv("Resampling/ESS/results/results.csv"))
resultsALWAYS <- data.frame(read.csv("Resampling/ALWAYS/results/results.csv"))
resultsNEVER <- data.frame(read.csv("Resampling/NEVER/results/results.csv"))
resultsESS$Threshold <- '0.5'
resultsALWAYS$Threshold <- '1'
resultsNEVER$Threshold <- '0'


results <- rbind(resultsESS, resultsALWAYS, resultsNEVER)
ConsensusLogLL <- results[which(results$Metric == 'ConsensusLogLL'),]
p1 <- ggplot(ConsensusLogLL, aes(Threshold, Value))
PM <- results[which(results$Metric == 'PartitionMetric'),]
p2 <- ggplot(PM, aes(Threshold, Value))
RF <- results[which(results$Metric == 'RobinsonFouldsMetric'),]
p3 <- ggplot(RF, aes(Threshold, Value))
KF <- results[which(results$Metric == 'KuhnerFelsenstein'),]
p4 <- ggplot(KF, aes(Threshold, Value))
p5 <- ggplot(results, aes(Threshold, T))
#p5 <- ggplot(logZ30_1000, aes(Method, logZ))


gname = c("ResamplingTheshold.eps",sep="")  
postscript(gname,width=10,height=3,horizontal = FALSE, onefile = FALSE, paper = "special")
par(mfrow=c(1,1),oma=c(0.2,1.5,0.2,1.5),mar=c(3,2,0.2,2),cex.axis=1,las=1,mgp=c(1,0.5,0),adj=0.5)

ggarrange(p0 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = Threshold))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('logZ'),
          p1 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = Threshold))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('ConsensusLogLL'),
          p2 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = Threshold))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('PartitionMetric'),
          p3 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = Threshold))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('RobinsonFouldsMetric'),
          p4 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = Threshold))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('KuhnerFelsenstein'),
          ncol = 5, nrow = 1, common.legend = TRUE)

dev.off()






