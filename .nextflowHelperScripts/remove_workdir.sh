#!/usr/bin/sh
#SBATCH --job-name=remove_workdir
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mem=1G
#SBATCH --out=remWorkDir.out

cd /home/FCAM/gbarrett/NF_PIPES/fb_parallel/work

rm -fRv *