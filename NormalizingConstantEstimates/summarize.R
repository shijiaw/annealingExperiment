library(ggplot2)
library(Rmisc) 
library(Sleuth2)
library(ggpubr)

logZ5_1 <- data.frame(read.csv("MCMC5_1000/results1/logZout.csv"))
logZ5_2 <- data.frame(read.csv("MCMC5_1000/results2/logZout.csv"))
logZ5_3 <- data.frame(read.csv("MCMC5_1000/results3/logZout.csv"))
logZ5_4 <- data.frame(read.csv("MCMC5_1000/results4/logZout.csv"))
logZ5_5 <- data.frame(read.csv("MCMC5_1000/results5/logZout.csv"))
logZ5 <- rbind(logZ5_1, logZ5_2, logZ5_3, logZ5_4, logZ5_5)
logZ5 <- logZ5[-which(logZ5[,2] == 'MCMC'),]
logZ5$Method <- rep(c('ASMC', 'DSMC', 'LIS', 'SS'), 100)

logZ10_1 <- data.frame(read.csv("MCMC10_1000/results1/logZout.csv"))
logZ10_2 <- data.frame(read.csv("MCMC10_1000/results2/logZout.csv"))
logZ10_3 <- data.frame(read.csv("MCMC10_1000/results3/logZout.csv"))
logZ10_4 <- data.frame(read.csv("MCMC10_1000/results4/logZout.csv"))
logZ10_5 <- data.frame(read.csv("MCMC10_1000/results5/logZout.csv"))
logZ10_6 <- data.frame(read.csv("MCMC10_1000/results6/logZout.csv"))
logZ10_7 <- data.frame(read.csv("MCMC10_1000/results7/logZout.csv"))
logZ10_8 <- data.frame(read.csv("MCMC10_1000/results8/logZout.csv"))
logZ10_9 <- data.frame(read.csv("MCMC10_1000/results9/logZout.csv"))
logZ10_10 <- data.frame(read.csv("MCMC10_1000/results10/logZout.csv"))
logZ10 <- rbind(logZ10_1, logZ10_2, logZ10_3, logZ10_4, logZ10_5, logZ10_6, logZ10_7, logZ10_8, logZ10_9, logZ10_10)
logZ10 <- logZ10[-which(logZ10[,2] == 'MCMC'),]
logZ10$Method <- rep(c('ASMC', 'DSMC', 'LIS', 'SS'), 100)

logZ15_1 <- data.frame(read.csv("MCMC15_1000/results1/logZout.csv"))
logZ15_2 <- data.frame(read.csv("MCMC15_1000/results2/logZout.csv"))
logZ15_3 <- data.frame(read.csv("MCMC15_1000/results3/logZout.csv"))
logZ15_4 <- data.frame(read.csv("MCMC15_1000/results4/logZout.csv"))
logZ15_5 <- data.frame(read.csv("MCMC15_1000/results5/logZout.csv"))
logZ15_6 <- data.frame(read.csv("MCMC15_1000/results6/logZout.csv"))
logZ15_7 <- data.frame(read.csv("MCMC15_1000/results7/logZout.csv"))
logZ15_8 <- data.frame(read.csv("MCMC15_1000/results8/logZout.csv"))
logZ15_9 <- data.frame(read.csv("MCMC15_1000/results9/logZout.csv"))
logZ15_10 <- data.frame(read.csv("MCMC15_1000/results10/logZout.csv"))
logZ15 <- rbind(logZ15_1, logZ15_2, logZ15_3, logZ15_4, logZ15_5, logZ15_6, logZ15_7,logZ15_8, logZ15_9, logZ15_10)
logZ15 <- logZ15[-which(logZ15[,2] == 'MCMC'),]
logZ15$Method <- c(rep(c('ASMC', 'DSMC', 'LIS', 'SS'), 118))

