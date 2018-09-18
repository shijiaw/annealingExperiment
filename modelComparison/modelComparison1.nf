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
    val codeRevision from 'cbd2d0c21c5b55e0ef9b39723d4f42a7c620a5ef'
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
     each mainRand from  (1314)
     each rand from  (11,22,33,44,55,66,77,88,99,110,121)
     each particle from  (100)
     each alphaSMCSampler from 0.999
     each length from (100)
     each nTaxa from (10)
    echo true
        
  output:
    file '.' into execFolder
    
  """
  
  pwd
  
  mkdir state
  mkdir state/execs
  java -cp code/lib/\\* -Xmx4g evolmodel.ModelComparisonExperiments   \
     -nThousandIters 0.001 \
     -useDataGenerator true \
     -nTaxa $nTaxa  \
     -len  $length  \
     -generateDNAdata true \
     -sequenceType DNA \
     -useSeqGen false \
     -fixNucleotideFreq false \
     -set2nst false \
     -setToK2P false \
     -setGTRGammaI true \
     -useDataGen4GTRGammaI true       -nThreads 1 \
     -treeRate 10 \
     -deltaProposalRate 10 \
     -useNonclock false  \
     -useSlightNonclock false \
     -iterScalings  $particle   100000 $particle   100000 $particle   100000\
     -methods      ANNEALINGJC SSJC  ANNEALINGEvolK2P SSEvolK2P ANNEALINGEvolGTR SSEvolGTR \
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
                
  publishDir deliverableDir, mode: 'copy', overwrite: true
  
  afterScript 'rm -r metastore_db; rm derby.log'
  
  
  """
  #!/usr/bin/env Rscript 

  print("start R code ")
 # require("ggplot2")

  library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
  sparkR.session(master = "local[*]", sparkConfig = list(spark.driver.memory = "4g")) 
    
#  require("Sleuth2")
#  require("ggpubr")

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
  
  getwd()
  """
}






