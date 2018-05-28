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
    val codeRevision from 'b1613eb5d5433552b8b24ba44d7f6386443889af'
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
     each mainRand from  (111,  333)
     each rand from  (1001, 5001)
     each particle from  100
     each alphaSMCSampler from 0.99999
    echo true
        
  output:
    file '.' into execFolder
    
  """
  
  pwd
  
  mkdir state
  mkdir state/execs
  java -cp code/lib/\\* -Xmx4g smcsampler.SMCSamplerExperiments   \
     -nThousandIters 0.001 \
     -useDataGenerator true \
     -nTax   10  \
     -len  1000  \
     -generateDNAdata true \
     -sequenceType DNA \
     -useDataGen4GTRGammaI false       -nThreads 4 \
     -treeRate 10 \
     -deltaProposalRate 10 \
     -useNonclock true  \
     -useSlightNonclock true \
     -iterScalings  $particle    1000000 \
     -methods      ANNEALING CSMCNonClock    \
     -resamplingStrategy  ESS  \
     -nAnnealing 50000  \
     -alphaSMCSampler $alphaSMCSampler \
     -essRatioThreshold 0.5 \
     -adaptiveTempDiff  true\
     -adaptiveType 0    \
     -csmc_trans2tranv 1.0  \
     -setJC true \
     -fixtratioInMb true \
     -treePrior 'unconstrained:exp(10)'   \
     -fixNucleotideFreq true  \
     -nReplica  1  \
     -repPerDataPt  1  \
     -mainRand $mainRand  \
     -gen.rand $rand \
     -gen.useJC true \
     -nNumericalIntegration 1000000 \
     -useCESS true   \
     -useNNI true  \
     -useLIS  false  \
     -usenewSS true  \
     -ntempSS  50     \
     -mcmcfac  1      
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
    --argumentsKeys    SMCSamplerExperiments.mainRand SMCSamplerExperiments.alphaSMCSampler gen.rand gen.treeRate SMCSamplerExperiments.iterScalings gen.useNonclock\
    --dataPathInEachExecFolder state/execs/0.exec/results/logZout.csv \
    --outputFolderName aggregated
    ./code/bin/csv-aggregate \
    --experimentConfigs.managedExecutionFolder false \
    --experimentConfigs.saveStandardStreams false \
    --experimentConfigs.recordExecutionInfo false \
    --argumentFileName state/execs/0.exec/options.map \
    --argumentsKeys    SMCSamplerExperiments.mainRand SMCSamplerExperiments.alphaSMCSampler gen.rand gen.treeRate SMCSamplerExperiments.iterScalings gen.useNonclock\
    --dataPathInEachExecFolder state/execs/0.exec/results/results.csv\
    --outputFolderName aggregated2
  """
}






process createPlot {

  echo true

  input:    
    file aggregated
    file aggregated2
    env SPARK_HOME from "${System.getProperty('user.home')}/bin/spark-2.1.0-bin-hadoop2.7"
        
   output:

    file 'treeDistance.eps'
        
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
  results <- read.df("$aggregated2", "csv", header="true", inferSchema="true")
  results <- collect(results)
  head(results)
  #head(results[-which(results[,c("Metric")] == 'BestSampledLogLL'),])
  results <- data.frame(results[-which(results[,c("Metric")] == 'BestSampledLogLL'),])
  results[,2] <- paste(results[,1], results[,2])
  results2 <- results
  postscript("treeDistance.eps",width=10,height=4,horizontal = FALSE, onefile = FALSE, paper = "special")

  p <- ggplot(results2[which(results2[,'Metric'] == 'ConsensusLogLL'),], aes(Adaptive, Value))

  p2 <- ggplot(results2[which(results2[,'Metric'] == 'PartitionMetric'),], aes(Adaptive, Value))

  p3 <- ggplot(results2[which(results2[,'Metric'] == 'RobinsonFouldsMetric'),], aes(Adaptive, Value))

  p4 <- ggplot(results2[which(results2[,'Metric'] == 'KuhnerFelsenstein'),], aes(Adaptive, Value))
  
  p5 <- ggplot(results2, aes(Adaptive, Time))
  
  ggarrange(p + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1)+rremove("x.text")+rremove("ylab")+rremove("legend")+ geom_boxplot(aes(color = Adaptive))+ xlab('ConsensusLogLL')
          ,p2 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1)+rremove("x.text")+rremove("ylab") + geom_boxplot(aes(color = Adaptive))+ xlab('PartitionMetric')
          ,p3 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1)+rremove("x.text")+rremove("ylab") + geom_boxplot(aes(color = Adaptive))+ xlab('RobinsonFouldsMetric')
          ,p4 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1)+rremove("x.text")+rremove("ylab") + geom_boxplot(aes(color = Adaptive))+ xlab('KuhnerFelsenstein')
          ,p5 + geom_boxplot(fill = "white", colour = "#3366FF", outlier.colour = "red", outlier.shape = 1)+rremove("x.text")+rremove("ylab") + geom_boxplot(aes(color = Adaptive))+ xlab('Time')
          ,ncol = 5, nrow = 1, common.legend = TRUE)
  dev.off()  
  
  getwd()
  """
}






