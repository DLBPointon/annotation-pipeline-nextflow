# annotation-pipeline-nextflow

## Re-written in Nextflow

This is based off of a prior pipeline written in Snakemake found [here](https://github.com/DLBPointon/annotation-pipeline-snakemake)

NOTES:
This does not currently use nf_core modules.

So far 11 of 17 modules are implemented and working.

## Running the pipeline

### Running Locally

<details>

1 - Java
    If running locally make sure your JAVA_HOME env is set correctly. Sanger laptops use OpenJDK so need to use this:

    `export JAVA_HOME=$(/usr/libexec/java_home)`

    In order to use gatk and snpeff.

2 - libgfortran.3.dylib
    This error:
    `dyld: Library not loaded: @rpath/libquadmath.0.dylib`

    In my case this just wasn't installed properly which caused issues with running bcftools.

    To get this running, I had to delete the version here:
    `/Users/{USER}/miniconda3/envs/nf-core_dev/lib/libgfortran.5.dylib`

    Reinstall via brew:
    `brew install gcc`

    Symlink the new to the old:
    `ln /Usr/local/Cellar/gcc/11.2.0_3/lib/gcc/11/libgfortran.5.dylib /Users/{USER}/miniconda3/envs/nf-core_dev/lib/libgfortran.5.dylib`

</details>

Original Data for the snakemake version set was too heavy for testing. So I am now using some *E. coli* rel 606 data:

---

### Ref Genome

`curl -L -o ref.fna.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/017/985/GCA_000017985.1_ASM1798v1/GCA_000017985.1_ASM1798v1_genomic.fna.gz`

`gunzip ref.fna.gz`

---

### Reads

`curl -L -o sub.tar.gz https://ndownloader.figshare.com/files/14418248`

`tar xvf sub.tar.gz`

`mv sub/ ~/`

---

### Genome file

The method to use: <https://pcingola.github.io/SnpEff/se_buildingdb/#option-1-building-a-database-from-gtf-files>

We need to produce a .genome file for this organism before running the pipeline.
So first we need the gff file from the ncbi server,  because of SnpEff this will also need to be added to the config file for SnpEff:
This config file:
`/Users/{USER}/miniconda3/pkgs/snpeff-5.1-hdfd78af_1/share/snpeff-5.1-1/snpEff.config`

Add to the bottom of the file:

```markdown
# Escherichia coli Rel 606
ecoli_rel_606.genome : ecoli_rel_606
```

Save and quit

`curl -L -o ecoli_rel606.gff.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/017/985/GCA_000017985.1_ASM1798v1/GCA_000017985.1_ASM1798v1_genomic.gff.gz`

Download the gff date and a copy of the ref here:
`/Users/dp24/miniconda3/envs/nf-core_dev/share/snpeff-5.1-1/data/{ORG}/genes.gff`
These should be unzipped and named genes.gff and sequences.fa respectively.

Now in your wd run:
`snpeff build -gff3 -v ecoli_rel_606 -noCheckCds -noCheckProtein`

---

On tol-farm, activate conda:
`conda activate /software/treeoflife/miniconda3/envs/nf-core_dev`

This can also be downloaded from the official nf-core conda.

Then run the pipeline:
`nextflow run main.nf -entry snp_pipeline -ansi-log true`

This pipeline has been written to take advantage of docker containers available on DockerHub (to mimic internal pipelines).

---

## Local Install

TODO: add the actual yaml to the repo

Internal sanger:

- Download this [yaml](https://gitlab.internal.sanger.ac.uk/tol-it/conda-environments/-/tree/main/environments)

- `conda env create -f {YAML}`

- `conda activate nf-core_dev`
