#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=20:00:00
#SBATCH --partition=blanca-shirts
#SBATCH --qos=blanca-shirts
#SBATCH --account=blanca-shirts
#SBATCH --gres=gpu
#SBATCH --job-name=tip3p_hmix_dens
#SBATCH --output=slurm_codes/hmix_dens.log

module purge
module avail
ml anaconda
conda activate evaluator-blanca

python hmix_dens_calc.py
echo "It finished"

sacct --format=jobid,jobname,cputime,elapsed