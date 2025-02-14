#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=150:00:00
#SBATCH --partition=blanca-shirts
#SBATCH --qos=blanca-shirts
#SBATCH --account=blanca-shirts
#SBATCH --gres=gpu
#SBATCH --job-name=sfe_tip3p_np_4
#SBATCH --output=slurm_codes/sfe_tip3p_np_4.log

module purge
module avail
ml anaconda
conda activate old-evaluator-test7

function convert_ff_to_v3 () {
    FF="/projects/bamo6610/software/anaconda/env/old-evaluator-test7/lib/python3.9/site-packages/openforcefields/offxml/$1"
    cp /projects/bamo6610/software/anaconda/env/old-evaluator-test7/lib/python3.9/site-packages/openforcefields/offxml/$1 $FF
    sed -i 's/    <vdW version="0.4" potential="Lennard-Jones-12-6" combining_rules="Lorentz-Berthelot" scale12="0.0" scale13="0.0" scale14="0.5" scale15="1.0" cutoff="9.0 \* angstrom \*\* 1" switch_width="1.0 \* angstrom \*\* 1" periodic_method="cutoff" nonperiodic_method="no-cutoff">/    <vdW version="0.3" potential="Lennard-Jones-12-6" combining_rules="Lorentz-Berthelot" scale12="0.0" scale13="0.0" scale14="0.5" scale15="1.0" cutoff="9.0 \* angstrom" switch_width="1.0 \* angstrom" method="cutoff">/g' $FF
    sed -i 's/    <Electrostatics version="0.4" scale12="0.0" scale13="0.0" scale14="0.8333333333" scale15="1.0" cutoff="9.0 \* angstrom \*\* 1" switch_width="0.0 \* angstrom \*\* 1" periodic_potential="Ewald3D-ConductingBoundary" nonperiodic_potential="Coulomb" exception_potential="Coulomb">/    <Electrostatics version="0.3" scale12="0.0" scale13="0.0" scale14="0.8333333333" scale15="1.0" cutoff="9.0 \* angstrom" switch_width="0.0 \* angstrom" method="PME">/g' $FF
    echo "converted $FF"
}

OFF="openff-2.1.0.offxml"
WATERFF="tip3p.offxml"

convert_ff_to_v3 "$OFF"
convert_ff_to_v3 "$WATERFF"

export OFF
export WATERFF

python sfe_npsamples.py
echo "It finished"

sacct --format=jobid,jobname,cputime,elapsed