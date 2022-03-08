process samtools_index {
    tag "SAMTOOLS_INDEX on $aligned_sorted"
    publishDir "./bwa_aligned", mode: 'copy'

    input:
    path(aligned_sorted)

    output:
    path "aligned_sorted.bam.bai", emit: aligned_index// Needs to be changes by making the input a mapped tuple of ID and file


    script:
    """
    samtools index -@4 ${aligned_sorted}
    """
}