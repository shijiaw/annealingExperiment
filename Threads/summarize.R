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



results1 <- data.frame(read.csv("SMC30_1000_1/results/results.csv"))
results1$Threads = 1
results2 <- data.frame(read.csv("SMC30_1000_2/results/results.csv"))
results2$Threads = 2
results3 <- data.frame(read.csv("SMC30_1000_3/results/results.csv"))
results3$Threads = 3
results4 <- data.frame(read.csv("SMC30_1000_4/results/results.csv"))
results4$Threads = 4
results = rbind(results1, results2, results3, results4)
results$Threads = as.factor(results$Threads)
Adaptive_results <- results[which(results$Adaptive == 'true'),]

summary <- summarySE(Adaptive_results, measurevar="Time", groupvars=c("Threads"))

gname = c("Threads.eps",sep="")  
postscript(gname,width=5,height=3,horizontal = FALSE, onefile = FALSE, paper = "special")
ggplot(summary, aes(x=Threads, y=Time)) + 
  geom_errorbar(aes(ymin=Time-ci, ymax=Time+ci), 
                colour="black", width=.1) +
  geom_line( aes(x=as.numeric(Threads), y=Time)) + 
  geom_point(size=1)+ ylab('Time (millisecond)')+ xlab('#Threads')+ theme_bw()+ylim(0,max(results$Time))
dev.off()


# gname = c("Threads.eps",sep="")  
# postscript(gname,width=6,height=4,horizontal = FALSE, onefile = FALSE, paper = "special")
# p <- ggplot(results, aes(Threads,  Time))
# ggarrange(p + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1)+rremove("legend")+ geom_boxplot(aes(color = Threads))+ylim(0,max(results$Time))+ xlab('#Threads')+ ylab('Time (millisecond)')
#           ,
#           ncol = 1, nrow = 1, common.legend = TRUE)
# dev.off()

#+rremove("legend")+rremove("x.text")+rremove("y.text")
