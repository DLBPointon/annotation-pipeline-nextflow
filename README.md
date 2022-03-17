# annotation-pipeline-nextflow

## Re-written in Nextflow

This is re-written to keep up to date with ToL policy on pipelines.

It is not optimal as of yet as this project is to learn how to use Nextflow DSL2.

NOTES:
Currently bwa_mem.nf (bam_mem_samtools) and fastqc_2 do not work

## Running the pipeline
Original Data set was too heavy for testing. So I am now using some covid data:

Reads: https://trace.ncbi.nlm.nih.gov/Traces/sra/?run=ERR6295823
Ref: is small enough it has been uploaded in data/ref.fna


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

