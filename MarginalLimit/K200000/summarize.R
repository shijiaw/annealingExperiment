library(ggplot2)
library(Rmisc) 
library(Sleuth2)
library(ggpubr)



logZ10 <- data.frame(read.csv("logZout.csv"))
logZ10 <- logZ10[-which(logZ10[,2] == 'MCMC'),]


p1 <- ggplot(logZ10, aes(Method, logZ))
#p2 <- ggplot(logZ15, aes(Method, logZ))
#p3 <- ggplot(logZ20, aes(Method, logZ))
#p4 <- ggplot(logZ20_1000, aes(Method, logZ))
#p5 <- ggplot(logZ25_500, aes(Method, logZ))

gname = c("logZlimiting.eps",sep="")  
postscript(gname,width=5,height=3,horizontal = FALSE, onefile = FALSE, paper = "special")
par(mfrow=c(1,1),oma=c(0.2,1.5,0.2,1.5),mar=c(3,2,0.2,2),cex.axis=1,las=1,mgp=c(1,0.5,0),adj=0.5)

p1 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = Method))+rremove("x.text")+rremove("ylab")+ theme_bw() +theme(axis.title.x=element_blank(),
                                                                                                                                                                            axis.text.x=element_blank(),
                                                                                                                                                                            axis.ticks.x=element_blank())


dev.off()






