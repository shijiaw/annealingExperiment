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
    val codeRevision from 'deb3d12a7bfb361a694e21a357cf39ab4c9dbd12'
    val snapshotPath from '/home/shijia57/source/rejfreeAnalysis'
  
  output:
    file 'code' into analysisCode

  script:
    template 'buildSnapshot.sh'
}


process buildCode {
cache true
  input:
    val gitRepoName from 'phylosmcsampler'
    val gitUser from 'liangliangwangsfu'
    val codeRevision from '3f955c3dd553b15ac2a9a103070f520e527ba856'
    val snapshotPath from '/home/shijia57/source/phylosmcsampler'
  
  output:
    file 'code' into code

  script:
    template 'buildSnapshot.sh' 
}



process run {

module 'java/1.8.0_121'  
echo true
  time '48h'
  memory '4 GB'
  cpus 4
  executor 'slurm'
  clusterOptions  '--account=def-liang-ab'

  input:
    file code
    
    each mainRand from  122
    each rand from  13199
    each alphaSMCSampler from 0.99
    echo true
        
  output:
    file '.' into execFolder
    
  """
  pwd  
  mkdir state
  mkdir state/execs
export LD_LIBRARY_PATH=$NIXUSER_PROFILE/lib:$LD_LIBRARY_PATH  
java   -cp 'code/lib/*' -Xmx4G   smcsampler.SMCSamplerExperiments -useDataGenerator true    -nThousandIters 0.001 \
     -nTax 30  \
     -len  1500 \
     -sequenceType DNA \
     -generateDNAdata true \
     -useDataGen4GTRGammaI false       -nThreads 4 \
     -treeRate 10 \
     -deltaProposalRate 10 \
     -useNonclock true  \
     -useSlightNonclock false \
     -iterScalings    100  \
     -methods    ANNEALING  \
     -resamplingStrategy  ESS  \
     -nAnnealing 50000  \
     -alphaSMCSampler $alphaSMCSampler \
     -essRatioThreshold 0.5 \
     -adaptiveTempDiff  true\
     -adaptiveType 0    \
     -sdScale 0.3 \
     -csmc_trans2tranv 2.0  \
     -mb_trans2tranv 2.0 \
     -fixtratioInMb true \
     -treePrior 'unconstrained:exp(10)'   \
     -setToK2P  true  \
     -set2nst  true  \
     -fixNucleotideFreq true  \
     -nReplica  1  \
     -repPerDataPt  100  \
     -mainRand $mainRand  \
     -gen.rand $rand \
     -nNumericalIntegration 1000000 \
     -useCESS true   \
     -useNNI true  \
     -useLIS  true  \
     -usenewSS true  \
     -ntempSS  50     \
     -mcmcfac  1     \
     -usenewDSMC  false \
     -neighborPath  '/home/shijia57/bin/phylip-3.69/exe//neighbor' 
     unset  LD_LIBRARY_PATH    
  """
}

process aggregate {

  input:
    file analysisCode
    file 'exec_*' from execFolder.toList()
    
  output:
    file aggregated    
    file aggregated2

  
  """
 ./code/bin/csv-aggregate \
    --experimentConfigs.managedExecutionFolder false \
    --experimentConfigs.saveStandardStreams false \
    --experimentConfigs.recordExecutionInfo false \
    --argumentFileName state/execs/0.exec/options.map \
    --argumentsKeys    SMCSamplerExperiments.mainRand SMCSamplerExperiments.alphaSMCSampler gen.rand\
    --dataPathInEachExecFolder state/execs/0.exec/results/logZout.csv \
    --outputFolderName aggregated
    ./code/bin/csv-aggregate \
    --experimentConfigs.managedExecutionFolder false \
    --experimentConfigs.saveStandardStreams false \
    --experimentConfigs.recordExecutionInfo false \
    --argumentFileName state/execs/0.exec/options.map \
    --argumentsKeys    SMCSamplerExperiments.mainRand SMCSamplerExperiments.alphaSMCSampler gen.rand\
    --dataPathInEachExecFolder state/execs/0.exec/results/results.csv\
    --outputFolderName aggregated2
  """

}



process createPlot {

  echo true
  module 'r/3.4.0'
  input:
    file aggregated
    file aggregated2
    env SPARK_HOME from "${System.getProperty('user.home')}/bin/spark-2.1.0-bin-hadoop2.7"
        
   output:
 
    file 'logZ1.eps'
    file 'treeDistance.eps'


    
  publishDir deliverableDir, mode: 'copy', overwrite: true
  
  afterScript 'rm -r metastore_db; rm derby.log'
    
  """
  #!/usr/bin/env Rscript
  require("ggplot2")

  library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
  sparkR.session(master = "local[*]", sparkConfig = list(spark.driver.memory = "4g")) 
   
  data <- read.df("$aggregated", "csv", header="true", inferSchema="true")
  head(data)
  data <- collect(data)
  nR <- nrow(data)
  nrow <- which(data[,2] == 'MCMC')
  data2 <- data[-nrow,]


  gname = c("logZ1.eps",sep="")  
  postscript(gname,width=7,height=4,horizontal = FALSE, onefile = FALSE, paper = "special")
  par(mfrow=c(1,1),oma=c(0.2,1.5,0.2,1.5),mar=c(3,2,0.2,2),cex.axis=1,las=1,mgp=c(1,0.5,0),adj=0.5)

  p <- ggplot(data2, aes(Method, logZ))
  p + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1) + geom_boxplot(aes(color = logZ))+ theme(legend.title=element_blank())+theme_bw()
  dev.off()
  
  require("Sleuth2")
  require("ggpubr")
  results <- read.df("$aggregated2", "csv", header="true", inferSchema="true")
  results <- collect(results)
  head(results)
  head(results[-which(results[,c("Metric")] == 'BestSampledLogLL'),])
  results2 <- data.frame(results[-which(results[,c("Metric")] == 'BestSampledLogLL'),])
  results2[,2] <- paste(results2[,1], results2[,2])
  head(results2)
  
  p <- ggplot(results2[which(results2[,7] == 'ConsensusLogLL'),], aes(Adaptive, Value))

  p2 <- ggplot(results2[which(results2[,7] == 'PartitionMetric'),], aes(Adaptive, Value))

  p3 <- ggplot(results2[which(results2[,7] == 'RobinsonFouldsMetric'),], aes(Adaptive, Value))

  p4 <- ggplot(results2[which(results2[,7] == 'KuhnerFelsenstein'),], aes(Adaptive, Value))

  gname = c("treeDistance.eps",sep="")  
  postscript(gname,width=8,height=4,horizontal = FALSE, onefile = FALSE, paper = "special")
  #par(mfrow=c(1,1),oma=c(0.2,1.5,0.2,1.5),mar=c(3,2,0.2,2),cex.axis=1,las=1,mgp=c(1,0.5,0),adj=0.5)

  ggarrange(p + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1)+rremove("x.text")+rremove("ylab")+rremove("legend")+ geom_boxplot(aes(color = Adaptive))+ xlab('ConsensusLogLL')
          ,p2 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1)+rremove("x.text")+rremove("ylab") + geom_boxplot(aes(color = Adaptive))+ xlab('PartitionMetric')
          ,p3 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1)+rremove("x.text")+rremove("ylab") + geom_boxplot(aes(color = Adaptive))+ xlab('RobinsonFouldsMetric')
          ,p4 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1)+rremove("x.text")+rremove("ylab") + geom_boxplot(aes(color = Adaptive))+ xlab('KuhnerFelsenstein')
          ,ncol = 4, nrow = 1, common.legend = TRUE)

  dev.off()
  getwd()

  """
}


