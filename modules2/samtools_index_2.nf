params.outdir = "$baseDir/results"

process samtools_index_2 {
    tag "SAMTOOLS_INDEX on $aligned_sorted"
    cpus 4
    publishDir "${params.outdir}/mkdup", mode: 'copy'

    input:
    path(aligned_sorted)

    output:
    path "mkdup.bam.bai", emit: aligned_index// Needs to be changes by making the input a mapped tuple of ID and file


    script:
    """
    samtools index -@${task.cpus} ${aligned_sorted}
    """
}