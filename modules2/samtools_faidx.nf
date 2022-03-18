params.outdir = "$baseDir/results"

process samtools_faidx {
    tag "SAMTOOLS FAIDX on $ref"
    publishDir "${params.outdir}/bwa_aligned", mode: 'copy'

    input:
    path(ref)

    output:
    path "${ref}.fai", emit: out_faidx

    script:
    """
    samtools faidx ${ref}
    """
}