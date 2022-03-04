# annotation-pipeline-nextflow

## Re-written in Nextflow

This is re-written to keep up to date with ToL policy on pipelines.

It is not optimal as of yet as this project is to learn how to use Nextflow DSL2.

## Running the pipeline

On tol-farm, activate conda:
`conda activate /software/treeoflife/miniconda3/envs/nf-core_dev`

This can also be downloaded from the official nf-core conda.

Then run the pipeline:
`nextflow run anno-pipe.nf`

This pipeline has been written to take advantage of docker containers available on DockerHub (to mimic internal pipelines).

## Local Install
Internal sanger:

- Download this (yaml)[https://gitlab.internal.sanger.ac.uk/tol-it/conda-environments/-/tree/main/environments]

- `conda env create -f {YAML}`

- `conda activate nf-core_dev`

