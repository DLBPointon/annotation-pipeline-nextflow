params.outdir = "$baseDir/results"
params.sample_name = 'E.coli'

process bwa_mem {
    tag "BWA MEM ALIGN"
    publishDir "${params.outdir}/bwa_aligned/", mode: 'copy'

    input:
    path(ref)
    path(f1)
    path(f2)

    output:
    path "aligned.sam", emit: alignment

    script:
    """
    cp ${ref} ${params.outdir}/data/
    bwa mem -t 4 -R'@RG\\tID:1\\tLB:library\\tPL:Illumina\\tPU:lane1\\tSM:${params.sample_name}' ${params.outdir}/data/ref.fna ${f1} ${f2} > aligned.sam
    """
}