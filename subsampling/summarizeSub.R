library(ggplot2)
library(Rmisc) 
library(Sleuth2)
library(ggpubr)

logZ1 <- data.frame(read.csv("results1/logZout.csv"))
logZ1$size <- '1'
logZ10 <- data.frame(read.csv("results10/logZout.csv"))
logZ10$size <- '10'
logZ100 <- data.frame(read.csv("results100/logZout.csv"))
logZ100$size <- '100'
logZ1000 <- data.frame(read.csv("results1000/logZout.csv"))
logZ1000$size <- '1000'
logZAnnealing <- data.frame(read.csv("results10adaptive/logZout.csv"))
logZAnnealing$size <- 'Full'
logZAnnealing <- logZAnnealing[which(logZAnnealing$Method == 'Adaptive'),]

logZ <- rbind(logZ1, logZ10, logZ100, logZ1000, logZAnnealing)
#logZ$Method
#logZCESS <- data.frame(read.csv("CESS99/logZout.csv"))
#logZESS$method <- 'ESS (0.93)'
#logZCESS$method <- 'CESS (0.99)'

#logZ <- rbind(logZESS, logZCESS)
p0 <- ggplot(logZ, aes(size, logZ))

#resultsESS <- data.frame(read.csv("ESS93/results.csv"))
#resultsCESS <- data.frame(read.csv("CESS99/results.csv"))
#resultsESS$method <- 'ESS (0.93)'
#resultsCESS$method <- 'CESS (0.99)'
results1 <- data.frame(read.csv("results1/results.csv"))
results1$size <- '1'
results10 <- data.frame(read.csv("results10/results.csv"))
results10$size <- '10'
results100 <- data.frame(read.csv("results100/results.csv"))
results100$size <- '100'
results1000 <- data.frame(read.csv("results1000/results.csv"))
results1000$size <- '1000'
resultsAnnealing <- data.frame(read.csv("results10adaptive/results.csv"))
resultsAnnealing$size <- 'Full'
#names(resultsAnnealing)[1] <- "Method"
resultsAnnealing <- resultsAnnealing[which(resultsAnnealing[,1] == 'ANNEALING'),]

results <- rbind(results1, results10, results100, results1000, resultsAnnealing)
ConsensusLogLL <- results[which(results$Metric == 'ConsensusLogLL'),]
p1 <- ggplot(ConsensusLogLL, aes(size, Value))
PM <- results[which(results$Metric == 'PartitionMetric'),]
p2 <- ggplot(PM, aes(size, Value))
RF <- results[which(results$Metric == 'RobinsonFouldsMetric'),]
p3 <- ggplot(RF, aes(size, Value))
KF <- results[which(results$Metric == 'KuhnerFelsenstein'),]
p4 <- ggplot(KF, aes(size, Value))
#p5 <- ggplot(results, aes(method, T))
#p5 <- ggplot(logZ30_1000, aes(Method, logZ))


gname = c("subsampling.eps",sep="")  
postscript(gname,width=10,height=3,horizontal = FALSE, onefile = FALSE, paper = "special")
par(mfrow=c(1,1),oma=c(0.2,1.5,0.2,1.5),mar=c(3,2,0.2,2),cex.axis=1,las=1,mgp=c(1,0.5,0),adj=0.5)

ggarrange(p0 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = size))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('logZ'),
          p1 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = size))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('ConsensusLogLL'),
          p2 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = size))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('PartitionMetric'),
          p3 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = size))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('RobinsonFouldsMetric'),
          p4 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = size))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('KuhnerFelsenstein'),
          #p5 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = method))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('R'),
          ncol = 5, nrow = 1, common.legend = TRUE)

dev.off()






