# annotation-pipeline-nextflow

## Re-written in Nextflow

This is based off of a prior pipeline written in Snakemake found [here](https://github.com/DLBPointon/annotation-pipeline-snakemake)

NOTES:
This does not currently use nf_core modules.

So far 8 of 17 modules are implemented and working.

## Running the pipeline

Original Data set was too heavy for testing. So I am now using some covid data:

Reads: https://trace.ncbi.nlm.nih.gov/Traces/sra/?run=ERR6295823
Ref: is small enough it has been uploaded in data/ref.fna

On tol-farm, activate conda:
`conda activate /software/treeoflife/miniconda3/envs/nf-core_dev`

This can also be downloaded from the official nf-core conda.

Then run the pipeline:
`nextflow run main.nf -entry snp_pipeline -ansi-log true`

This pipeline has been written to take advantage of docker containers available on DockerHub (to mimic internal pipelines).

## Local Install

Internal sanger:

- Download this [yaml](https://gitlab.internal.sanger.ac.uk/tol-it/conda-environments/-/tree/main/environments)

- `conda env create -f {YAML}`

- `conda activate nf-core_dev`
