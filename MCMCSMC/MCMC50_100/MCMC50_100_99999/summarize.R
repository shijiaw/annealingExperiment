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

results1 <- data.frame(read.csv("results1/results.csv"))
results2 <- data.frame(read.csv("results2/results.csv"))
results3 <- data.frame(read.csv("results3/results.csv"))
results4 <- data.frame(read.csv("results4/results.csv"))
results5 <- data.frame(read.csv("results5/results.csv"))
results <- rbind(results1, results2, results3, results4, results5)
results$method = rep(NA, nrow(results))
results$method[which(results$Adaptive == 'true')] = 'Adaptive'
results$method[which(results$Adaptive == 'false')] = 'Deterministic'
results$method[which(results$Adaptive == '')] = 'MCMC'



p2 <- ggplot(results[which(results[,7] == 'ConsensusLogLL'),], aes(method,  Value ))
#p2 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = K))+rremove("x.text")+rremove("ylab")+rremove("legend")+ xlab('ConsensusLogLL')

p3 <- ggplot(results[which(results[,7] == 'PartitionMetric'),], aes(method,  Value ))
#p3 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = K))+rremove("x.text")+rremove("ylab")+rremove("legend")+ xlab('ConsensusLogLL')

p4 <- ggplot(results[which(results[,7] == 'RobinsonFouldsMetric'),], aes(method,  Value))
#p4 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = K))+rremove("x.text")+rremove("ylab")+rremove("legend")+ xlab('RobinsonFouldsMetric')

p5 <- ggplot(results[which(results[,7] == 'KuhnerFelsenstein'),], aes(method, Value))
#p5 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = K))+rremove("x.text")+rremove("ylab")+rremove("legend")+ xlab('KuhnerFelsenstein')

gname = c("TreeDistance50_100.eps",sep="")  
postscript(gname,width=8,height=4,horizontal = FALSE, onefile = FALSE, paper = "special")
#par(mfrow=c(1,1),oma=c(0.2,1.5,0.2,1.5),mar=c(3,2,0.2,2),cex.axis=1,las=1,mgp=c(1,0.5,0),adj=0.5)

ggarrange(p2 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1)+rremove("x.text")+rremove("ylab")+rremove("legend")+ geom_boxplot(aes(color = method))+ xlab('ConsensusLogLL')
          ,p3 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1)+rremove("x.text")+rremove("ylab") + geom_boxplot(aes(color = method))+ xlab('PartitionMetric')
          ,p4 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1)+rremove("x.text")+rremove("ylab") + geom_boxplot(aes(color = method))+ xlab('RobinsonFouldsMetric')
          ,p5 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1)+rremove("x.text")+rremove("ylab") + geom_boxplot(aes(color = method))+ xlab('KuhnerFelsenstein')
          ,
          ncol = 4, nrow = 1, common.legend = TRUE)

dev.off()




