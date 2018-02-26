#!/bin/bash 
#SBATCH -t 2-00:15
#SBATCH --account=def-liang-ab
#SBATCH --mem-per-cpu=8G      # memory; default unit is megabytes




#echo "Using R:"
module load r/3.4.0

module load java/1.8.0_121

#echo "Starting  nextflow at `date`."
nextflow run  SMC30_1000_9999.nf -resume
#echo "Finished nextflow  at `date`."

