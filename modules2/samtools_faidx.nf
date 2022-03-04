process samtools_faidx {
    tag "SAMTOOLS FAIDX on $ref"
    publishDir "./bwa_aligned", mode: 'move'

    input:
    path(ref)

    output:
    path "${ref}.fai", emit: out_faidx

    script:
    """
    samtools faidx ${ref}
    """
}