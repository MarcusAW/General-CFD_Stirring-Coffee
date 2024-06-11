#!/bin/bash
#SBATCH --job-name=stirring
#SBATCH --time=96:00:00
#SBATCH --ntasks=100
#SBATCH --nodes=3
#SBATCH --mem-per-cpu=1G

module load OpenFOAM/v2206-foss-2022a
. ${FOAM_BASH}

rm -r constant/polyMesh
rm -r 0*
rm -r processor*
rm -r postProcessing
blockMesh
surfaceFeatureExtract
decomposePar
mpirun --mca btl ^openib -np 100 snappyHexMesh -parallel -overwrite
reconstructParMesh -constant
renumberMesh -overwrite
rm -r processor*
createPatch -overwrite
cp -r C0.orig 0
setFields
decomposePar
mpirun --mca btl ^openib -np 100 interMixingFoam -parallel 


