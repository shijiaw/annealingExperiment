logZ1 <- read.csv('results1/logZout.csv')
logZ2 <- read.csv('results2/logZout.csv')
logZ <- rbind(logZ1, logZ2)
write.csv(logZ, file = 'logZout.csv', row.names = FALSE)

results1 <- read.csv('results1/results.csv')
results2 <- read.csv('results2/results.csv')
results <- rbind(results1, results2)
write.csv(results, file = 'results.csv', row.names = FALSE)