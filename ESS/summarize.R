library(ggplot2)
library(Rmisc) 
library(Sleuth2)
library(ggpubr)

logZESS <- data.frame(read.csv("ESS978/logZout.csv"))
logZCESS <- data.frame(read.csv("CESS/logZout.csv"))
logZESS$method <- 'rESS (0.978)'
logZCESS$method <- 'rCESS (0.999)'

logZ <- rbind(logZESS, logZCESS)
p0 <- ggplot(logZ, aes(method, logZ))

resultsESS <- data.frame(read.csv("ESS978/results.csv"))
resultsCESS <- data.frame(read.csv("CESS/results.csv"))
resultsESS$method <- 'rESS (0.978)'
resultsCESS$method <- 'rCESS (0.999)'

results <- rbind(resultsESS, resultsCESS)
ConsensusLogLL <- results[which(results$Metric == 'ConsensusLogLL'),]
p1 <- ggplot(ConsensusLogLL, aes(method, Value))
PM <- results[which(results$Metric == 'PartitionMetric'),]
p2 <- ggplot(PM, aes(method, Value))
RF <- results[which(results$Metric == 'RobinsonFouldsMetric'),]
p3 <- ggplot(RF, aes(method, Value))
KF <- results[which(results$Metric == 'KuhnerFelsenstein'),]
p4 <- ggplot(KF, aes(method, Value))
p5 <- ggplot(results, aes(method, T))
#p5 <- ggplot(logZ30_1000, aes(Method, logZ))


gname = c("ESSvsCESS15.eps",sep="")  
postscript(gname,width=10,height=3,horizontal = FALSE, onefile = FALSE, paper = "special")
par(mfrow=c(1,1),oma=c(0.2,1.5,0.2,1.5),mar=c(3,2,0.2,2),cex.axis=1,las=1,mgp=c(1,0.5,0),adj=0.5)

ggarrange(p0 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = method))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('logZ'),
          p1 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = method))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('ConsensusLogLL'),
          p2 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = method))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('PartitionMetric'),
          p3 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = method))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('RobinsonFouldsMetric'),
          p4 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = method))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('KuhnerFelsenstein'),
          p5 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = method))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('R'),
          ncol = 6, nrow = 1, common.legend = TRUE)

dev.off()