logZ20_1 <- data.frame(read.csv("MCMC20_1000/results1/logZout.csv"))
logZ20_2 <- data.frame(read.csv("MCMC20_1000/results2/logZout.csv"))
logZ20_3 <- data.frame(read.csv("MCMC20_1000/results3/logZout.csv"))
logZ20_4 <- data.frame(read.csv("MCMC20_1000/results4/logZout.csv"))
logZ20_5 <- data.frame(read.csv("MCMC20_1000/results5/logZout.csv"))
logZ20_6 <- data.frame(read.csv("MCMC20_1000/results6/logZout.csv"))
logZ20_7 <- data.frame(read.csv("MCMC20_1000/results7/logZout.csv"))
logZ20_8 <- data.frame(read.csv("MCMC20_1000/results8/logZout.csv"))
logZ20_9 <- data.frame(read.csv("MCMC20_1000/results9/logZout.csv"))
logZ20_10 <- data.frame(read.csv("MCMC20_1000/results10/logZout.csv"))
# logZ20_11 <- data.frame(read.csv("MCMC20_1000/results11/logZout.csv"))
# logZ20_12 <- data.frame(read.csv("MCMC20_1000/results12/logZout.csv"))
# logZ20_13 <- data.frame(read.csv("MCMC20_1000/results13/logZout.csv"))
# logZ20_14 <- data.frame(read.csv("MCMC20_1000/results14/logZout.csv"))
logZ20 <- rbind(logZ20_1, logZ20_2, logZ20_3, logZ20_4, logZ20_5, logZ20_6, logZ20_7, logZ20_8, logZ20_9, logZ20_10)
logZ20 <- logZ20[-which(logZ20[,2] == 'MCMC'),]
logZ20$Method <- rep(c('ASMC', 'DSMC', 'LIS', 'SS'), 100)

logZ25_1 <- data.frame(read.csv("MCMC25_1000/results1/logZout.csv"))
logZ25_2 <- data.frame(read.csv("MCMC25_1000/results2/logZout.csv"))
logZ25_3 <- data.frame(read.csv("MCMC25_1000/results3/logZout.csv"))
logZ25_4 <- data.frame(read.csv("MCMC25_1000/results4/logZout.csv"))
logZ25_5 <- data.frame(read.csv("MCMC25_1000/results5/logZout.csv"))
logZ25_6 <- data.frame(read.csv("MCMC25_1000/results6/logZout.csv"))
logZ25_7 <- data.frame(read.csv("MCMC25_1000/results7/logZout.csv"))
logZ25_8 <- data.frame(read.csv("MCMC25_1000/results8/logZout.csv"))
logZ25_9 <- data.frame(read.csv("MCMC25_1000/results9/logZout.csv"))
logZ25_10 <- data.frame(read.csv("MCMC25_1000/results10/logZout.csv"))
#logZ25_11 <- data.frame(read.csv("MCMC25_1000/results11/logZout.csv"))
#logZ25_12 <- data.frame(read.csv("MCMC25_1000/results12/logZout.csv"))
logZ25 <- rbind(logZ25_1, logZ25_2, logZ25_3, logZ25_4, logZ25_5, logZ25_6, logZ25_7, logZ25_8, logZ25_9, logZ25_10)
logZ25[which(logZ25[,2] == 'MCMC'),4] <- -1911
logZ25$Method <- rep(c('ASMC', 'DSMC', 'LIS', 'SS'), nrow(logZ25)/4)


p0 <- ggplot(logZ5, aes(Method, logZ))
p1 <- ggplot(logZ10, aes(Method, logZ))
p2 <- ggplot(logZ15, aes(Method, logZ))
p3 <- ggplot(logZ20, aes(Method, logZ))
p4 <- ggplot(logZ25, aes(Method, logZ))
#p5 <- ggplot(logZ30_1000, aes(Method, logZ))


gname = c("NormalizingConstantEstimates.eps",sep="")  
postscript(gname,width=10,height=3,horizontal = FALSE, onefile = FALSE, paper = "special")
par(mfrow=c(1,1),oma=c(0.2,1.5,0.2,1.5),mar=c(3,2,0.2,2),cex.axis=1,las=1,mgp=c(1,0.5,0),adj=0.5)

ggarrange(p0 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = Method))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('5'),
          p1 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = Method))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('10'),
          p2 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = Method))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('15'),
          p3 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = Method))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('20'),
          p4 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = Method))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('25'),
#         p5 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = Method))+rremove("x.text")+rremove("ylab")+ xlab('30')+ theme_bw()
          ncol = 5, nrow = 1, common.legend = TRUE)

dev.off()






