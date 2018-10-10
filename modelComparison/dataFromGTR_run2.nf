#!/usr/bin/env nextflow

deliverableDir = 'deliverables/' + workflow.scriptName.replace('.nf','')
// stuff to do

process summarizePipeline {

  cache false
  
  output:
      file 'pipeline-info.txt'
      
  publishDir deliverableDir, mode: 'copy', overwrite: true
  
  """
  echo 'scriptName: $workflow.scriptName' >> pipeline-info.txt
  echo 'start: $workflow.start' >> pipeline-info.txt
  echo 'runName: $workflow.runName' >> pipeline-info.txt
  echo 'nextflow.version: $workflow.nextflow.version' >> pipeline-info.txt
  """

}




process analysisCode {

  cache true
  
  input:
    val gitRepoName from 'rejfreeAnalysis'
    val gitUser from 'alexandrebouchard'
    val codeRevision from '573413bcecb3018e3372b1009b739806cd7e4c7a'
    val snapshotPath from '/Users/bouchard/w/rejfreeAnalysis'
  
  output:
    file 'code' into analysisCode

  script:
    template 'buildRepo.sh'
}


process buildCode {

  cache true
  
  input:
    val gitRepoName from 'phylosmcsampler'
    val gitUser from 'liangliangwangsfu'
    val codeRevision from '73c4d4bf0daf0ca83b1d9c3c286a5fbcee1c51f3'
    val snapshotPath from '/Users/liangliangwang/eclipse-workspace/phylosmcsampler'
  
  output:
    file 'code' into code

  script:
   template 'buildRepo.sh'
}


process run {

  echo true

  input:
    file code   
     each mainRand from  (11,22,33,44,55,66,77,88,99,100)
     each rand from  13199
     each particle from  (1000)
     each alphaSMCSampler from 0.99999
     each length from (100)
     each nTaxa from (10)
    echo true
        
  output:
    file '.' into execFolder
    
  """
  
  pwd
  
  mkdir state
  mkdir state/execs
  java -cp code/lib/\\* -Xmx6g evolmodel.ModelComparisonExperiments   \
     -nThousandIters 0.001 \
     -useDataGenerator true \
     -nTaxa $nTaxa  \
     -len  $length  \
     -generateDNAdata true \
     -sequenceType DNA \
     -useSeqGen false \
     -useDataGen4GTRGammaI true       -nThreads 1 \
     -treeRate 10 \
     -deltaProposalRate 10 \
     -useNonclock true  \
     -useSlightNonclock false \
     -iterScalings  $particle  100000  $particle   100000 $particle   100000\
     -methods       ANNEALINGEvolK2P SSEvolK2P ANNEALINGJC SSJC  ANNEALINGEvolGTR SSEvolGTR \
     -resamplingStrategy  ESS  \
     -nAnnealing 50000  \
     -alphaSMCSampler $alphaSMCSampler \
     -essRatioThreshold 0.5 \
     -adaptiveTempDiff  true\
     -adaptiveType 0    \
     -treePrior 'unconstrained:exp(10)'   \
     -fixNucleotideFreq true  \
     -nReplica  1  \
     -repPerDataPt  1  \
     -mainRand $mainRand  \
     -gen.rand $rand \
     -useCESS true   \
     -useNNI true  \
     -usenewSS true  \
     -ntempSS  50     \
     -mcmcfac  1     \
     -stationaryDistributionDirichletParameters 10 10 10 10     \
     -subsRatesDirichletParameters 10 10 10 10 10 10    
  """
}




process aggregate {

  input:
    file analysisCode
    file 'exec_*' from execFolder.toList()
    
  output:
    file aggregated    
    file aggregated2
    file aggregated3
  """
 ./code/bin/csv-aggregate \
    --experimentConfigs.managedExecutionFolder false \
    --experimentConfigs.saveStandardStreams false \
    --experimentConfigs.recordExecutionInfo false \
    --argumentFileName state/execs/0.exec/options.map \
    --argumentsKeys    ModelComparisonExperiments.mainRand ModelComparisonExperiments.alphaSMCSampler gen.len gen.nTaxa gen.rand gen.treeRate ModelComparisonExperiments.iterScalings \
    --dataPathInEachExecFolder state/execs/0.exec/results/logZout.csv \
    --outputFolderName aggregated
    ./code/bin/csv-aggregate \
    --experimentConfigs.managedExecutionFolder false \
    --experimentConfigs.saveStandardStreams false \
    --experimentConfigs.recordExecutionInfo false \
    --argumentFileName state/execs/0.exec/options.map \
    --argumentsKeys    ModelComparisonExperiments.mainRand ModelComparisonExperiments.alphaSMCSampler gen.len  gen.nTaxa  gen.rand gen.treeRate ModelComparisonExperiments.iterScalings \
    --dataPathInEachExecFolder state/execs/0.exec/results/results.csv\
    --outputFolderName aggregated2
    ./code/bin/csv-aggregate \
    --experimentConfigs.managedExecutionFolder false \
    --experimentConfigs.saveStandardStreams false \
    --experimentConfigs.recordExecutionInfo false \
    --argumentFileName state/execs/0.exec/options.map \
    --argumentsKeys    ModelComparisonExperiments.mainRand ModelComparisonExperiments.alphaSMCSampler gen.len  gen.nTaxa  gen.rand gen.treeRate ModelComparisonExperiments.iterScalings \
    --dataPathInEachExecFolder state/execs/0.exec/results/gtrGammaParameters.csv\
    --outputFolderName aggregated3
  """
}



