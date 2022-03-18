params.outdir = "$baseDir/results"

process bwa_mem {
    tag "BWA MEM ALIGN"
    publishDir "${params.outdir}/bwa_aligned/", mode: 'copy'

    input:
    path(ref)
    tuple val(sample_id), path(reads)

    output:
    path "aligned.sam", emit: alignment

    script:
    """
    cp ${ref} ${params.outdir}/data/
    bwa mem -t 4 -R'@RG\\tID:1\\tLB:library\\tPL:Illumina\\tPU:lane1\\tSM:covid' ${params.outdir}/data/ref.fna ${reads} > aligned.sam
    """
}