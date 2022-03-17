params.outdir = "$baseDir/results"

process bwa_mem_samtools {
    tag "BWA MEM ALIGN"
    publishDir "${params.outdir}/bwa_aligned", mode: 'copy'

    input:
    path(ref)
    tuple path(1paired), path(2paired)

    output:
    path "aligned.sam", emit: alignment

    script:
    """
    mkdir bwa_aligned
    bwa mem -t 4 -R'@RG\\tID:1\\tLB:library\\tPL:Illumina\\tPU:lane1\\tSM:human' \
$PWD/data/ref.fna \
$PWD/TRIM_COV020619_R/TRIM_COV020619_R/${paired_out_1} \
$PWD/TRIM_COV020619_R/TRIM_COV020619_R/${paired_out_2} \
> aligned.sam
    """
}