process createPlot {

  echo true

  input:    
    file aggregated
    file aggregated2
    file aggregated3
    env SPARK_HOME from "${System.getProperty('user.home')}/bin/spark-2.1.0-bin-hadoop2.7"
        
   output:

    file 'aggregatedLogZout.csv'
    file 'aggregatedGTRGammaParameters.csv'
    file 'aggregatedResults.csv'
    file 'modelSelectionSummary.csv'
    file 'NormalizingConstantEstimates.eps'
                
  publishDir deliverableDir, mode: 'copy', overwrite: true
  
  afterScript 'rm -r metastore_db; rm derby.log'
  
  
  """
  #!/usr/bin/env Rscript 

  print("start R code ")
  require("ggplot2")

  library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
  sparkR.session(master = "local[*]", sparkConfig = list(spark.driver.memory = "4g")) 
    
  require("Sleuth2")
  require("ggpubr")

  results <- read.df("$aggregated", "csv", header="true", inferSchema="true")
  results <- collect(results) 
  head(results)
  write.csv(results, "aggregatedLogZout.csv")
  
  results <- read.df("$aggregated3", "csv", header="true", inferSchema="true")
  results <- collect(results) 
  head(results)
  write.csv(results, "aggregatedGTRGammaParameters.csv")

  results <- read.df("$aggregated2", "csv", header="true", inferSchema="true")
  results <- collect(results) 
  head(results)
  write.csv(results, "aggregatedResults.csv")
  
  logZoutRe <- read.csv("aggregatedLogZout.csv")
  head(logZoutRe)
  ncol(logZoutRe)
  annealMethods <- c("ANNEALINGJC","ANNEALINGEvolK2P","ANNEALINGEvolGTR")
  ssMethods <- c("SSJC","SSEvolK2P","SSEvolGTR")
  uniqueTrees <- unique(logZoutRe[,"X.treeName"])
  modelSelectionSummary <- matrix(0,length(uniqueTrees),3)
  colnames(modelSelectionSummary) <- c("treeName","modelByASMC","modelBySS")
 k <- 1
 for(i in uniqueTrees)
 {
  subData <- logZoutRe[logZoutRe[,"X.treeName"]==i,]
  if(length(unique(subData[,"Method"]))==6){  
    logZAnnealledMethod <- subData[which(subData[,"Method"] %in% annealMethods),c("Method","logZ")]
    logZSSMethod <- subData[which(subData[,"Method"] %in% ssMethods),c("Method","logZ")]
    annealedRe <- unlist(by(logZAnnealledMethod[,"logZ"], logZAnnealledMethod[,"Method"], mean, simplify=FALSE))
    ssRe <- unlist(by(logZSSMethod[,"logZ"], logZSSMethod[,"Method"], mean, simplify=FALSE))
    modelSelectionSummary[k,] <- c(i, names(annealedRe)[which(annealedRe==max(unlist(annealedRe)))], names(ssRe)[which(ssRe==max(unlist(ssRe)))])
    k <- k+1
  }
 }
  write.csv(modelSelectionSummary, "modelSelectionSummary.csv")
  logZoutReJC = logZoutRe[logZoutRe[,"Method"]=="ANNEALINGJC" | logZoutRe[,"Method"]=="SSJC",]
   Method2 = rep("",nrow(logZoutReJC))
   Method2[which(logZoutReJC[,"Method"]=="ANNEALINGJC")] = "ASMC"
   Method2[which(logZoutReJC[,"Method"]=="SSJC")] = "SS"
   logZoutReJC = cbind(logZoutReJC[, -which(names(logZoutReJC)=="Method")],Method=Method2)
   logZoutReK2P = logZoutRe[logZoutRe[,"Method"]=="ANNEALINGEvolK2P" | logZoutRe[,"Method"]=="SSEvolK2P",]
   Method2 = rep("",nrow(logZoutReK2P))
   Method2[which(logZoutReK2P[,"Method"]=="ANNEALINGEvolK2P")] = "ASMC"
   Method2[which(logZoutReK2P[,"Method"]=="SSEvolK2P")] = "SS"
   logZoutReK2P = cbind(logZoutReK2P[, -which(names(logZoutReK2P)=="Method")],Method=Method2)
   logZoutReGTR = logZoutRe[logZoutRe[,"Method"]=="ANNEALINGEvolGTR" | logZoutRe[,"Method"]=="SSEvolGTR",]
   Method2 = rep("",nrow(logZoutReGTR))
   Method2[which(logZoutReGTR[,"Method"]=="ANNEALINGEvolGTR")] = "ASMC"
   Method2[which(logZoutReGTR[,"Method"]=="SSEvolGTR")] = "SS"
  logZoutReGTR = cbind(logZoutReGTR[, -which(names(logZoutReGTR)=="Method")],Method=Method2)
    
  ylimt <- range(logZoutRe[,"logZ"])      
  p0 <- ggplot(logZoutReJC, aes(Method, logZ))
  p1 <- ggplot(logZoutReK2P, aes(Method, logZ))
  p2 <- ggplot(logZoutReGTR, aes(Method, logZ))

  gname = c("NormalizingConstantEstimates.eps",sep="")  
  postscript(gname,width=10,height=3,horizontal = FALSE, onefile = FALSE, paper = "special")
  par(mfrow=c(1,1),oma=c(0.2,1.5,0.2,1.5),mar=c(3,2,0.2,2),cex.axis=1,las=1,mgp=c(1,0.5,0),adj=0.5)

  ggarrange(p0 + ylim(ylimt) + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = Method))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('JC'),
       p1 + ylim(ylimt) + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = Method))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('K2P'),
       p2 + ylim(ylimt) + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = Method))+ theme_bw()+rremove("x.text")+rremove("ylab")+ xlab('GTR'),
       ncol = 3, nrow = 1, common.legend = TRUE)

  dev.off()
  getwd()
  """
}






