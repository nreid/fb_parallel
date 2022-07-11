#!/usr/bin/bash
#SBATCH --job-name=nextflow
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mem=1G
module load nextflow/22.04.0

# Place yourself in nextflow base directory
cd /home/FCAM/gbarrett/NF_PIPES/fb_parallel/fb_parallel

nextflow run main.nf -entry FB -with-singularity fb_parallel.sif

