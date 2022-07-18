#!/bin/bash
#SBATCH --job-name=nextflow
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mem=1G
module load nextflow/22.04.0

nextflow run main.nf -resume -entry FB -c configs/test.config -with-singularity fb_parallel.sif -profile slurm

