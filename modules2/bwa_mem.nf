params.outdir = "$baseDir/results"

process bwa_mem_samtools {
    tag "BWA MEM ALIGN"
    publishDir "${params.outdir}/bwa_aligned/", mode: 'copy'

    input:
    path(ref)
    tuple path(1paired), path(2paired)

    output:
    path "aligned.sam", emit: alignment

    script:
    """
    bwa mem -t 4 -R'@RG\\tID:1\\tLB:library\\tPL:Illumina\\tPU:lane1\\tSM:human' ${ref} ${1paired} ${2paired} > aligned.sam
    """
}