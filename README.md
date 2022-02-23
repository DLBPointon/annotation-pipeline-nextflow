# annotation-pipeline-nextflow

## Re-written in Nextflow

This is re-written to keep up to date with ToL policy on pipelines.

## Running the pipeline

On tol-farm, activate conda:
`conda activate /software/treeoflife/miniconda3/envs/nf-core_dev`

Then run the pipeline:
`nextflow run anno-pipe.nf`

This pipeline has been written to take advantage of docker containers available on DockerHub (to mimic internal pipelines).
