#!/bin/bash -ue
pwd  
  mkdir state
  mkdir state/execs
export LD_LIBRARY_PATH=/cvmfs/soft.computecanada.ca/nix/var/nix/profiles/16.09/lib:/cvmfs/soft.computecanada.ca/nix/lib:/opt/software/lib:/opt/software/slurm/lib  
java   -cp 'code/lib/*' -Xmx8G   smcsampler.SMCSamplerExperiments -useDataGenerator true    -nThousandIters 0.001      -nTax 25       -len  100      -sequenceType DNA      -generateDNAdata true      -useDataGen4GTRGammaI false       -nThreads 1      -treeRate 10      -deltaProposalRate 10      -useNonclock true       -useSlightNonclock false      -iterScalings     50000      -methods      MCMC      -resamplingStrategy  ESS       -nAnnealing 5000       -alphaSMCSampler 0.99      -essRatioThreshold 0.5      -adaptiveTempDiff  true     -adaptiveType 0         -sdScale 0.3      -csmc_trans2tranv 2.0       -mb_trans2tranv 2.0      -fixtratioInMb true      -treePrior 'unconstrained:exp(10)'        -setToK2P  true       -set2nst  true       -fixNucleotideFreq true       -nReplica  1       -repPerDataPt  20       -mainRand 122       -gen.rand 94754      -nNumericalIntegration 1000000      -useCESS true        -useNNI true       -useLIS  true       -usenewSS true       -ntempSS  50          -mcmcfac  1          -usenewDSMC  false      -neighborPath  '/home/shijia57/bin/phylip-3.69/exe//neighbor' 
     unset  LD_LIBRARY_PATH
