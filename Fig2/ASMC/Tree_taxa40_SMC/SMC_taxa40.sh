#!/bin/bash 
#SBATCH -t 2-00:15
#SBATCH --account=def-liang-ab
#SBATCH --mem-per-cpu=16G      # memory; default unit is megabytes
#SBATCH --cpus-per-task=2



#echo "Using R:"
module load r/3.4.0

module load java/1.8.0_121

#echo "Starting  nextflow at `date`."
nextflow run  SMC_taxa40.nf -resume
#echo "Finished nextflow  at `date`."

